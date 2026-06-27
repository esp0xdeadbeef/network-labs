# Row-local prefix subdivision authority test fixture for
# FS-350-HDS-010-SDS-010-SMS-010.
#
# This fixture exercises the prefix subdivision authority module predicates:
#   MR1: Consume source prefix authority, child prefix purpose, assignment role,
#        site, tenant or access space, and address family.
#   MR2: Derive deterministic child prefixes and endpoint assignments only from
#        modeled authority.
#   MR3: Emit a subdivision plan that names the source authority and child purpose.
#   FC1: Source authority is missing → rejection with diagnostic
#   FC2: Child prefix purpose is ambiguous → rejection with diagnostic
#   FC3: Derived output lacks an authority reference → rejection with diagnostic
#   SN1: Missing source authority on child prefix → REJECT
#   SN2: Ambiguous child prefix purpose → REJECT (recovery: accept after explicit
#        purpose declaration)
#
# The focused construction test in network-forwarding-model exercises all these
# predicates via nix eval against this and related fixtures:
#   tests/test-fs350-prefix-authority-consumer-eligibility.sh

{
  description = "FS-350-HDS-010-SDS-010-SMS-010 row-local prefix subdivision authority fixture";

  # Source prefix authorities — each exercises a different parent prefix
  sourceAuthorities = {
    site-ams-v4 = {
      source = "enterprise:ams";
      family = 4;
      prefix = "10.10.0.0/16";
      role = "access-client";
      purpose = "client-lan";
    };
    site-ams-v6 = {
      source = "enterprise:ams";
      family = 6;
      prefix = "fd42:10::/32";
      role = "access-client";
      purpose = "client-lan-v6";
    };
    site-ams-management = {
      source = "enterprise:ams";
      family = 4;
      prefix = "10.20.0.0/16";
      role = "management";
      purpose = "mgmt";
    };
    site-ams-tenant = {
      source = "enterprise:ams";
      family = 4;
      prefix = "10.30.0.0/16";
      role = "tenant-service";
      purpose = "hostile-services";
    };
    provider-egress = {
      source = "enterprise:ams";
      family = 4;
      prefix = "10.255.0.0/16";
      role = "provider-egress";
      purpose = "nat-egress";
    };
  };

  # Subdivision requests — exercise deterministic child derivation
  subdivisionRequests = [
    # Happy path: valid subdivision with explicit purpose
    {
      id = "subdivide-access-v4-site-1";
      authorityId = "source-authority:site-ams-v4";
      childPurpose = "access-client";
      site = "ams";
      requestedSubdivisions = 4;
    }
    {
      id = "subdivide-access-v6-site-1";
      authorityId = "source-authority:site-ams-v6";
      childPurpose = "access-client";
      site = "ams";
      requestedSubdivisions = 8;
    }
    {
      id = "subdivide-mgmt";
      authorityId = "source-authority:site-ams-management";
      childPurpose = "management";
      site = "ams";
      requestedSubdivisions = 2;
    }

    # Seeded negative: missing source authority
    {
      id = "subdivide-missing-authority";
      authorityId = "source-authority:nonexistent";
      childPurpose = "access-client";
      site = "ams";
      requestedSubdivisions = 4;
    }

    # Seeded negative: ambiguous child purpose (empty purpose)
    {
      id = "subdivide-ambiguous-purpose";
      authorityId = "source-authority:site-ams-v4";
      childPurpose = "";
      site = "ams";
      requestedSubdivisions = 4;
    }

    # Seeded negative: ambiguous child purpose (missing purpose field)
    {
      id = "subdivide-no-purpose";
      authorityId = "source-authority:site-ams-v4";
      site = "ams";
      requestedSubdivisions = 4;
    }

    # Recovery: after adding explicit purpose, subdivision accepted
    {
      id = "subdivide-ambiguous-purpose-recovered";
      authorityId = "source-authority:site-ams-v4";
      childPurpose = "access-client";
      site = "ams";
      requestedSubdivisions = 4;
    }

    # Seeded negative: child prefix without authority reference
    {
      id = "subdivide-no-authority-ref";
      authorityId = "source-authority:site-ams-v4";
      childPurpose = "access-client";
      site = "ams";
      requestedSubdivisions = 4;
      suppressAuthorityReference = true;
    }
  ];

  # Expected results
  expected = {
    "subdivide-access-v4-site-1" = {
      accepted = true;
      childPrefixCount = 4;
      sourceAuthority = "source-authority:site-ams-v4";
      childPurpose = "access-client";
    };
    "subdivide-access-v6-site-1" = {
      accepted = true;
      childPrefixCount = 8;
      sourceAuthority = "source-authority:site-ams-v6";
      childPurpose = "access-client";
    };
    "subdivide-mgmt" = {
      accepted = true;
      childPrefixCount = 2;
      sourceAuthority = "source-authority:site-ams-management";
      childPurpose = "management";
    };
    "subdivide-missing-authority" = {
      accepted = false;
      diagnostic = "missing-source-authority";
    };
    "subdivide-ambiguous-purpose" = {
      accepted = false;
      diagnostic = "ambiguous-child-purpose";
    };
    "subdivide-no-purpose" = {
      accepted = false;
      diagnostic = "ambiguous-child-purpose";
    };
    "subdivide-ambiguous-purpose-recovered" = {
      accepted = true;
      childPrefixCount = 4;
    };
    "subdivide-no-authority-ref" = {
      accepted = false;
      diagnostic = "missing-authority-reference";
    };
  };
}
