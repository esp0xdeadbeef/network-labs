# NixOS / s-router-test inventory projection for this lab.
# This is host-specific deployment inventory, not the CPM intent.

{
  hostName = "s-router-test";

  backend = "nixos";

  nodes = {
    s-router-test = {
      role = "router";
    };
  };
}
