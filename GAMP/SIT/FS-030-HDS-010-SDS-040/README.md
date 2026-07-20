# FS-030-HDS-010-SDS-040

Layer: SIT

This row-local integration record proves that the
`FS-030-HDS-010-SDS-040-SMS-010` mini-SMT source integrates through the current
active-lab path into both NixOS and Containerlab runtime surfaces.

Current evidence, 2026-07-04:

- Active selector:
  `scripts/select-current-lab.sh SMT FS-030-HDS-010-SDS-040-SMS-010`.
- Locked NixOS root input `network-labs`:
  `6c85977ee6dbff2148a141e84988754fec7dba15`.
- Local pinned builds passed for:
  `.#nixosConfigurations.s-router-nixos.config.system.build.nixos-shell`,
  `.#nixosConfigurations.s-router-clab.config.system.build.nixos-shell`, and
  `.#nixosConfigurations.s-router-test-clients.config.system.build.nixos-shell`.
- Live row wrapper passed:
  `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/live-FS-030-HDS-010-SDS-040-SMS-010.sh`.
- Manual runtime comparer passed p2p/routes/runtime-signals checks for
  NixOS and test-clients and confirmed five live CLAB nodes after the CLAB
  render service reached ready state.
- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010`
  passed with offline verifier disabled.

This is SIT evidence for this focused row only. It does not claim HAT, SAT, or
production readiness.
