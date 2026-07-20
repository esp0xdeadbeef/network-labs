{
  layer = "SMT";
  traceId = "FS-350-HDS-010-SDS-010-SMS-030";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-350-HDS-010-SDS-010-SMS-030__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    smtRow = "GAMP/SMT/README.md row 221";
    status = "OK";
    verifiedAt = "network-forwarding-model local HEAD (2026-07-02)";
    scope = "overlay participant ledger: segments overlay node IPAM by overlay identity, emits one participant-address ledger per overlay, rejects cross-ledger assignments with wrong-overlay-ledger diagnostics (construction-only, NFM-owned)";
  };
}
