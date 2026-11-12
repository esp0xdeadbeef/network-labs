{
  layer = "SIT";
  traceId = "FS-310-HDS-040-SDS-010";
  smsInputs = {
    "FS-310-HDS-040-SDS-010-SMS-100" = {
      smtRow = ../../SMT/FS-310-HDS-040-SDS-010-SMS-100;
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-100/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-100.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-101" = {
      smtRow = ../../SMT/FS-310-HDS-040-SDS-010-SMS-101;
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-101/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-101.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-102" = {
      smtRow = ../../SMT/FS-310-HDS-040-SDS-010-SMS-102;
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-102/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-102.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-140" = {
      smtRow = ../../SMT/FS-310-HDS-040-SDS-010-SMS-140;
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-140/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-140.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-150" = {
      smtRow = ../../SMT/FS-310-HDS-040-SDS-010-SMS-150;
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-150.md";
      role = "cpm-platform-abstention";
      evidenceBoundary = "active mini-SMT runtime wrapper plus owning CPM construction proof";
    };
    "FS-310-HDS-040-SDS-010-SMS-160" = {
      smtRow = ../../SMT/FS-310-HDS-040-SDS-010-SMS-160;
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-160/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-160.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-170" = {
      smtRow = ../../SMT/FS-310-HDS-040-SDS-010-SMS-170;
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-170/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-170.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-180" = {
      smtRow = ../../SMT/FS-310-HDS-040-SDS-010-SMS-180;
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-180/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-180.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    sourcePaths = [
      "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/intent.nix"
    ];
    observedResult = "registered runtime wrapper for the SMS-150 mini profile; row remains unpromoted until the live wrapper passes after the selected active-lab build and the owning CPM construction test remains passing";
  };
}
