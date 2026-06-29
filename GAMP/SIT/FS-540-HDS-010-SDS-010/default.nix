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
    "FS-540-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = ''
      tests/run-active-lab-mini-smt.sh dns-resolver-config &&
      tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh
    '';
    sourcePaths = [
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix"
    ];
    observedResult = "NOT OK live on 2026-06-29: row-local mini-SMT and focused construction checks pass, and CLAB core-nebula no longer inherits Docker/host public resolver fallback after network-renderer-containerlab-linux-backend@218019d; the live active-lab recursive DNS probe still fails with 5 findings because NixOS access-client, access-admin, and core-nebula do not resolve through 127.0.0.1#53, and CLAB access-client/access-admin do not resolve through clabgen-dns-proxy.py";
  };
}
