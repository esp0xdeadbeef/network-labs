{
  layer = "SMT";
  traceId = "FS-390-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-010-public-ipv4-destination-classification.md";
  titleSlug = "public-ipv4-destination-classification";
  miniSmtId = "FS-390-HDS-010-SDS-010-SMS-010";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-390-HDS-010-SDS-010-SMS-010__mini-verify"
      "FS-390-HDS-010-SDS-010-SMS-010__client-to-tenant-api"
      "FS-390-HDS-010-SDS-010-SMS-010__client-to-fixture-missing-output"
      "FS-390-HDS-010-SDS-010-SMS-010__testnet-to-public-web"
    ];
  };
  evidence = {
    maxRuntimeTargets = 5;
    scope = "SMT/SIT public IPv4 destination classification from intent-source through NFM forwarding artifact; live proof must inspect forwarding.json on s-router-nixos and s-router-clab";
  };
}
