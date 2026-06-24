pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.Services

Singleton {
    id: root

    readonly property string clightService: "org.clight.clight"
    readonly property string clightdService: "org.clightd.clightd"
    readonly property string clightPath: "/org/clight/clight"
    readonly property string clightInterface: "org.clight.clight"
    readonly property string confPath: "/org/clight/clight/Conf"
    readonly property string backlight2Path: "/org/clightd/clightd/Backlight2"

    property bool available: false
    property bool initialized: false
    property bool _subscribed: false

    property bool suspended: false
    property bool inhibited: false
    property bool pmInhibited: false
    property bool sensorAvailable: false
    property bool lidClosed: false
    property bool inEvent: false
    property int dayTime: 0
    property int acState: 0
    property int displayState: 1

    property real blPct: 0
    property real kbdPct: 0
    property real ambientBr: 0
    property real screenBr: 0
    property int temp: 0
    property real latitude: 0
    property real longitude: 0
    property var sunrise: null
    property var sunset: null

    property bool blNoAutoCalib: false
    property bool blNoSmooth: false
    property bool blInhibitOnLidClosed: false
    property bool blCaptureOnLidOpened: false
    property real blTransStep: 0.05
    property int blTransDuration: 30
    property int blAcDayTimeout: 600
    property int blAcNightTimeout: 2700
    property int blAcEventTimeout: 300
    property int blBattDayTimeout: 1200
    property int blBattNightTimeout: 5400
    property int blBattEventTimeout: 600

    property bool dimNoSmoothEnter: false
    property bool dimNoSmoothExit: false
    property real dimmedPct: 0.2
    property int dimAcTimeout: 45
    property int dimBattTimeout: 20

    property int dpmsAcTimeout: 900
    property int dpmsBattTimeout: 300

    property int kbdAcTimeout: 15
    property int kbdBattTimeout: 5

    property int daytimeEventDuration: 1800
    property int daytimeSunriseOffset: 0
    property int daytimeSunsetOffset: 0

    property bool inhibitDocked: false
    property bool inhibitPM: false
    property bool inhibitBL: false

    property var backlights: []

    readonly property bool onBattery: acState === 1
    readonly property int ambientPercent: Math.round(ambientBr * 100)
    readonly property int blPercent: Math.round(blPct * 100)

    readonly property string dayTimeText: {
        if (dayTime === 0)
            return "Day";
        if (dayTime === 1)
            return "Night";
        if (dayTime === 2)
            return "Event";
        return "Unknown";
    }

    readonly property string acStateText: onBattery ? "Battery" : "AC"

    readonly property string locationText: {
        if (latitude === 91 && longitude === 181)
            return "Auto";
        if (latitude === 0 && longitude === 0)
            return "Not set";
        return latitude.toFixed(2) + ", " + longitude.toFixed(2);
    }

    readonly property int currentCaptureTimeout: {
        if (onBattery) {
            if (dayTime === 0)
                return blBattDayTimeout;
            if (dayTime === 1)
                return blBattNightTimeout;
            return blBattEventTimeout;
        }
        if (dayTime === 0)
            return blAcDayTimeout;
        if (dayTime === 1)
            return blAcNightTimeout;
        return blAcEventTimeout;
    }

    readonly property int currentDimTimeout: onBattery ? dimBattTimeout : dimAcTimeout
    readonly property int currentDpmsTimeout: onBattery ? dpmsBattTimeout : dpmsAcTimeout
    readonly property int currentKbdTimeout: onBattery ? kbdBattTimeout : kbdAcTimeout

    Component.onCompleted: {
        if (DMSService.isConnected) {
            checkAvailability();
            subscribeToSignals();
        }
    }

    Connections {
        target: DMSService

        function onConnectionStateChanged() {
            if (!DMSService.isConnected) {
                available = false;
                initialized = false;
                _subscribed = false;
                return;
            }
            checkAvailability();
            subscribeToSignals();
        }

        function onDbusSignalReceived(subId, data) {
            handleDbusSignal(data);
        }
    }

    function subscribeToSignals() {
        if (_subscribed)
            return;
        _subscribed = true;

        DMSService.dbusSubscribe("session", clightService, "", "", "", response => {
            if (response.error) {
                console.warn("[Clight] Subscription failed:", response.error);
                _subscribed = false;
            }
        });

        DMSService.dbusSubscribe("system", clightdService, "", "", "", response => {
            if (response.error) {
                console.warn("[Clight] Clightd subscription failed:", response.error);
            }
        });
    }

    function checkAvailability() {
        DMSService.dbusListNames("session", response => {
            if (response.error) {
                available = false;
                return;
            }
            const names = response.result?.names || [];
            const wasAvailable = available;
            available = names.includes(clightService);

            if (available && !initialized) {
                initialize();
            }
            if (!available && wasAvailable) {
                initialized = false;
                backlights = [];
            }
        });
    }

    function initialize() {
        initialized = true;
        fetchClightState();
        fetchBacklightConfig();
        fetchDimmerConfig();
        fetchDpmsConfig();
        fetchKbdConfig();
        fetchDaytimeConfig();
        fetchInhibitConfig();
        fetchBacklights();
    }

    function handleDbusSignal(data) {
        if (data.member === "PropertiesChanged") {
            const iface = data.body?.[0] || "";
            const changed = data.body?.[1] || {};

            if (iface === clightInterface) {
                applyClightProperties(changed);
            } else if (iface.startsWith("org.clight.clight.Conf")) {
                applyConfigProperties(iface, changed);
            } else if (iface === "org.clightd.clightd.Backlight2.Server") {
                const blName = extractBacklightName(data.path);
                if (blName && changed.brightness !== undefined) {
                    updateBacklightBrightness(blName, changed.brightness);
                }
            }
        } else if (data.member === "Changed" && data.path?.includes("Backlight2")) {
            const blName = extractBacklightName(data.path);
            const brightness = data.body?.[0];
            if (blName && brightness !== undefined) {
                updateBacklightBrightness(blName, brightness);
            }
        }
    }

    function extractBacklightName(path) {
        if (!path?.includes("Backlight2/"))
            return null;
        return path.split("Backlight2/")[1]?.split("/")[0] || null;
    }

    function applyClightProperties(props) {
        if (props.Suspended !== undefined)
            suspended = props.Suspended;
        if (props.Inhibited !== undefined)
            inhibited = props.Inhibited;
        if (props.PmInhibited !== undefined)
            pmInhibited = props.PmInhibited;
        if (props.SensorAvail !== undefined)
            sensorAvailable = props.SensorAvail;
        if (props.LidState !== undefined)
            lidClosed = props.LidState === 1;
        if (props.InEvent !== undefined)
            inEvent = props.InEvent;
        if (props.DayTime !== undefined)
            dayTime = props.DayTime;
        if (props.AcState !== undefined)
            acState = props.AcState;
        if (props.DisplayState !== undefined)
            displayState = props.DisplayState;
        if (props.BlPct !== undefined)
            blPct = props.BlPct;
        if (props.KbdPct !== undefined)
            kbdPct = props.KbdPct;
        if (props.AmbientBr !== undefined)
            ambientBr = props.AmbientBr;
        if (props.ScreenBr !== undefined)
            screenBr = props.ScreenBr;
        if (props.Temp !== undefined)
            temp = props.Temp;
        if (props.Location !== undefined) {
            latitude = props.Location[0] || 0;
            longitude = props.Location[1] || 0;
        }
        if (props.Sunrise !== undefined) {
            sunrise = props.Sunrise > 0 ? new Date(props.Sunrise * 1000) : null;
        }
        if (props.Sunset !== undefined) {
            sunset = props.Sunset > 0 ? new Date(props.Sunset * 1000) : null;
        }
    }

    function applyConfigProperties(iface, props) {
        if (iface.endsWith(".Backlight")) {
            if (props.NoAutoCalib !== undefined)
                blNoAutoCalib = props.NoAutoCalib;
            if (props.NoSmooth !== undefined)
                blNoSmooth = props.NoSmooth;
            if (props.InhibitOnLidClosed !== undefined)
                blInhibitOnLidClosed = props.InhibitOnLidClosed;
            if (props.CaptureOnLidOpened !== undefined)
                blCaptureOnLidOpened = props.CaptureOnLidOpened;
            if (props.TransStep !== undefined)
                blTransStep = props.TransStep;
            if (props.TransDuration !== undefined)
                blTransDuration = props.TransDuration;
            if (props.AcDayTimeout !== undefined)
                blAcDayTimeout = props.AcDayTimeout;
            if (props.AcNightTimeout !== undefined)
                blAcNightTimeout = props.AcNightTimeout;
            if (props.AcEventTimeout !== undefined)
                blAcEventTimeout = props.AcEventTimeout;
            if (props.BattDayTimeout !== undefined)
                blBattDayTimeout = props.BattDayTimeout;
            if (props.BattNightTimeout !== undefined)
                blBattNightTimeout = props.BattNightTimeout;
            if (props.BattEventTimeout !== undefined)
                blBattEventTimeout = props.BattEventTimeout;
        } else if (iface.endsWith(".Dimmer")) {
            if (props.NoSmoothEnter !== undefined)
                dimNoSmoothEnter = props.NoSmoothEnter;
            if (props.NoSmoothExit !== undefined)
                dimNoSmoothExit = props.NoSmoothExit;
            if (props.DimmedPct !== undefined)
                dimmedPct = props.DimmedPct;
            if (props.AcTimeout !== undefined)
                dimAcTimeout = props.AcTimeout;
            if (props.BattTimeout !== undefined)
                dimBattTimeout = props.BattTimeout;
        } else if (iface.endsWith(".Dpms")) {
            if (props.AcTimeout !== undefined)
                dpmsAcTimeout = props.AcTimeout;
            if (props.BattTimeout !== undefined)
                dpmsBattTimeout = props.BattTimeout;
        } else if (iface.endsWith(".Kbd")) {
            if (props.AcTimeout !== undefined)
                kbdAcTimeout = props.AcTimeout;
            if (props.BattTimeout !== undefined)
                kbdBattTimeout = props.BattTimeout;
        } else if (iface.endsWith(".Daytime")) {
            if (props.EventDuration !== undefined)
                daytimeEventDuration = props.EventDuration;
            if (props.SunriseOffset !== undefined)
                daytimeSunriseOffset = props.SunriseOffset;
            if (props.SunsetOffset !== undefined)
                daytimeSunsetOffset = props.SunsetOffset;
        } else if (iface.endsWith(".Inhibit")) {
            if (props.InhibitDocked !== undefined)
                inhibitDocked = props.InhibitDocked;
            if (props.InhibitPM !== undefined)
                inhibitPM = props.InhibitPM;
            if (props.InhibitBL !== undefined)
                inhibitBL = props.InhibitBL;
        }
    }

    function fetchClightState() {
        DMSService.dbusGetAllProperties("session", clightService, clightPath, clightInterface, response => {
            if (response.error)
                return;
            const props = response.result || {};
            applyClightProperties(props);
        });
    }

    function fetchBacklightConfig() {
        DMSService.dbusGetAllProperties("session", clightService, confPath + "/Backlight", "org.clight.clight.Conf.Backlight", response => {
            if (response.error)
                return;
            applyConfigProperties("org.clight.clight.Conf.Backlight", response.result || {});
        });
    }

    function fetchDimmerConfig() {
        DMSService.dbusGetAllProperties("session", clightService, confPath + "/Dimmer", "org.clight.clight.Conf.Dimmer", response => {
            if (response.error)
                return;
            applyConfigProperties("org.clight.clight.Conf.Dimmer", response.result || {});
        });
    }

    function fetchDpmsConfig() {
        DMSService.dbusGetAllProperties("session", clightService, confPath + "/Dpms", "org.clight.clight.Conf.Dpms", response => {
            if (response.error)
                return;
            applyConfigProperties("org.clight.clight.Conf.Dpms", response.result || {});
        });
    }

    function fetchKbdConfig() {
        DMSService.dbusGetAllProperties("session", clightService, confPath + "/Kbd", "org.clight.clight.Conf.Kbd", response => {
            if (response.error)
                return;
            applyConfigProperties("org.clight.clight.Conf.Kbd", response.result || {});
        });
    }

    function fetchDaytimeConfig() {
        DMSService.dbusGetAllProperties("session", clightService, confPath + "/Daytime", "org.clight.clight.Conf.Daytime", response => {
            if (response.error)
                return;
            applyConfigProperties("org.clight.clight.Conf.Daytime", response.result || {});
        });
    }

    function fetchInhibitConfig() {
        DMSService.dbusGetAllProperties("session", clightService, confPath + "/Inhibit", "org.clight.clight.Conf.Inhibit", response => {
            if (response.error)
                return;
            applyConfigProperties("org.clight.clight.Conf.Inhibit", response.result || {});
        });
    }

    function fetchBacklights() {
        DMSService.dbusCall("system", clightdService, "/org/clightd/clightd/Backlight", "org.clightd.clightd.Backlight", "GetAll", [""], response => {
            if (response.error) {
                console.warn("[Clight] fetchBacklights error:", response.error);
                return;
            }

            const blList = response.result?.values?.[0] || [];
            if (blList.length === 0) {
                backlights = [];
                return;
            }

            let pending = 0;
            let newBacklights = [];

            for (let i = 0; i < blList.length; i++) {
                const item = blList[i];
                let name, brightness;

                if (Array.isArray(item)) {
                    name = item[0];
                    brightness = item[1];
                } else if (typeof item === "object" && item !== null) {
                    name = item["0"] || item.name || item[0];
                    brightness = item["1"] || item.brightness || item[1] || 0;
                } else if (typeof item === "string" && i + 1 < blList.length) {
                    name = item;
                    brightness = blList[i + 1];
                    i++;
                } else {
                    continue;
                }

                if (!name || typeof name !== "string" || name.length === 0)
                    continue;
                if (!isValidDbusPathSegment(name))
                    continue;

                pending++;
                fetchBacklightInfo(name, brightness || 0, info => {
                    newBacklights.push(info);
                    pending--;
                    if (pending === 0) {
                        backlights = newBacklights.sort((a, b) => {
                            if (a.internal && !b.internal)
                                return -1;
                            if (!a.internal && b.internal)
                                return 1;
                            return a.name.localeCompare(b.name);
                        });
                    }
                });
            }

            if (pending === 0)
                backlights = [];
        });
    }

    function isValidDbusPathSegment(name) {
        if (!name || typeof name !== "string")
            return false;
        return /^[A-Za-z0-9_]+$/.test(name);
    }

    function fetchBacklightInfo(name, brightness, callback) {
        const path = backlight2Path + "/" + name;
        DMSService.dbusGetAllProperties("system", clightdService, path, "org.clightd.clightd.Backlight2.Server", response => {
            if (response.error) {
                callback({
                    name: name,
                    brightness: brightness,
                    percent: Math.round(brightness * 100),
                    ddc: false,
                    emulated: false,
                    internal: false,
                    max: 100
                });
                return;
            }
            const props = response.result || {};
            callback({
                name: name,
                brightness: brightness,
                percent: Math.round(brightness * 100),
                ddc: props.DDC || false,
                emulated: props.Emulated || false,
                internal: props.Internal || false,
                max: props.Max || 100
            });
        });
    }

    function updateBacklightBrightness(name, brightness) {
        let updated = false;
        const newBacklights = backlights.map(bl => {
            if (bl.name === name) {
                updated = true;
                return Object.assign({}, bl, {
                    brightness: brightness,
                    percent: Math.round(brightness * 100)
                });
            }
            return bl;
        });
        if (updated) {
            backlights = newBacklights;
        }
    }

    function capture(smoothOrUpTarget, downTarget) {
        DMSService.dbusCall("session", clightService, clightPath, clightInterface, "Capture", [smoothOrUpTarget, downTarget], response => {
            if (response.error) {
                console.warn("[Clight] Capture failed:", response.error);
            }
        });
    }

    function setPaused(paused) {
        DMSService.dbusCall("session", clightService, clightPath, clightInterface, "Pause", [paused], response => {
            if (response.error) {
                console.warn("[Clight] Pause failed:", response.error);
            }
        });
    }

    function setInhibit(inhibit) {
        DMSService.dbusCall("session", clightService, clightPath, clightInterface, "Inhibit", [inhibit], response => {
            if (response.error) {
                console.warn("[Clight] Inhibit failed:", response.error);
            }
        });
    }

    function incBrightness(step) {
        DMSService.dbusCall("session", clightService, clightPath, clightInterface, "IncBl", [step || 0.05], response => {
            if (response.error) {
                console.warn("[Clight] IncBl failed:", response.error);
            }
        });
    }

    function decBrightness(step) {
        DMSService.dbusCall("session", clightService, clightPath, clightInterface, "DecBl", [step || 0.05], response => {
            if (response.error) {
                console.warn("[Clight] DecBl failed:", response.error);
            }
        });
    }

    function setBacklightProp(prop, value) {
        DMSService.dbusSetProperty("session", clightService, confPath + "/Backlight", "org.clight.clight.Conf.Backlight", prop, value, response => {
            if (response.error) {
                console.warn("[Clight] Set backlight prop failed:", response.error);
            } else {
                fetchBacklightConfig();
            }
        });
    }

    function setDimmerProp(prop, value) {
        DMSService.dbusSetProperty("session", clightService, confPath + "/Dimmer", "org.clight.clight.Conf.Dimmer", prop, value, response => {
            if (response.error) {
                console.warn("[Clight] Set dimmer prop failed:", response.error);
            } else {
                fetchDimmerConfig();
            }
        });
    }

    function setDpmsProp(prop, value) {
        DMSService.dbusSetProperty("session", clightService, confPath + "/Dpms", "org.clight.clight.Conf.Dpms", prop, value, response => {
            if (response.error) {
                console.warn("[Clight] Set DPMS prop failed:", response.error);
            } else {
                fetchDpmsConfig();
            }
        });
    }

    function setKbdProp(prop, value) {
        DMSService.dbusSetProperty("session", clightService, confPath + "/Kbd", "org.clight.clight.Conf.Kbd", prop, value, response => {
            if (response.error) {
                console.warn("[Clight] Set kbd prop failed:", response.error);
            } else {
                fetchKbdConfig();
            }
        });
    }

    function setInhibitProp(prop, value) {
        DMSService.dbusSetProperty("session", clightService, confPath + "/Inhibit", "org.clight.clight.Conf.Inhibit", prop, value, response => {
            if (response.error) {
                console.warn("[Clight] Set inhibit prop failed:", response.error);
            } else {
                fetchInhibitConfig();
            }
        });
    }

    function setBacklightBrightness(blName, brightness) {
        const path = backlight2Path + "/" + blName;
        DMSService.dbusCall("system", clightdService, path, "org.clightd.clightd.Backlight2.Server", "Set", [brightness, [0, 0]], response => {
            if (response.error) {
                console.warn("[Clight] Set backlight brightness failed:", response.error);
            }
        });
    }

    function getBacklightIcon() {
        if (blPct >= 0.9)
            return "brightness_high";
        if (blPct >= 0.5)
            return "brightness_medium";
        if (blPct >= 0.2)
            return "brightness_low";
        return "brightness_low";
    }

    function getDayTimeIcon() {
        if (dayTime === 0)
            return "light_mode";
        if (dayTime === 1)
            return "dark_mode";
        return "twilight";
    }

    function getBacklightTypeIcon(bl) {
        if (!bl)
            return "desktop_windows";
        if (bl.ddc)
            return "monitor";
        if (bl.internal)
            return "laptop";
        return "desktop_windows";
    }

    function formatTimeout(seconds) {
        if (seconds <= 0)
            return "Disabled";
        if (seconds < 60)
            return seconds + "s";
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        if (secs === 0)
            return mins + "m";
        return mins + "m " + secs + "s";
    }

    function refresh() {
        if (!available) {
            checkAvailability();
            return;
        }
        fetchClightState();
        fetchBacklightConfig();
        fetchDimmerConfig();
        fetchDpmsConfig();
        fetchKbdConfig();
        fetchDaytimeConfig();
        fetchInhibitConfig();
        fetchBacklights();
    }
}
