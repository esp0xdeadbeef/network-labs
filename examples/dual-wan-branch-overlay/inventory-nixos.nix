let
  base = import ./inventory-base.nix;
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
                "enterpriseA::site-a::s-router-core-isp-a" = "uplink0";
                "enterpriseA::site-a::s-router-core-isp-b" = "uplink1";
                "enterpriseB::site-b::b-router-core-wan" = "uplink1";
              };
            };
        };
    };
}
