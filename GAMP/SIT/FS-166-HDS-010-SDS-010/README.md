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

Current live `renderer-clab` evidence command:

```bash
cd /home/deadbeef/github/network-codex-agent
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_CLAB_PATH=/home/deadbeef/github/network-renderer-containerlab-linux-backend \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-clab-runtime-check.sh --live
```

Observed on 2026-06-30: exit 0 after `network-labs@ba3329c` selected
`SMT renderer-clab`, fixed the `s-router-clab` host-specific intent alias to
consume `minimal-clab-cpm.nix`, and local `nixos` lock `91fcc0f9` consumed it.
The three `s-router-*` hosts were shut down and returned through the external
rebuild path. Live `s-router-clab` exposed the FS-166 renderer-clab artifact,
render-live complete/success marker, `fabric.clab.yml` containing
`acme-lab-edge-a` and `acme-lab-edge-b`, `br-layer-entry`, running Docker
containers `clab-fabric-acme-lab-edge-a` and `clab-fabric-acme-lab-edge-b`,
and eth1 p2p addresses `192.0.2.0/31` and `192.0.2.1/31`. Live
`s-router-nixos` and `s-router-test-clients` did not run the CLAB edge runtime.
This closes only the row-local renderer-clab SMT/SIT runtime predicate, not
HAT/SAT.

Current live `renderer-wireguard` evidence command:

```bash
cd /home/deadbeef/github/network-codex-agent
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_WIREGUARD_PATH=/home/deadbeef/github/network-renderer-wireguard \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-wireguard-runtime-check.sh --live
```

Observed on 2026-06-30: exit 0 after `network-renderer-wireguard@fcaa109`
bound explicit `/run/secrets` WireGuard key paths into generated containers,
`network-labs@d74172e` selected `SMT renderer-wireguard` with a one-target
`wgInventory` CPM fixture and row-local SOPS secret, and local `nixos` lock
`2b174716` consumed them. The three `s-router-*` hosts were shut down and
returned through the external rebuild path. Live `s-router-nixos` exposed the
FS-166 renderer-wireguard artifact, running `container@wireguard-egress.service`,
the row-local `/run/secrets/wireguard-mini-provider-private-key` on the host and
inside the container, `wg-layer-entry` with `10.66.90.2/32`, and active
`s88-provider-interface-wg-layer-entry-egress.service`. Live `s-router-clab`
and `s-router-test-clients` did not run the WireGuard row runtime. This closes
only the row-local renderer-wireguard SMT/SIT runtime predicate, not HAT/SAT.
