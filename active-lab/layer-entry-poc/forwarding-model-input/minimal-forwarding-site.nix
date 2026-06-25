{
  pocKind = "synthetic-forwarding-model-input";
  schema = "network-labs.layer-entry-poc.forwarding-model-input.v1";
  note = "Contract slot for tests that skip compiler output construction and start from forwarding semantics.";
  forwardingFacts = {
    transit = "explicit";
    routeIntent = "explicit";
    policy = "explicit";
  };
}
