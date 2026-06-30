{
  layer = "SIT";
  traceId = "FS-380-HDS-020-SDS-010";
  smsInputs = {
    "FS-380-HDS-020-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-380-HDS-020-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050/intent.nix";
      role = "internet-mode-verification";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-380-HDS-020-SDS-010-SMS-050";
    liveCommand = ''
      cd /home/deadbeef/github/network-codex-agent &&
      NETWORK_REPO_DIRECT_TEST_OK=1 \
      NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
      NETWORK_CPM_PATH=/home/deadbeef/github/network-control-plane-model \
      NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos \
      NETWORK_RENDERER_CLAB_PATH=/home/deadbeef/github/network-renderer-containerlab-linux-backend \
      NIXOS_REPO_PATH=/home/deadbeef/github/nixos \
      S_ROUTER_NIXOS=192.168.1.17 \
      S_ROUTER_CLAB=192.168.1.19 \
      S_ROUTER_TEST_CLIENTS=192.168.1.18 \
      bash scripts/fs380-active-lab-internet-mode-runtime-check.sh --live
    '';
    sourcePaths = [
      "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050/intent.nix"
    ];
    observedResult = "OK live on 2026-06-30: network-labs@98edfe7 selects FS-380-HDS-020-SDS-010 in current-lab and local nixos lock d10a5316 consumes that committed shim. fs380-active-lab-internet-mode-runtime-check.sh --live passed against 192.168.1.17/s-router-nixos, 192.168.1.19/s-router-clab, and 192.168.1.18/s-router-test-clients after the hosts were shut down and restarted through the external rebuild path. Evidence proves the row-local mini SMT source, CPM substrate checks, NixOS renderer checks, CLAB renderer checks, current-lab selection, CPM artifacts for NixOS/CLAB/test-client surfaces, NixOS profile eval, and live artifacts/runtime. s-router-nixos and s-router-clab each expose runtimeTargets=5, bridgeNetworks=6, privateNat44=1, PPPoE accessHandoff, internet-vlan4/internet-vlan5, PPPoE process/interface evidence, route-get from 10.20.20.1, and successful ping to 1.1.1.1. s-router-test-clients exposes the VLAN4/VLAN5 host substrate with runtimeTargets=0, bridgeNetworks=0, privateNat44=0, and no router fabric containers. This is scoped FS-380 SMT/SIT live evidence only and does not claim HAT, SAT, or production readiness.";
  };
}
