{
  layer = "SMT";
  traceId = "FS-165-HDS-010-SDS-010-SMS-010";
  evidence = {
    repo = "network-labs with network-codex-agent checker";
    scope = "source-value necessity validation: accept/reject source values based on source class and downstream derivation";
    isConstructionOnly = true;
  };
  notes = ''
    This SMS governs source-value necessity validation at the model-input
    boundary. The construction test lives in network-codex-agent and exercises
    the Python checker `scripts/helpers/gamp-sms-input-contracts.py` against
    inline JSON fixtures covering all SMS predicates (Module Responsibilities,
    Failure Conditions, and Seeded Negatives SN1/SN2).

    No network-labs intent fixture is required — this is a pure source-level
    validation module, not a network behavior module.
  '';
}
