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
    command = "tests/run-active-lab-mini-smt.sh FS-470-HDS-010-SDS-010-SMS-010__mini-wireguard-remote-egress";
    sourcePaths = [
      "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix"
    ];
    observedResult = "FS-470 SMS-010 active-lab mini SIT consumes a row-local renderer-input CPM fixture and verifies the WireGuard renderer hostModule imports provider runtime material from controlPlane.providerContracts.wireguard. Live host proof is recorded by the NCA wrapper after lock bump, shutdown, and rebuild.";
  };
}
