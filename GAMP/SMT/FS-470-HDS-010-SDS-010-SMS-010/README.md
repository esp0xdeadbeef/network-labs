# SMT Construction Row: FS-470-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-010-wireguard-remote-egress.md`

Status: OK for construction only. Integrated and live status is NOT OK.

The canonical trace-derived construction entrypoint invokes the owning
`network-renderer-wireguard` module test:

```sh
bash tests/FS-470-HDS-010-SDS-010-SMS-010.sh
```

The former direct CPM-to-renderer mini-lab fixture is removed. This row does
not currently select or start a runtime target. A new integrated scenario must
enter through the canonical realization and platform-binding boundary before
SIT or live evidence can be accepted.

Title slug: `wireguard-remote-egress`
