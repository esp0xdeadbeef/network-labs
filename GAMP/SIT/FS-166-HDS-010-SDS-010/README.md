# FS-166-HDS-010-SDS-010 SIT

SIT row stub for the renderer mini-SMT umbrella integration path.

SIT rows are SDS-scoped. This row covers the FS-166 renderer mini-SMT entries:

- `renderer-nixos` — one runtime container from explicit CPM input
- `renderer-nixos-p2p` — two p2p-linked runtime containers
- `renderer-nixos-clients` — one endpoint client container
- `renderer-clab` — Containerlab two-node topology
- `renderer-wireguard` — WireGuard provider runtime module
- `renderer-nebula` — Nebula overlay with lighthouse/client

All entries derive from FS-166-HDS-010-SDS-010-SMS-900 source inputs.
