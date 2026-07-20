{
  layer = "SMT";
  traceId = "FS-720-HDS-010-SDS-010-SMS-030";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-010-SDS-010-SMS-030-test-clients-service-surfaces.md";
  titleSlug = "test-clients-service-surfaces";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-030/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-030/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-only";
  };
  status = "OK";
  evidence = {
    observedResult = "PASS — SMS predicate coverage matrix 14/14: MR1 service role validation, MR2 discovery/payload separation, MR3 no fixture authority, FC1 missing service surface diagnostic, FC2 fixture-presence-grants-discovery rejected, SN1 active seeded negative (missing-service-surface diagnostic), SN2 active seeded negative (fixture-presence-grants-discovery diagnostic), plus construction handoff, CI1-CI2 consumed interfaces, EI1-EI3 emitted interfaces";
  };
}
