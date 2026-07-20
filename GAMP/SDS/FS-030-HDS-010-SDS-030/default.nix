{
  layer = "SDS";
  traceId = "FS-030-HDS-010-SDS-030";
  purpose = "Overlay-underlay separation row-local mini-SMT grouping.";
  smsInputs = {
    "FS-030-HDS-010-SDS-030-SMS-010" = {
      smsRow = ../../SMS/FS-030-HDS-010-SDS-030-SMS-010;
      miniSmtIds = [ "FS-030-HDS-010-SDS-030-SMS-010" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  evidence = {
    observedResult = "2026-07-04 live NixOS and CLAB runtime surfaces preserved separate overlay-underlay, overlay-payload, and underlay-access-egress relations from the same row-local intent source";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051250Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051319Z"
      "/tmp/active-lab-mini-smt-runs/20260704T051312Z-2891933/FS-030-HDS-010-SDS-030-SMS-010"
    ];
  };
}
