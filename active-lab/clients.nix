# Active lab client model.
#
# Public-safe file:
# - describes client roles and expected behavior
# - does NOT contain real production MACs, circuit IDs, serials, PPPoE passwords,
#   Wi-Fi PSKs, RADIUS secrets, customer names, or provider account identifiers.
#
# Real production identities and credentials are referenced here and stored in SOPS.

{
  clients = {
    client-01 = {
      role = "residential-cpe";
      hostname = "client-01";
      vlan = 20;

      identityRef = "clients/client-01/identity";
      credentialRef = "clients/client-01/credentials";

      pppoe = {
        enabled = true;
        usernameRef = "clients/client-01/identity/pppoeUsername";
        passwordRef = "clients/client-01/credentials/pppoePassword";
      };

      dhcp = {
        enabled = true;
      };

      expected = {
        ipv4 = "10.20.20.101";
        ipv6Prefix = "fd42:dead:beef:20::/64";
      };
    };
  };
}
