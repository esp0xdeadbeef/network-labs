{
  layer = "SIT";
  traceId = "FS-270-HDS-010-SDS-010";
  smsInputs = {
    "FS-270-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-270-HDS-010-SDS-010-SMS-010;
      role = "policy-point-transit";
      evidenceBoundary = "construction-only";
    };
    "FS-270-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-270-HDS-010-SDS-010-SMS-020;
      role = "client-tenant-policy-transit";
      evidenceBoundary = "construction-only";
    };
    "FS-270-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-270-HDS-010-SDS-010-SMS-030;
      role = "transit-host-local-separation";
      evidenceBoundary = "construction-only";
    };
    "FS-270-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-270-HDS-010-SDS-010-SMS-040;
      role = "selector-handoff-transport-forwarding-boundary";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "Construction-only trace chain. SMT rows 125, 204, 205, 468: all NOT OK but individual construction tests exist and passed in locked proofs. SIT locked-artifact evidence from 2026-06-13: compiler→NFM→CPM pipeline produces deterministic policy-point transit artifacts.";
  };
}
