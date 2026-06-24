// ANSI escape sequence parser for QtQuick
// Converts ANSI color codes to HTML/RichText format

// ANSI color codes mapping to CSS colors
const ansiColors = {
    // Standard colors
    30: "#000000", // Black
    31: "#e06c75", // Red
    32: "#98c379", // Green
    33: "#d19a66", // Yellow
    34: "#61afef", // Blue
    35: "#c678dd", // Magenta
    36: "#56b6c2", // Cyan
    37: "#abb2bf", // White
    90: "#5c6370", // Bright Black (Gray)
    91: "#e06c75", // Bright Red
    92: "#98c379", // Bright Green
    93: "#d19a66", // Bright Yellow
    94: "#61afef", // Bright Blue
    95: "#c678dd", // Bright Magenta
    96: "#56b6c2", // Bright Cyan
    97: "#ffffff", // Bright White
}

// Background colors
const ansiBgColors = {
    40: "#000000",
    41: "#e06c75",
    42: "#98c379",
    43: "#d19a66",
    44: "#61afef",
    45: "#c678dd",
    46: "#56b6c2",
    47: "#abb2bf",
    100: "#5c6370",
    101: "#e06c75",
    102: "#98c379",
    103: "#d19a66",
    104: "#61afef",
    105: "#c678dd",
    106: "#56b6c2",
    107: "#ffffff",
}

// 256-color palette (xterm colors)
const xterm256Colors = [
    // 0-15: Basic colors (already defined above, but included for completeness)
    "#000000", "#800000", "#008000", "#808000", "#000080", "#800080", "#008080", "#c0c0c0",
    "#808080", "#ff0000", "#00ff00", "#ffff00", "#0000ff", "#ff00ff", "#00ffff", "#ffffff",
    // 16-231: 216 color cube (6x6x6)
    "#000000", "#00005f", "#000087", "#0000af", "#0000d7", "#0000ff",
    "#005f00", "#005f5f", "#005f87", "#005faf", "#005fd7", "#005fff",
    "#008700", "#00875f", "#008787", "#0087af", "#0087d7", "#0087ff",
    "#00af00", "#00af5f", "#00af87", "#00afaf", "#00afd7", "#00afff",
    "#00d700", "#00d75f", "#00d787", "#00d7af", "#00d7d7", "#00d7ff",
    "#00ff00", "#00ff5f", "#00ff87", "#00ffaf", "#00ffd7", "#00ffff",
    "#5f0000", "#5f005f", "#5f0087", "#5f00af", "#5f00d7", "#5f00ff",
    "#5f5f00", "#5f5f5f", "#5f5f87", "#5f5faf", "#5f5fd7", "#5f5fff",
    "#5f8700", "#5f875f", "#5f8787", "#5f87af", "#5f87d7", "#5f87ff",
    "#5faf00", "#5faf5f", "#5faf87", "#5fafaf", "#5fafd7", "#5fafff",
    "#5fd700", "#5fd75f", "#5fd787", "#5fd7af", "#5fd7d7", "#5fd7ff",
    "#5fff00", "#5fff5f", "#5fff87", "#5fffaf", "#5fffd7", "#5fffff",
    "#870000", "#87005f", "#870087", "#8700af", "#8700d7", "#8700ff",
    "#875f00", "#875f5f", "#875f87", "#875faf", "#875fd7", "#875fff",
    "#878700", "#87875f", "#878787", "#8787af", "#8787d7", "#8787ff",
    "#87af00", "#87af5f", "#87af87", "#87afaf", "#87afd7", "#87afff",
    "#87d700", "#87d75f", "#87d787", "#87d7af", "#87d7d7", "#87d7ff",
    "#87ff00", "#87ff5f", "#87ff87", "#87ffaf", "#87ffd7", "#87ffff",
    "#af0000", "#af005f", "#af0087", "#af00af", "#af00d7", "#af00ff",
    "#af5f00", "#af5f5f", "#af5f87", "#af5faf", "#af5fd7", "#af5fff",
    "#af8700", "#af875f", "#af8787", "#af87af", "#af87d7", "#af87ff",
    "#afaf00", "#afaf5f", "#afaf87", "#afafaf", "#afafd7", "#afafff",
    "#afd700", "#afd75f", "#afd787", "#afd7af", "#afd7d7", "#afd7ff",
    "#afff00", "#afff5f", "#afff87", "#afffaf", "#afffd7", "#afffff",
    "#d70000", "#d7005f", "#d70087", "#d700af", "#d700d7", "#d700ff",
    "#d75f00", "#d75f5f", "#d75f87", "#d75faf", "#d75fd7", "#d75fff",
    "#d78700", "#d7875f", "#d78787", "#d787af", "#d787d7", "#d787ff",
    "#d7af00", "#d7af5f", "#d7af87", "#d7afaf", "#d7afd7", "#d7afff",
    "#d7d700", "#d7d75f", "#d7d787", "#d7d7af", "#d7d7d7", "#d7d7ff",
    "#d7ff00", "#d7ff5f", "#d7ff87", "#d7ffaf", "#d7ffd7", "#d7ffff",
    "#ff0000", "#ff005f", "#ff0087", "#ff00af", "#ff00d7", "#ff00ff",
    "#ff5f00", "#ff5f5f", "#ff5f87", "#ff5faf", "#ff5fd7", "#ff5fff",
    "#ff8700", "#ff875f", "#ff8787", "#ff87af", "#ff87d7", "#ff87ff",
    "#ffaf00", "#ffaf5f", "#ffaf87", "#ffafaf", "#ffafd7", "#ffafff",
    "#ffd700", "#ffd75f", "#ffd787", "#ffd7af", "#ffd7d7", "#ffd7ff",
    "#ffff00", "#ffff5f", "#ffff87", "#ffffaf", "#ffffd7", "#ffffff",
    // 232-255: Grayscale
    "#080808", "#121212", "#1c1c1c", "#262626", "#303030", "#3a3a3a",
    "#444444", "#4e4e4e", "#585858", "#626262", "#6c6c6c", "#767676",
    "#808080", "#8a8a8a", "#949494", "#9e9e9e", "#a8a8a8", "#b2b2b2",
    "#bcbcbc", "#c6c6c6", "#d0d0d0", "#dadada", "#e4e4e4", "#eeeeee"
]

