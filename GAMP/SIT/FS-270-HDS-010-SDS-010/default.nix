{
  layer = "SIT";
  traceId = "FS-270-HDS-010-SDS-010";
  smsInputs = {
    "FS-270-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-270-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "policy-point-transit";
      evidenceBoundary = "construction-only";
    };
    "FS-270-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-270-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "client-tenant-policy-transit";
      evidenceBoundary = "isolated-dual-substrate-live-policy-state-owner";
    };
    "FS-270-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-270-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "transit-host-local-separation";
      evidenceBoundary = "construction-only";
    };
    "FS-270-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-270-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "selector-handoff-transport-forwarding-boundary";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "The locked compiler-to-NFM-to-CPM integration evidence remains row-scoped. FS-270-HDS-010-SDS-010-SMS-020 additionally passed its 2026-07-19 isolated cold-stage protocol on NixOS and CLAB for IPv4 and IPv6 with one policy-state owner, stateful return, reverse-new denial, no shortcut, and no transitive egress. Sibling SMS rows retain their own evidence boundaries; this does not promote HAT or SAT.";
  };
}
