let
  compilerOutput = import ../compiler-output/minimal-site.nix;
in
compilerOutput
// {
  meta = (compilerOutput.meta or { }) // {
    layerEntryPoc = {
      pocKind = "synthetic-forwarding-model-input";
      schema = "network-labs.layer-entry-poc.forwarding-model-input.v1";
      traceId = "FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp";
    };
  };
}
