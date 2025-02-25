#!/usr/bin/env sh
set -eu -o pipefail
curl -s 'https://portswigger.net/burp/releases/data' | jq -r '[[.ResultSet.Results[] | select (.categories == ["Professional", "Community"] and .releaseChannels == ["Stable"])][0].builds[] | select (.ProductPlatform == "Jar")]' >> new.json


