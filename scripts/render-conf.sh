#!/usr/bin/env bash
# Render freeswitch/conf/*.tpl + image defaults into ./conf-rendered using ./.env
set -euo pipefail
cd "$(dirname "$0")/.."

[ -f .env ] || { echo "missing .env (copy .env.example)"; exit 1; }
set -a; . ./.env; set +a

IMAGE=$(grep -oP 'image:\s*\K\S+' docker-compose.yml | head -1)

# ESL password: generate once, persist in .env
if [ -z "${ESL_PASSWORD:-}" ]; then
  ESL_PASSWORD=$(head -c 24 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 24)
  sed -i "s|^ESL_PASSWORD=.*|ESL_PASSWORD=${ESL_PASSWORD}|" .env
  echo "generated ESL_PASSWORD into .env"
fi

# Registration vs IP-auth
REGISTER=false
if [ -n "${BD_TRUNK_PASSWORD:-}" ] && [ "${BD_TRUNK_PASSWORD}" != "YOUR_PASSWORD" ]; then
  REGISTER=true
else
  echo "NOTE: BD_TRUNK_PASSWORD not set -> gateway rendered with register=false (IP-auth mode)"
  BD_TRUNK_PASSWORD=unused
fi

out=conf-rendered
rm -rf "$out"; mkdir -p "$out/sip_profiles" "$out/dialplan"

sub() {
  sed -e "s|__PUBLIC_IP__|${PUBLIC_IP}|g" \
      -e "s|__SIP_PORT__|${SIP_PORT}|g" \
      -e "s|__BD_TRUNK_HOST__|${BD_TRUNK_HOST}|g" \
      -e "s|__BD_TRUNK_USER__|${BD_TRUNK_USER}|g" \
      -e "s|__BD_TRUNK_PASSWORD__|${BD_TRUNK_PASSWORD}|g" \
      -e "s|__REGISTER__|${REGISTER}|g" \
      -e "s|__ESL_PASSWORD__|${ESL_PASSWORD}|g" "$1"
}

sub freeswitch/conf/vars_diff.xml.tpl                        > "$out/vars_diff.xml"
sub freeswitch/conf/sip_profiles/mrf.xml.tpl                 > "$out/sip_profiles/mrf.xml"
sub freeswitch/conf/dialplan/mrf.xml.tpl                     > "$out/dialplan/mrf.xml"
sub freeswitch/conf/autoload_configs/event_socket.conf.xml.tpl > "$out/event_socket.conf.xml"

# Patch image defaults: RTP range, and add "provider" ACL.
C=/usr/local/freeswitch/conf/autoload_configs
docker run --rm --entrypoint cat "$IMAGE" $C/switch.conf.xml \
  | sed -e "s|name=\"rtp-start-port\" value=\"[0-9]*\"|name=\"rtp-start-port\" value=\"${RTP_START}\"|" \
        -e "s|name=\"rtp-end-port\" value=\"[0-9]*\"|name=\"rtp-end-port\" value=\"${RTP_END}\"|" \
  > "$out/switch.conf.xml"

docker run --rm --entrypoint cat "$IMAGE" $C/acl.conf.xml \
  | sed -e "s|</network-lists>|<list name=\"provider\" default=\"deny\"><node type=\"allow\" cidr=\"${BD_TRUNK_HOST}/32\"/></list></network-lists>|" \
  > "$out/acl.conf.xml"

grep -q 'name="provider"' "$out/acl.conf.xml" || { echo "ACL patch failed"; exit 1; }
grep -q "value=\"${RTP_START}\"" "$out/switch.conf.xml" || { echo "RTP patch failed"; exit 1; }
chmod 600 "$out"/event_socket.conf.xml "$out"/sip_profiles/mrf.xml
echo "rendered -> $out (register=$REGISTER)"
