{
  layer = "SIT";
  traceId = "FS-166-HDS-010-SDS-010";
  smsInputs = {
    "FS-166-HDS-010-SDS-010-SMS-900" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      sourcePath = "GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-900/default.nix";
      role = "renderer-mini-smt-umbrella";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh renderer-nixos renderer-nixos-p2p renderer-nixos-clients renderer-clab renderer-wireguard renderer-nebula";
    sourcePaths = [
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-p2p-cpm.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/wireguard-provider-contract.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-nebula-cpm.nix"
    ];
    observedResult = "2026-06-27: renderer mini-SMT entries independently runnable with explicit CPM inputs; command exited 0 for renderer-nixos, renderer-nixos-p2p, renderer-nixos-clients, renderer-clab, renderer-wireguard, and renderer-nebula. SMT/SIT prerequisite evidence only; no HAT/SAT runtime acceptance claim.";
  };
}
