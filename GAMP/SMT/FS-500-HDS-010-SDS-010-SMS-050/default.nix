{
  layer = "SMT";
  traceId = "FS-500-HDS-010-SDS-010-SMS-050";
  smsRow = ../../SMS/FS-500-HDS-010-SDS-010-SMS-050;
  sitRow = ../../SIT/FS-500-HDS-010-SDS-010;
  evidenceBoundary = "construction-only";
  source = null;
  purpose = "SMT construction-only row: p2p bridge co-location module. Runtime materialization is owned by HAT, not SMT.";
  evidence = {
    owningRepos = [
      "network-renderer-nixos"
      "network-renderer-containerlab-linux-backend"
    ];
    status = "NOT OK";
    scope = "NixOS host bridge co-location and CLAB link co-location for selector fabric p2p links; includes both seeded negatives.";
  };
}
