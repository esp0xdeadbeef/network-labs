{ renderer ? "nixos" }:

let
  inventory = import ./getInventory.nix { inherit renderer; };
  inventorySops = import ./getInventorySops.nix;
  publicDnsForwarders = inventorySops.runtimeFacts.resolverForwarders.publicDnsForwarders;
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
in
(resolveRuntimePlaceholders inventory) // { runtime = inventorySops.runtimeFacts; }
