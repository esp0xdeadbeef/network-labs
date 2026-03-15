{
  endpoints = {

    web01 = {
      ipv4 = [ "10.20.15.10" ];
      ipv6 = [ "fd42:dead:beef:15::10" ];
    };

    s-sigma = {
      ipv4 = [ "10.20.10.10" ];
      ipv6 = [ "fd42:dead:beef:10::10" ];
    };

  };

  fabric = {

    s-router-access-admin = {
      platform = "linux";

      ports = {

        port1 = {
          link = "p2p-s-router-access-admin-s-router-policy";
        };

        port2 = {
          attachment = {
            kind = "tenant";
            name = "admin";
          };

          hosts = [ "web01" ];
        };

      };
    };

    s-router-access-mgmt = {
      platform = "linux";

      ports = {

        port1 = {
          link = "p2p-s-router-access-mgmt-s-router-policy";
        };

        port2 = {
          attachment = {
            kind = "tenant";
            name = "mgmt";
          };

          hosts = [ "s-sigma" ];
        };

      };
    };

  };
}
