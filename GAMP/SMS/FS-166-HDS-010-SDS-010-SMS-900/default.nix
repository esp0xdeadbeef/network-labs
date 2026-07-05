{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-900";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Renderer-entry mini POC source input templates.";
  sourceInputs = {
    "FS-166-HDS-010-SDS-010-SMS-901" = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-901";
      kind = "renderer-input";
      rendererTarget = "nixos";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix";
      test = "../network-codex-agent/scripts/smt-live-FS-166-HDS-010-SDS-010-SMS-901.sh";
      maxRuntimeTargets = 1;
    };

    "FS-166-HDS-010-SDS-010-SMS-902" = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-902";
      kind = "renderer-input";
      rendererTarget = "nixos";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-p2p-cpm.nix";
      test = "tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh";
      maxRuntimeTargets = 2;
    };

    "FS-166-HDS-010-SDS-010-SMS-903" = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-903";
      kind = "renderer-input";
      rendererTarget = "nixos-clients";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix";
      test = "tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh";
      maxRuntimeTargets = 1;
    };

    "FS-166-HDS-010-SDS-010-SMS-904" = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-904";
      kind = "renderer-input";
      rendererTarget = "clab";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix";
      test = "tests/test-active-lab-mini-smt-renderer-clab-only.sh";
      maxRuntimeTargets = 2;
    };

    "FS-166-HDS-010-SDS-010-SMS-905" = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-905";
      kind = "renderer-input";
      rendererTarget = "wireguard";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/wireguard-provider-contract.nix";
      test = "tests/test-active-lab-mini-smt-renderer-wireguard-only.sh";
      maxRuntimeTargets = 1;
    };

    "FS-166-HDS-010-SDS-010-SMS-906" = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-906";
      kind = "renderer-input";
      rendererTarget = "nebula";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-nebula-cpm.nix";
      test = "tests/test-active-lab-mini-smt-renderer-nebula-only.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-row-source-stubs.sh"
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
