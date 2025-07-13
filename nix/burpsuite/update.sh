#!/usr/bin/env sh
set -eu -o pipefail
curl -s 'https://portswigger.net/burp/releases/data' | jq -r '[[.ResultSet.Results[] | select ((.categories | sort) == (["Professional", "Community"] | sort) and .releaseChannels == ["Early Adopter"])][0].builds[] | select (.ProductPlatform == "Jar")]' > latest.json
echo sha265-$(cat latest.json | jq '.[] | select ( .ProductId == "community") .Sha256Checksum' -r | xxd -r -p | base64)
echo sha265-$(cat latest.json | jq '.[] | select ( .ProductId == "pro") .Sha256Checksum' -r | xxd -r -p | base64)
cat latest.json | jq '.[0].Version' -r


