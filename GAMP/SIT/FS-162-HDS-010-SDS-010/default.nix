{
  layer = "SIT";
  traceId = "FS-162-HDS-010-SDS-010";
  status = "OK";
  evidenceBoundary = "construction-only";
  smsInputs."FS-162-HDS-010-SDS-010-SMS-010" = {
    smtRow = ../../SMT/FS-162-HDS-010-SDS-010-SMS-010;
    role = "canonical-emission-construction";
    evidenceBoundary = "construction-only";
  };
  evidence = {
    check = "openconfig-emission-negatives";
    observedResult = "Canonical mapping, instance emission, exact diagnostics, deterministic failure, recovery, and YANG release integrate under one root lock.";
    liveDeviceClaimed = false;
  };
}
