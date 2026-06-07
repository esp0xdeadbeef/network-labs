# Active lab client identities and expected runtime behavior.
# Keep credentials out of this file; put passwords/PSKs/secrets in ./secrets/*.yaml.

{
  clients = {
    client-01 = {
      mac = "02:00:00:00:10:01";
      hostname = "client-01";
      vlan = 20;

      pppoe = {
        username = "client-01";
      };

      expected = {
        ipv4 = "10.20.20.101";
        ipv6Prefix = "fd42:dead:beef:20::/64";
      };
    };
  };
}
