{
  layer = "SIT";
  traceId = "FS-230-HDS-010-SDS-010";
  smsInputs = {
    "FS-230-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-230-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-010-public-ingress-return-translation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-230-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-230-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-020-public-ingress-translation-binding.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-230-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-230-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-030-public-ingress-return-authority-separation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-230-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-230-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md";
      role = "construction-candidate";
      evidenceBoundary = "construction-green-live-cold-stage-pending";
    };
  };
  evidence = {
    observedResult = "SMS-040 construction is green, but no integrated cold-stage SIT runner or live artifact evidence is registered yet";
  };
}
