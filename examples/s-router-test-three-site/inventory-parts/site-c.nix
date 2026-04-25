{
  base,
  publicDns4,
  publicDns6,
  policyDerivedDns,
}:
let
  source = import ../../tri-site-dual-wan-overlay-integration-bgp/inventory-parts/site-c.nix {
    inherit
      base
      publicDns4
      publicDns6
      policyDerivedDns
      ;
  };
in
source
