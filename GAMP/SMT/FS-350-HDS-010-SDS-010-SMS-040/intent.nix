# This is a row-local prefix authority classification test fixture.
# It defines prefix authority records and consumer requests for exercising
# the NFM authority class separation module (FS-350-HDS-010-SDS-010-SMS-040).
#
# The focused test feeds this fixture to the NFM prefix-authority functions
# via `nix eval` and verifies:
#   - Correct authorityClass assignment for each prefix
#   - Correct childPurpose derivation
#   - Correct consumerEligibility (allowed/denied per class)
#   - Seeded negatives: authority class mixing, missing authority class

{
  description = "FS-350-HDS-010-SDS-010-SMS-040 row-local prefix authority classification fixture";

  # Tenant prefix owners — each exercises a different authority class
  tenantPrefixOwners = {
    access-client-4 = {
      owner = "access-client";
      family = 4;
      dst = "10.10.0.0/24";
      netName = "client-lan";
    };
    access-client-6 = {
      owner = "access-client";
      family = 6;
      dst = "fd42:10:a::/64";
      netName = "client-lan-v6";
    };
    routed-public-v4 = {
      owner = "access-client";
      family = 4;
      kind = "routed-public-ipv4";
      dst = "203.0.113.0/28";
    };
    runtime-routed-gua = {
      owner = "access-client";
      family = 6;
      kind = "runtime-routed-prefix";
      sourceFile = "/run/pd/client.prefix";
      delegatedPrefixLength = 56;
      perTenantPrefixLength = 64;
      slot = 1;
    };
    host-only-provider = {
      owner = "provider-a";
      family = 4;
      dst = "198.51.100.1/32";
      authorityClass = "host-only-provider-prefix";
    };
    nat66-egress = {
      owner = "provider-a";
      family = 6;
      dst = "fd42:egress::/48";
      authorityClass = "nat66-egress-prefix";
    };
    private-ipv4-egress = {
      owner = "provider-a";
      family = 4;
      dst = "10.255.0.0/24";
      authorityClass = "private-ipv4-egress-prefix";
    };
  };

  # Reservations — includes a "reserved-space" entry for seeded negative testing
  reservations = [
    {
      id = "reserved-doc";
      family = 6;
      prefix = "2001:db8:350:bad::/64";
      authorityClass = "reserved-space";
      reservationState = "reserved";
      scopeKind = "site";
      scopeName = "ams";
    }
  ];

  # Consumer requests — exercises allowed and denied cases
  consumerRequests = [
    {
      id = "assign-access-v4";
      consumer = "assignment";
      authorityId = "prefix-authority::access-client::4|10.10.0.0/24";
      family = 4;
    }
    {
      id = "route-access-v4";
      consumer = "route";
      authorityId = "prefix-authority::access-client::4|10.10.0.0/24";
      family = 4;
    }
    {
      id = "translate-access-v4-illegal";
      consumer = "translation";
      authorityId = "prefix-authority::access-client::4|10.10.0.0/24";
      family = 4;
    }
    {
      id = "advertise-access-v4-illegal";
      consumer = "advertisement";
      authorityId = "prefix-authority::access-client::4|10.10.0.0/24";
      family = 4;
    }
    {
      id = "route-runtime-gua";
      consumer = "route";
      authorityId = "prefix-authority::access-client::6|source:/run/pd/client.prefix";
      family = 6;
    }
    {
      id = "advertise-runtime-gua";
      consumer = "advertisement";
      authorityId = "prefix-authority::access-client::6|source:/run/pd/client.prefix";
      family = 6;
    }
    {
      id = "route-host-only";
      consumer = "route";
      authorityId = "prefix-authority::provider-a::4|198.51.100.1/32";
      family = 4;
    }
    {
      id = "assign-host-only-illegal";
      consumer = "assignment";
      authorityId = "prefix-authority::provider-a::4|198.51.100.1/32";
      family = 4;
    }
    {
      id = "translate-nat66-egress";
      consumer = "translation";
      authorityId = "prefix-authority::provider-a::6|fd42:egress::/48";
      family = 6;
    }
    {
      id = "translate-private-ipv4-egress";
      consumer = "translation";
      authorityId = "prefix-authority::provider-a::4|10.255.0.0/24";
      family = 4;
    }
    {
      id = "translate-ipv4-egress";
      consumer = "translation";
      authorityId = "prefix-authority::provider-a::4|10.255.0.0/24";
      family = 4;
      prefix = "10.255.0.1";
    }
    # Seeded negative: consume reserved space
    {
      id = "consume-reserved";
      consumer = "assignment";
      authorityId = "prefix-reservation::reserved-doc";
      family = 6;
    }
    # Seeded negative: unassigned prefix authority (missing class)
    {
      id = "consume-unassigned";
      consumer = "route";
      family = 6;
      prefix = "2001:db8:350:missing::/64";
    }
    # Seeded negative: route from public IPv4
    {
      id = "route-public-v4";
      consumer = "route";
      authorityId = "prefix-authority::access-client::4|203.0.113.0/28";
      family = 4;
    }
    # Seeded negative: expose public IPv4 (allowed)
    {
      id = "expose-public-v4";
      consumer = "exposure";
      authorityId = "prefix-authority::access-client::4|203.0.113.0/28";
      family = 4;
    }
  ];

  # Expected results for each consumer request
  expected = {
    "assign-access-v4" = { allowed = true; reason = "allowed"; };
    "route-access-v4" = { allowed = true; reason = "allowed"; };
    "translate-access-v4-illegal" = { allowed = false; reason = "invalid-consumer-for-authority-class"; };
    "advertise-access-v4-illegal" = { allowed = false; reason = "invalid-consumer-for-authority-class"; };
    "route-runtime-gua" = { allowed = true; reason = "allowed"; };
    "advertise-runtime-gua" = { allowed = true; reason = "allowed"; };
    "route-host-only" = { allowed = true; reason = "allowed"; };
    "assign-host-only-illegal" = { allowed = false; reason = "invalid-consumer-for-authority-class"; };
    "translate-nat66-egress" = { allowed = true; reason = "allowed"; };
    "translate-private-ipv4-egress" = { allowed = true; reason = "allowed"; };
    "consume-reserved" = { allowed = false; reason = "reserved-prefix-authority"; };
    "consume-unassigned" = { allowed = false; reason = "unassigned-prefix-authority"; };
    "route-public-v4" = { allowed = true; reason = "allowed"; };
    "expose-public-v4" = { allowed = true; reason = "allowed"; };
  };
}