/**
 * Convert RGB values to hex color
 */
function rgbToHex(r, g, b) {
    // Normalize and clamp each channel to the 0-255 range
    function clampChannel(value) {
        let num = Number(value)
        if (!Number.isFinite(num)) {
            num = 0
        }
        num = Math.round(num)
        if (num < 0) num = 0
        if (num > 255) num = 255
        return num
    }

    const cr = clampChannel(r)
    const cg = clampChannel(g)
    const cb = clampChannel(b)

    return "#" +
        cr.toString(16).padStart(2, '0') +
        cg.toString(16).padStart(2, '0') +
        cb.toString(16).padStart(2, '0')
}

/**
 * Parse ANSI escape sequences and convert to HTML
 * @param {string} text - Text with ANSI codes
 * @returns {string} HTML formatted text
 */
function parseAnsiToHtml(text) {
    if (!text) return ""

    // Remove carriage returns and normalize line endings
    text = text.replace(/\r\n/g, "\n").replace(/\r/g, "\n")

    // Split by ANSI escape sequences
    const parts = text.split(/(\x1b\[[0-9;]*m)/g)

    let html = ""
    let currentStyle = {
        color: null,
        bgColor: null,
        bold: false,
        underline: false,
        italic: false
    }

    for (let part of parts) {
        if (!part) continue

        // Check if this is an ANSI escape sequence
        const match = part.match(/^\x1b\[([0-9;]*)m$/)
        if (match) {
            // Parse the escape sequence
            const codes = match[1].split(';').map(Number)

            let i = 0
            while (i < codes.length) {
                const code = codes[i]
                
                if (code === 0) {
                    // Reset all styles
                    currentStyle = {
                        color: null,
                        bgColor: null,
                        bold: false,
                        underline: false,
                        italic: false
                    }
                } else if (code === 1) {
                    currentStyle.bold = true
                } else if (code === 3) {
                    currentStyle.italic = true
                } else if (code === 4) {
                    currentStyle.underline = true
                } else if (code === 22) {
                    currentStyle.bold = false
                    currentStyle.italic = false
                } else if (code === 23) {
                    currentStyle.italic = false
                } else if (code === 24) {
                    currentStyle.underline = false
                } else if (code === 39) {
                    currentStyle.color = null
                } else if (code === 49) {
                    currentStyle.bgColor = null
                } else if (code === 38 && i + 1 < codes.length) {
                    // Extended foreground color
                    if (codes[i + 1] === 5 && i + 2 < codes.length) {
                        // 256-color palette: ESC[38;5;Nm
                        const colorIndex = codes[i + 2]
                        if (colorIndex >= 0 && colorIndex < 256) {
                            currentStyle.color = xterm256Colors[colorIndex]
                        }
                        i += 2
                    } else if (codes[i + 1] === 2 && i + 4 < codes.length) {
                        // True color RGB: ESC[38;2;R;G;Bm
                        const r = codes[i + 2]
                        const g = codes[i + 3]
                        const b = codes[i + 4]
                        currentStyle.color = rgbToHex(r, g, b)
                        i += 4
                    }
                } else if (code === 48 && i + 1 < codes.length) {
                    // Extended background color
                    if (codes[i + 1] === 5 && i + 2 < codes.length) {
                        // 256-color palette: ESC[48;5;Nm
                        const colorIndex = codes[i + 2]
                        if (colorIndex >= 0 && colorIndex < 256) {
                            currentStyle.bgColor = xterm256Colors[colorIndex]
                        }
                        i += 2
                    } else if (codes[i + 1] === 2 && i + 4 < codes.length) {
                        // True color RGB: ESC[48;2;R;G;Bm
                        const r = codes[i + 2]
                        const g = codes[i + 3]
                        const b = codes[i + 4]
                        currentStyle.bgColor = rgbToHex(r, g, b)
                        i += 4
                    }
                } else if (ansiColors[code]) {
                    currentStyle.color = ansiColors[code]
                } else if (ansiBgColors[code]) {
                    currentStyle.bgColor = ansiBgColors[code]
                }
                
                i++
            }
        } else {
            // Regular text - apply current styles
            let styledText = escapeHtml(part)
            if (currentStyle.color || currentStyle.bgColor || currentStyle.bold || currentStyle.underline || currentStyle.italic) {
                let styleAttrs = []

                if (currentStyle.color) {
                    styleAttrs.push(`color:${currentStyle.color}`)
                }
                if (currentStyle.bgColor) {
                    styleAttrs.push(`background-color:${currentStyle.bgColor}`)
                }
                if (currentStyle.bold) {
                    styleAttrs.push("font-weight:bold")
                }
                if (currentStyle.italic) {
                    styleAttrs.push("font-style:italic")
                }
                if (currentStyle.underline) {
                    styleAttrs.push("text-decoration:underline")
                }

                if (styleAttrs.length > 0) {
                    styledText = `<span style="${styleAttrs.join(';')}">${styledText}</span>`
                }
            }
            html += styledText
        }
    }

    return html
}

/**
 * Escape HTML special characters
 */
function escapeHtml(text) {
    return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;")
        .replace(/\n/g, "<br>")
}
