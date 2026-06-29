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
    observedResult = "NOT OK live on 2026-06-29: row-local mini-SMT and focused construction checks pass, and current-lab is selected to SIT FS-540-HDS-010-SDS-010 with the five-node mini path access-dns, downstream-selector, policy, upstream-selector, resolver-node. Targeted NixOS dry-runs for s-router-nixos, s-router-clab, and s-router-test-clients pass with network-labs overridden to this checkout. Live probe against 192.168.1.17/192.168.1.19 now correctly rejects the deployed remote artifacts before DNS assertions because the remotes are still broad HAT-sized topologies: s-router-nixos has 12 runtime targets named esp-nixos-nixos-router-* and s-router-clab has 11 runtime targets named esp-clab-clab-router-*, both missing access-dns and resolver-node. Runtime DNS remains NOT OK until the remote hosts are rebuilt from this FS-540 mini current-lab selection and the live recursive DNS assertions pass on the mini containers.";
  };
}
