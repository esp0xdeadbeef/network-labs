{
  layer = "SIT";
  traceId = "FS-162-HDS-010-SDS-040";
  status = "OK";
  evidenceBoundary = "construction-only";
  smsInputs."FS-162-HDS-010-SDS-040-SMS-010" = {
    smtRow = ../../SMT/FS-162-HDS-010-SDS-040-SMS-010;
    role = "three-peer-canonical-posture-comparison";
    evidenceBoundary = "construction-only";
  };
  evidence = {
    check = "openconfig-peer-posture";
    observedResult = "NixOS, CLAB, and OpenConfig consume one FS-230 canonical bundle identity and produce equal normalized posture evidence with independent validated binding bundles.";
    liveDeviceClaimed = false;
  };
}
