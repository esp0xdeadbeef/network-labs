{
  layer = "SIT";
  traceId = "FS-470-HDS-010-SDS-010";
  status = "NOT OK";
  smsInputs = {
    "FS-470-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-470-HDS-010-SDS-010-SMS-010;
      role = "wireguard-remote-egress-construction-handoff";
      evidenceBoundary = "construction-only";
    };
    "FS-470-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-470-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "sms-040-module";
      evidenceBoundary = "construction-only";
    };
  };
  evidence.observedResult = "No conformant integrated or live evidence is registered. The former direct renderer-input fixture and its runtime evidence path were removed.";
}
