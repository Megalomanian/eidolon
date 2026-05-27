GW_NAME=eidolon-net GW_COLOR="1;34m" GW_LABEL=network
. /etc/profile.d/eidolon-base.sh 2>/dev/null || true
alias net-scan='gw-net-scan'
alias net-tunnel='gw-net-tunnel'
alias net-traffic='gw-net-traffic'
echo "[net] Tools: nmap, masscan, tshark, chisel, openvpn, wireguard, dnsx, httpx"
