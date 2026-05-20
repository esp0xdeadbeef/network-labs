{ renderer ? "nixos" }:

let
  inventory = import ./getInventory.nix { inherit renderer; };
  inventorySops = import ./getInventorySops.nix;
  delegatedPrefixes = inventorySops.runtimeFacts.delegatedPrefixes;
  secretPath = name: "/run/secrets/${name}";
  runtimePrefixInventory = {
    controlPlane.sites.esp.clab.tenants = {
      client.routedPrefixes.clab-client-public.sourceFile = secretPath delegatedPrefixes.clabClient;
      hostile.routedPrefixes.hostile-public.sourceFile = secretPath delegatedPrefixes.clabHostile;
    };
    controlPlane.sites.esp.hetz.tenants = {
      client.routedPrefixes.hetz-client-public.sourceFile = secretPath delegatedPrefixes.hetzClient;
    };
  };
  recursiveUpdate =
    left: right:
    left
    // builtins.mapAttrs
      (
        name: value:
        if builtins.isAttrs value && builtins.isAttrs (left.${name} or null) then
          recursiveUpdate left.${name} value
        else
          value
      )
      right;
in
builtins.foldl' recursiveUpdate { } [
  inventory
  runtimePrefixInventory
  { runtime = inventorySops.runtimeFacts; }
]
