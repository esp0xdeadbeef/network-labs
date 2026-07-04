{
  layer = "SIT";
  traceId = "FS-100-HDS-010-SDS-010";
  smsInputs = {
    "FS-100-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "emitter-provenance";
      evidenceBoundary = "construction-only";
    };
    "FS-100-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "deterministic-source-identity";
      evidenceBoundary = "construction-only";
    };
    "FS-100-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "signed-output-containment";
      evidenceBoundary = "construction-only";
    };
    "FS-100-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "provenance-redaction";
      evidenceBoundary = "construction-only";
    };
    "FS-100-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-100-HDS-010-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-050/intent.nix";
      role = "output-artifact-binding";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "All five SMS traces have independent SMT construction evidence OK at HEAD. SIT integration path declared for end-to-end provenance chain verification.";
  };
}
