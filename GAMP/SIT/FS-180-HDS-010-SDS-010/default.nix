{
  layer = "SIT";
  traceId = "FS-180-HDS-010-SDS-010";
  smsInputs = {
    "FS-180-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-180-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-180-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "bidirectional-nft-rule-generation";
    };
  };
  evidence = {
    observedResult = "Split evidence boundary: construction tests PASS at network-codex-agent HEAD; HAT live re-verify pending.";
  };
}
