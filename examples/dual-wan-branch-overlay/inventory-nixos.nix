let
  base = import ./inventory.nix;
in
base
// {
  deployment =
    base.deployment
    // {
      hosts =
        base.deployment.hosts
        // {
          lab-host =
            base.deployment.hosts.lab-host
            // {
              wanGroupToUplink = {
                "enterpriseB::site-b::b-router-core" = "uplink1";
              };
            };
        };
    };
}
