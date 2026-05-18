{ renderer ? "nixos" }:

let
  inventory = import ./getInventory.nix { inherit renderer; };
  inventorySops = import ./getInventorySops.nix;
  publicDnsForwarders = inventorySops.runtimeFacts.resolverForwarders.publicDnsForwarders;
  delegatedPrefixes = inventorySops.runtimeFacts.delegatedPrefixes;
  secretPath = name: "/run/secrets/${name}";
  placeholderValues = {
    runtime-public-dns-ipv4-primary = builtins.elemAt publicDnsForwarders 0;
    runtime-public-dns-ipv4-secondary = builtins.elemAt publicDnsForwarders 1;
    runtime-public-dns-ipv6-primary = builtins.elemAt publicDnsForwarders 2;
    runtime-public-dns-ipv6-secondary = builtins.elemAt publicDnsForwarders 3;
  };
  resolveRuntimePlaceholders =
    value:
    if builtins.isAttrs value then
      builtins.mapAttrs (_: resolveRuntimePlaceholders) value
    else if builtins.isList value then
      builtins.map resolveRuntimePlaceholders value
    else if builtins.isString value && builtins.hasAttr value placeholderValues then
      placeholderValues.${value}
    else
      value;
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
    // builtins.mapAttrs (
      name: value:
      if builtins.isAttrs value && builtins.isAttrs (left.${name} or null) then
        recursiveUpdate left.${name} value
      else
        value
    ) right;
in
builtins.foldl' recursiveUpdate { } [
  (resolveRuntimePlaceholders inventory)
  runtimePrefixInventory
  { runtime = inventorySops.runtimeFacts; }
]
