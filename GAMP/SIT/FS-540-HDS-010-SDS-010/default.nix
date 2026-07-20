{
  layer = "SIT";
  traceId = "FS-540-HDS-010-SDS-010";
  smsInputs = {
    "FS-540-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "dns-resolver-config";
    };
    "FS-540-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "requester-lane-recursive-reachability";
      evidenceBoundary = "construction-only";
    };
    "FS-540-HDS-010-SDS-010-SMS-045" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-045;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent.nix";
      role = "prod-like-access-recursive-dns";
      evidenceBoundary = "isolated-dual-substrate-live-dns-reproducibility";
    };
    "FS-540-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    sourcePaths = [
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent-test-clients.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent-test-clients.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-nixos.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-clab.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-test-clients.nix"
    ];
    observedResult = "2026-07-19 OK at the isolated SMS-045 boundary. After every owning revision was pushed, all three lab guests were shut down together, observed offline, and returned with new boot IDs/closures, exact staged source hashes and pins, and zero failed units. NixOS and CLAB both passed first-attempt IPv4/IPv6 UDP/TCP recursion through only the model-selected provider, direct-core access, local namespace sharing, deterministic lateral REFUSED behavior, denied unauthorized direct paths, persistent listeners, convergent route state, and zero reproducibility warnings. Sibling SMS rows retain their own evidence boundaries; this does not promote HAT, SAT, or production.";
  };
}
