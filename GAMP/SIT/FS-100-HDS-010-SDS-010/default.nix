{
  layer = "SIT";
  traceId = "FS-100-HDS-010-SDS-010";
  smsInputs = {
    "FS-100-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-010;
      role = "emitter-provenance";
      evidenceBoundary = "construction-only";
    };
    "FS-100-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-020;
      role = "deterministic-source-identity";
    };
    "FS-100-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-030;
      role = "signed-output-containment";
    };
    "FS-100-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-040;
      role = "provenance-redaction";
    };
    "FS-100-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-050;
      role = "output-artifact-binding";
    };
  };
  evidence = {
    observedResult = "All five SMS traces have independent SMT construction evidence OK at HEAD. SIT integration path declared for end-to-end provenance chain verification.";
  };
}
