# FS-166-HDS-010-SDS-010 SIT

SIT row note for the renderer mini-SMT umbrella integration path.

SIT rows are SDS-scoped. This row covers the FS-166 renderer mini-SMT entries:

- `FS-166-HDS-010-SDS-010-SMS-901` — one runtime container from explicit CPM input
- `FS-166-HDS-010-SDS-010-SMS-902` — two p2p-linked runtime containers
- `FS-166-HDS-010-SDS-010-SMS-903` — one endpoint client container
- `FS-166-HDS-010-SDS-010-SMS-904` — Containerlab two-node topology
- `FS-166-HDS-010-SDS-010-SMS-905` — WireGuard provider runtime module
- `FS-166-HDS-010-SDS-010-SMS-906` — Nebula overlay with lighthouse/client

All entries derive from FS-166-HDS-010-SDS-010-SMS-900 source inputs.

Current evidence command:

```bash
tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-901 FS-166-HDS-010-SDS-010-SMS-902 FS-166-HDS-010-SDS-010-SMS-903 FS-166-HDS-010-SDS-010-SMS-904 FS-166-HDS-010-SDS-010-SMS-905 FS-166-HDS-010-SDS-010-SMS-906
```

Observed on 2026-06-27: exit 0 for all six entries. This is focused SMT/SIT
source-to-renderer evidence only and does not claim HAT/SAT runtime acceptance.

Current live `FS-166-HDS-010-SDS-010-SMS-901` evidence command:

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
`SMT FS-166-HDS-010-SDS-010-SMS-901` and local `nixos` lock `56239c47` consumed it. The three
`s-router-*` hosts were shut down and returned through the external rebuild
path. Live `s-router-nixos` exposed the FS-166 renderer-input artifact and
running `poc-router`; live `s-router-clab` and `s-router-test-clients` exposed
the same FS-166 artifact with `poc-router` absent on those hosts. This closes
only the row-local `FS-166-HDS-010-SDS-010-SMS-901` SMT/SIT runtime predicate,
not HAT/SAT.

Current live `FS-166-HDS-010-SDS-010-SMS-902` evidence command:

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
`SMT FS-166-HDS-010-SDS-010-SMS-902`, `network-labs@f9d21d2` completed the renderer-input
CPM fixture, and local `nixos` lock `5f86907b` consumed it. The three
`s-router-*` hosts were shut down and returned through the external rebuild
path. Live `s-router-nixos` exposed the FS-166 p2p renderer-input artifact,
running `edge-a` and `edge-b`, and the rendered p2p bridge. Live
`s-router-clab` and `s-router-test-clients` exposed the same FS-166 p2p
artifact with `edge-a` and `edge-b` absent on those hosts. This closes only the
row-local `FS-166-HDS-010-SDS-010-SMS-902` SMT/SIT runtime predicate, not HAT/SAT.

Current live `FS-166-HDS-010-SDS-010-SMS-903` evidence command:

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
`SMT FS-166-HDS-010-SDS-010-SMS-903`, removed router runtime targets from the endpoint
fixture, and local `nixos` lock `c75190e5` consumed it. The three `s-router-*`
hosts were shut down and returned through the external rebuild path. Live
`s-router-test-clients` exposed the FS-166 clients control-plane artifact,
access-endpoint provenance for `poc-client`, the rendered `client` bridge, and
running `container@poc-client.service`. Live `s-router-nixos` and
`s-router-clab` did not run `poc-client`. This closes only the row-local
renderer-nixos-clients SMT/SIT runtime predicate, not HAT/SAT.

Current live `FS-166-HDS-010-SDS-010-SMS-904` evidence command:

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
`SMT FS-166-HDS-010-SDS-010-SMS-904`, fixed the `s-router-clab` host-specific intent alias to
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

Current live `FS-166-HDS-010-SDS-010-SMS-905` evidence command:

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
`network-labs@d74172e` selected `SMT FS-166-HDS-010-SDS-010-SMS-905` with a one-target
`wgInventory` CPM fixture and row-local SOPS secret, and local `nixos` lock
`2b174716` consumed them. The three `s-router-*` hosts were shut down and
returned through the external rebuild path. Live `s-router-nixos` exposed the
FS-166 renderer-wireguard artifact, running `container@wireguard-egress.service`,
the row-local `/run/secrets/wireguard-mini-provider-private-key` on the host and
inside the container, `wg-layer-entry` with `10.66.90.2/32`, and active
`s88-provider-interface-wg-layer-entry-egress.service`. Live `s-router-clab`
and `s-router-test-clients` did not run the WireGuard row runtime. This closes
only the row-local `FS-166-HDS-010-SDS-010-SMS-905` SMT/SIT runtime predicate,
not HAT/SAT.

Current live `FS-166-HDS-010-SDS-010-SMS-906` evidence command:

```bash
cd /home/deadbeef/github/network-codex-agent
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_NEBULA_PATH=/home/deadbeef/github/network-renderer-nebula \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-nebula-runtime-check.sh --live
```

Observed on 2026-06-30: exit 0 after `network-renderer-nebula@b9f01fb`
bound persistent Nebula profile directories into generated containers,
`network-labs@4919505` selected `SMT FS-166-HDS-010-SDS-010-SMS-906` with a two-target
client/lighthouse CPM fixture and row-local SOPS profile secrets,
`network-codex-agent@808593f3` added the live verifier, and local `nixos` lock
`41f11073` consumed them. Locked local builds passed for `s-router-nixos`
`/nix/store/pbfyzvpzf99br18djxf9ym3cqf1mja7j-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/72yj65acvj25958hjlq1kyrqbchp3crh-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/d2awdxvzabd88g5vlwzgxmm648n30a5i-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
The three `s-router-*` hosts were shut down and returned through the external
rebuild path with fresh boot times on 2026-06-30 09:03. Live
`s-router-nixos` exposed the FS-166 renderer-nebula artifact, running
`container@lab-lighthouse.service` and `container@lab-client-nebula.service`,
row-local Nebula profile files present on the host and inside the containers,
active `nebula@runtime.service` in both containers, and client `nebula1` with
`100.96.90.2/24`. Live `s-router-clab` and `s-router-test-clients` did not run
the Nebula row runtime. This closes only the row-local renderer-nebula SMT/SIT
runtime predicate, not HAT/SAT.
