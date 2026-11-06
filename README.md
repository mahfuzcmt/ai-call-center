# AI Call Center

Bangla/Banglish AI voice agent over a BD SIP trunk. Spec: `../ai-call-center.md`.

## Status
Phase 1 (telephony): FreeSWITCH in Docker (host networking), `bd-trunk` gateway, echo-test dialplan.

Deviation from spec: image is `drachtio/drachtio-freeswitch-mrf` (ships `mod_audio_fork`, the WebSocket
audio streamer, in place of `mod_audio_stream`). Its entrypoint is bypassed because it exposes the
event socket to 0.0.0.0/0 with a default password; ESL is bound to 127.0.0.1 here.

## Deploy (server: /opt/ai-call-center)
```
cp .env.example .env      # fill values; never commit
./scripts/render-conf.sh  # renders conf-rendered/ from templates
docker compose up -d
docker exec ai-call-center-freeswitch fs_cli -P 8021 -p "$ESL_PASSWORD" -x "sofia status gateway bd-trunk"
```

## Auth mode
- `BD_TRUNK_PASSWORD` empty -> `register=false` (IP-auth). Provider must whitelist `PUBLIC_IP`.
- `BD_TRUNK_PASSWORD` set -> registers to the provider.

## Firewall (ufw)
- `SIP_PORT/udp` from the provider IP only
- RTP `RTP_START:RTP_END/udp` (provider IP only; widen only if media is one-way)
