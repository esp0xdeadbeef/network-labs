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
      "GAMP/SMT/mini-smt/runtime-nixos-cpm.nix"
      "GAMP/SMT/mini-smt/runtime-nixos-p2p-cpm.nix"
    ];
    observedResult = "renderer mini-SMT entries independently runnable with explicit CPM inputs";
  };
}
