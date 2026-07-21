# SMS Mirror: FS-470-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-010-wireguard-remote-egress.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: Construction mirror registered; integrated and live evidence is NOT OK.

The former direct CPM-to-renderer mini-lab fixture is removed. The row now
resolves only the canonical owning-repository construction test.

Focused construction command:

```sh
bash tests/FS-470-HDS-010-SDS-010-SMS-010.sh
```

This does not establish SIT, live, HAT, or SAT evidence. A new integrated
scenario must use the canonical realization and platform-binding boundary.
