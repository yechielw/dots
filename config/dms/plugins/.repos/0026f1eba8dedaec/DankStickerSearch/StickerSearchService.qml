pragma Singleton
import QtQuick
import Quickshell
import qs.Common

Singleton {
    id: root

    readonly property string baseUrl: "https://api.danklinux.com"
    readonly property string customerId: "dankStickerSearch"
    property var results: []
    property var categories: []
    property bool loading: false
    property bool loadingCategories: false
    property int perPage: 24
    property string resultsForQuery: "\x00"
    property int requestCount: 0
    property int responseCount: 0
    property string lastRequestQuery: "\x00"

    signal resultsReady
    signal categoriesReady

    function search(query, categorySearchTerm) {
        var searchQuery = query;
        if (categorySearchTerm && !query)
            searchQuery = categorySearchTerm;
        else if (categorySearchTerm && query)
            searchQuery = categorySearchTerm + " " + query;

        requestCount++;
        lastRequestQuery = searchQuery;
        loading = true;
        var url = baseUrl + "/stickers/search?q=" + encodeURIComponent(searchQuery) + "&customer_id=" + customerId + "&per_page=" + perPage + "&content_filter=medium";
        Proc.runCommand("stickerQuery", ["curl", "-sS", "--connect-timeout", "5", "--max-time", "10", url], handleResponse, 200);
    }

    function trending(categorySearchTerm) {
        requestCount++;
        lastRequestQuery = categorySearchTerm || "";
        loading = true;
        if (categorySearchTerm) {
            var url = baseUrl + "/stickers/search?q=" + encodeURIComponent(categorySearchTerm) + "&customer_id=" + customerId + "&per_page=" + perPage + "&content_filter=medium";
            Proc.runCommand("stickerQuery", ["curl", "-sS", "--connect-timeout", "5", "--max-time", "10", url], handleResponse, 0);
            return;
        }
        var url = baseUrl + "/stickers/trending?customer_id=" + customerId + "&per_page=" + perPage;
        Proc.runCommand("stickerQuery", ["curl", "-sS", "--connect-timeout", "5", "--max-time", "10", url], handleResponse, 0);
    }

    function fetchCategories() {
        if (categories.length > 0)
            return;
        loadingCategories = true;
        var url = baseUrl + "/stickers/categories";
        Proc.runCommand("stickerCategories", ["curl", "-sS", "--connect-timeout", "5", "--max-time", "10", url], handleCategoriesResponse, 0);
    }

    function handleResponse(output, exitCode) {
        responseCount++;
        if (responseCount !== requestCount) {
            return;
        }

        loading = false;

        if (exitCode !== 0) {
            results = [];
            resultsForQuery = lastRequestQuery;
            resultsReady();
            return;
        }

        const raw = output.trim();
        if (!raw || raw[0] !== "{") {
            results = [];
            resultsForQuery = lastRequestQuery;
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
        resultsForQuery = lastRequestQuery;
        resultsReady();
    }

    function handleCategoriesResponse(output, exitCode) {
        loadingCategories = false;

        if (exitCode !== 0) {
            categories = [];
            categoriesReady();
            return;
        }

        const raw = output.trim();
        if (!raw || raw[0] !== "{") {
            categories = [];
            categoriesReady();
            return;
        }

        try {
            const response = JSON.parse(raw);
            const data = response.data?.categories || response.data || [];
            categories = parseCategoriesResponse(Array.isArray(data) ? data : []);
        } catch (e) {
            categories = [];
        }
        categoriesReady();
    }

    function parseCategoriesResponse(data) {
        const items = [];
        for (let i = 0; i < data.length; i++) {
            const cat = data[i];
            items.push({
                id: cat.query || cat.category || "",
                name: cat.category || cat.name || "",
                searchTerm: cat.query || cat.category || ""
            });
        }
        return items;
    }

    function parseResults(data) {
        const items = [];
        for (let i = 0; i < data.length; i++) {
            const sticker = data[i];
            const file = sticker.file || {};
            const hd = file.hd || file.sd || {};
            const preview = file.sd || file.hd || {};

            const webpUrl = hd.webp?.url || preview.webp?.url || "";
            const gifUrl = hd.gif?.url || preview.gif?.url || "";
            const mp4Url = hd.mp4?.url || preview.mp4?.url || "";

            items.push({
                id: sticker.id || "",
                slug: sticker.slug || "",
                title: sticker.title || "Sticker",
                previewUrl: preview.webp?.url || preview.gif?.url || preview.png?.url || hd.webp?.url || hd.gif?.url || hd.png?.url || "",
                webpUrl: webpUrl,
                gifUrl: gifUrl,
                mp4Url: mp4Url,
                originalUrl: webpUrl || gifUrl || mp4Url,
                width: hd.gif?.width || hd.png?.width || 200,
                height: hd.gif?.height || hd.png?.height || 200
            });
        }
        return items;
    }

    function clear() {
        results = [];
        loading = false;
    }
}
