{
  pocKind = "synthetic-control-plane-input";
  schema = "network-labs.layer-entry-poc.control-plane-input.v1";
  note = "Contract slot for tests that skip compiler and NFM and start from forwarding plus realization facts.";
  realizationFacts = {
    hostPlacement = "explicit";
    runtimeInterfaces = "explicit";
    secretBindings = "explicit";
  };
}
