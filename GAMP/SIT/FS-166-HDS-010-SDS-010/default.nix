{
  layer = "SIT";
  traceId = "FS-166-HDS-010-SDS-010";
  status = "NOT OK";
  smsInputs = {
    "FS-166-HDS-010-SDS-010-SMS-900" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      smtRow = ../../SMT/FS-166-HDS-010-SDS-010-SMS-900;
      sourcePath = "GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-900/default.nix";
      role = "controlled-renderer-scenario-umbrella";
    };
  };
  evidence = {
    constructionStatus = "OK";
    liveStatus = "NOT OK";
    observedResult = "2026-07-21: all six child scenarios pass the deterministic validation scheme through replacement validation, controlled skip acknowledgements, realization, schema validation, one normalized platform-binding bundle, and canonical renderer admission. Former direct renderer-entry fixtures and live runners are removed. No fresh cold-stage evidence exists for the new flow.";
  };
}
