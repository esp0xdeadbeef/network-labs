# FS-166-HDS-010-SDS-010 SIT

SIT row note for the renderer mini-SMT umbrella integration path.

SIT rows are SDS-scoped. This row covers the FS-166 renderer mini-SMT entries:

- `renderer-nixos` — one runtime container from explicit CPM input
- `renderer-nixos-p2p` — two p2p-linked runtime containers
- `renderer-nixos-clients` — one endpoint client container
- `renderer-clab` — Containerlab two-node topology
- `renderer-wireguard` — WireGuard provider runtime module
- `renderer-nebula` — Nebula overlay with lighthouse/client

All entries derive from FS-166-HDS-010-SDS-010-SMS-900 source inputs.

Current evidence command:

```bash
tests/run-active-lab-mini-smt.sh renderer-nixos renderer-nixos-p2p renderer-nixos-clients renderer-clab renderer-wireguard renderer-nebula
```

Observed on 2026-06-27: exit 0 for all six entries. This is focused SMT/SIT
source-to-renderer evidence only and does not claim HAT/SAT runtime acceptance.

Current live `renderer-nixos` evidence command:

```bash
cd /home/deadbeef/github/network-codex-agent
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-nixos-runtime-check.sh --live
```

Observed on 2026-06-30: exit 0 after `network-labs@b077ad6` selected
`SMT renderer-nixos` and local `nixos` lock `56239c47` consumed it. The three
`s-router-*` hosts were shut down and returned through the external rebuild
path. Live `s-router-nixos` exposed the FS-166 renderer-input artifact and
running `poc-router`; live `s-router-clab` and `s-router-test-clients` exposed
the same FS-166 artifact with `poc-router` absent on those hosts. This closes
only the row-local renderer-nixos SMT/SIT runtime predicate, not HAT/SAT.

Current live `renderer-nixos-p2p` evidence command:

```bash
cd /home/deadbeef/github/network-codex-agent
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-nixos-p2p-runtime-check.sh --live
```

Observed on 2026-06-30: exit 0 after `network-labs@50850a3` selected
`SMT renderer-nixos-p2p`, `network-labs@f9d21d2` completed the renderer-input
CPM fixture, and local `nixos` lock `5f86907b` consumed it. The three
`s-router-*` hosts were shut down and returned through the external rebuild
path. Live `s-router-nixos` exposed the FS-166 p2p renderer-input artifact,
running `edge-a` and `edge-b`, and the rendered p2p bridge. Live
`s-router-clab` and `s-router-test-clients` exposed the same FS-166 p2p
artifact with `edge-a` and `edge-b` absent on those hosts. This closes only the
row-local renderer-nixos-p2p SMT/SIT runtime predicate, not HAT/SAT.

Current live `renderer-nixos-clients` evidence command:

```bash
cd /home/deadbeef/github/network-codex-agent
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_ACCESS_ENDPOINT_NIXOS_PATH=/home/deadbeef/github/network-renderer-access-endpoint-nixos \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-nixos-clients-runtime-check.sh --live
```

Observed on 2026-06-30: exit 0 after `network-labs@d494c16` selected
`SMT renderer-nixos-clients`, removed router runtime targets from the endpoint
fixture, and local `nixos` lock `c75190e5` consumed it. The three `s-router-*`
hosts were shut down and returned through the external rebuild path. Live
`s-router-test-clients` exposed the FS-166 clients control-plane artifact,
access-endpoint provenance for `poc-client`, the rendered `client` bridge, and
running `container@poc-client.service`. Live `s-router-nixos` and
`s-router-clab` did not run `poc-client`. This closes only the row-local
renderer-nixos-clients SMT/SIT runtime predicate, not HAT/SAT.
