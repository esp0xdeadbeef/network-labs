{
  layer = "SIT";
  traceId = "FS-162-HDS-010-SDS-020";
  status = "OK";
  evidenceBoundary = "construction-only";
  smsInputs."FS-162-HDS-010-SDS-020-SMS-010" = {
    smtRow = ../../SMT/FS-162-HDS-010-SDS-020-SMS-010;
    role = "locked-yang-validation";
    evidenceBoundary = "construction-only";
  };
  evidence = {
    check = "openconfig-yang-validation";
    observedResult = "The emitter and offline locked YANG release gate integrate with bound bundle, renderer, model, lock, tool, and candidate identities.";
    liveDeviceClaimed = false;
  };
}
