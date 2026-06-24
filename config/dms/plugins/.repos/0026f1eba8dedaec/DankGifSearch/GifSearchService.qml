pragma Singleton
import QtQuick
import Quickshell
import qs.Common

Singleton {
    id: root

    readonly property string baseUrl: "https://api.danklinux.com"
    readonly property string customerId: "dankGifSearch"
    property var results: []
    property bool loading: false
    property int perPage: 24

    signal resultsReady

    function search(query) {
        loading = true;
        const url = baseUrl + "/gifs/search?q=" + encodeURIComponent(query) + "&customer_id=" + customerId + "&per_page=" + perPage + "&content_filter=medium";
        Proc.runCommand("gifSearch", ["curl", "-sS", "--connect-timeout", "5", "--max-time", "10", url], handleResponse, 200);
    }

    function trending() {
        loading = true;
        const url = baseUrl + "/gifs/trending?customer_id=" + customerId + "&per_page=" + perPage;
        Proc.runCommand("gifTrending", ["curl", "-sS", "--connect-timeout", "5", "--max-time", "10", url], handleResponse, 0);
    }

    function handleResponse(output, exitCode) {
        loading = false;

        if (exitCode !== 0) {
            results = [];
            resultsReady();
            return;
        }

        const raw = output.trim();
        if (!raw || raw[0] !== "{") {
            results = [];
            resultsReady();
            return;
        }

        try {
            const response = JSON.parse(raw);
            const data = response.data?.data || response.data || [];
            results = parseResults(Array.isArray(data) ? data : []);
        } catch (e) {
            results = [];
        }
        resultsReady();
    }

    function parseResults(data) {
        const items = [];
        for (let i = 0; i < data.length; i++) {
            const gif = data[i];
            const file = gif.file || {};
            const hd = file.hd || file.sd || {};
            const preview = file.sd || file.hd || {};

            const webpUrl = hd.webp?.url || preview.webp?.url || "";
            const gifUrl = hd.gif?.url || preview.gif?.url || "";
            const mp4Url = hd.mp4?.url || preview.mp4?.url || "";

            items.push({
                id: gif.id || "",
                slug: gif.slug || "",
                title: gif.title || "GIF",
                previewUrl: preview.webp?.url || preview.gif?.url || hd.webp?.url || hd.gif?.url || "",
                webpUrl: webpUrl,
                gifUrl: gifUrl,
                mp4Url: mp4Url,
                originalUrl: webpUrl || gifUrl || mp4Url,
                width: hd.gif?.width || 200,
                height: hd.gif?.height || 200
            });
        }
        return items;
    }

    function clear() {
        results = [];
        loading = false;
    }
}
