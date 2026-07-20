{
  layer = "SIT";
  traceId = "FS-162-HDS-010-SDS-030";
  status = "OK";
  evidenceBoundary = "construction-only";
  smsInputs."FS-162-HDS-010-SDS-030-SMS-010" = {
    smtRow = ../../SMT/FS-162-HDS-010-SDS-030-SMS-010;
    role = "canonical-interface-mapping";
    evidenceBoundary = "construction-only";
  };
  evidence = {
    check = "openconfig-emission-negatives";
    observedResult = "Canonical bundle validation, mapping coverage, provenance, emission, and fail-closed diagnostics integrate under one root lock.";
    liveDeviceClaimed = false;
  };
}
