let
  base = import ../dual-wan-branch-overlay/inventory.nix;
in
base // {
  controlPlane =
    (base.controlPlane or { })
    // {
      sites =
        ((base.controlPlane or { }).sites or { })
        // {
          enterpriseA =
            (((base.controlPlane or { }).sites or { }).enterpriseA or { })
            // {
              "site-a" =
                ((((base.controlPlane or { }).sites or { }).enterpriseA or { })."site-a" or { })
                // {
                  routing = {
                    mode = "bgp";
                    bgp = {
                      asn = 65000;
                      topology = "policy-rr";
                    };
                  };
                };
            };

          enterpriseB =
            (((base.controlPlane or { }).sites or { }).enterpriseB or { })
            // {
              "site-b" =
                ((((base.controlPlane or { }).sites or { }).enterpriseB or { })."site-b" or { })
                // {
                  routing = {
                    mode = "bgp";
                    bgp = {
                      asn = 65100;
                      topology = "policy-rr";
                    };
                  };
                };
            };
        };
    };
}
