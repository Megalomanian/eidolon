GW_NAME=eidolon-mobile GW_COLOR="1;35m" GW_LABEL=mobile
. /etc/profile.d/eidolon-base.sh 2>/dev/null || true
alias mobile-apk='gw-mobile-apk'
alias mobile-ios='gw-mobile-ios'
alias mobile-frida='gw-mobile-frida'
echo "[mobile] Android: jadx, apkid, objection, adb, aapt, androguard"
echo "[mobile] iOS: idevice, radare2, objection, frida, ipatool"
