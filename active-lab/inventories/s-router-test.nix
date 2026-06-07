# Host-specific inventory projection for s-router-test.
#
# Public-safe file:
# - no real customer MACs
# - no real circuit IDs
# - no provider/customer identifiers
# - no credentials

{
  hostName = "s-router-test";
  backend = "nixos";

  nodes = {
    s-router-test = {
      role = "router";

      interfaces = {
        wan = {
          kind = "uplink";
        };

        lan = {
          kind = "client-access";
          vlans = [ 20 ];
        };
      };
    };
  };
}
