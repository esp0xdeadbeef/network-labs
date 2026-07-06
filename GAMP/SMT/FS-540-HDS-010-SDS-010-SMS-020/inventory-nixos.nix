{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-020";
    scope = "dns-resolver-config";
  };
  hosts = { };
  endpoints = {
    access-dns = {
      ipv4 = [ "10.54.10.1" ];
      ipv6 = [ "fd42:540::1" ];
    };
  };
  deploymentHosts = {
    s-router-nixos = {
      bridgeNetworks = {
        admin = { };
        branch = { };
        client = { };
      };
    };
  };
}
