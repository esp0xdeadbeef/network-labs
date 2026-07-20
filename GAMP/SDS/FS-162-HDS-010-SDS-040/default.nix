{
  layer = "SDS";
  traceId = "FS-162-HDS-010-SDS-040";
  purpose = "OpenConfig comparison of the pinned isolated FS-230 CPM posture.";
  smsInputs = {
    "FS-162-HDS-010-SDS-040-SMS-010" = {
      smsRow = ../../SMS/FS-162-HDS-010-SDS-040-SMS-010;
      miniSmtIds = [ "fs230-openconfig-posture" ];
      inputKinds = [ "isolated-fs230-cpm" ];
      evidenceBoundary = "construction-only";
    };
  };
}
