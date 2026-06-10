# active-lab/sops-routing-s-router-clab.nix
# HAT-emulated: empty sops module - PPPoE credentials come from CPM, not SOPS
{ ... }:

{
  # No SOPS secrets required for HAT testing.
  # PPPoE credentials are provisioned by CPM via plaintext test materializer.
  # Client identity (mac, pppoeUsername) is provided by the renderer from inventory.
}
