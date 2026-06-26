{
  layer = "SMT";
  traceId = "FS-240-HDS-010-SDS-010-SMS-020";
  miniSmtId = "management-plane-authority";
  source = {
    kind = "sat-source";
    fixture = ../../SAT/management-core-host-authority.nix;
    siteRoleMap = ../../SAT/site-role-map.nix;
  };
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-management-core-host-authority-source.sh";
    focusedTest = "tests/test-management-core-host-authority-source.sh";
    scope = "SAT source validation: management-plane authority exclusion, core-host exception constraints, seeded negatives for non-management authority reuse and missing required fields";
  };
}
