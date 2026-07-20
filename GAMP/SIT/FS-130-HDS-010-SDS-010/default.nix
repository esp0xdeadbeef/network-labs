{
  layer = "SIT";
  traceId = "FS-130-HDS-010-SDS-010";
  smsInputs = {
    "FS-130-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-130-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-130-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-130-HDS-010-SDS-010-SMS-010-scoped-request-contract.md";
      role = "scoped-request-contract";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "FS-130-HDS-010-SDS-010-SMS-010 is construction-only scoped request evidence from network-codex-agent; no router runtime targets are created. 2026-07-04 active-lab run passed with runroot /tmp/active-lab-mini-smt-runs/20260704T112916Z-3130464 and workdir /tmp/s-router-live-smoke/FS-130-HDS-010-SDS-010-SMS-010/20260704T112919Z; s-router-nixos, s-router-clab, and s-router-test-clients artifacts were collected as context only.";
  };
}
