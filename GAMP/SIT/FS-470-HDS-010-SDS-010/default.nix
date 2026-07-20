{
  layer = "SIT";
  traceId = "FS-470-HDS-010-SDS-010";
  smsInputs = {
    "FS-470-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-470-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix";
      role = "wireguard-remote-egress-provider-runtime";
      evidenceBoundary = "active-lab mini SMT/SIT";
    };
    "FS-470-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-470-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "sms-040-module";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    sourcePaths = [
      "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix"
    ];
    observedResult = "2026-07-01: FS-470 SMS-010 active-lab mini SIT consumes a row-local renderer-input CPM fixture and verifies the WireGuard renderer hostModule imports provider runtime material from controlPlane.providerContracts.wireguard. Live proof is recorded by the NCA wrapper at network-codex-agent@6ebae5f5 after network-labs@0c0682b, local nixos lock b76e5e70, and shutdown/rebuild of s-router-nixos, s-router-clab, and s-router-test-clients. Runtime proof: s-router-nixos runs wireguard-remote-egress with wg-re-egress0, while s-router-clab and s-router-test-clients expose empty active-lab artifacts tagged FS-470-HDS-010-SDS-010-SMS-010 and no remote-egress runtime.";
  };
}
