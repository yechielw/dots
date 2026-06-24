#!/bin/env bash
for dev in /dev/*; do
  cryptsetup isLuks "$dev" 2>/dev/null && systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 --wipe-slot=tpm2 "$dev"
done

