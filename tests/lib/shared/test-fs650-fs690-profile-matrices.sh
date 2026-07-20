#!/usr/bin/env bash
# GAMP-ID: FS-650-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-650-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-650-HDS-010-SDS-010-SMS-030
# GAMP-ID: FS-650-HDS-010-SDS-010-SMS-040
# GAMP-ID: FS-660-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-660-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-660-HDS-010-SDS-010-SMS-030
# GAMP-ID: FS-660-HDS-010-SDS-010-SMS-040
# GAMP-ID: FS-670-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-670-HDS-010-SDS-010-SMS-030
# GAMP-ID: FS-670-HDS-010-SDS-010-SMS-040
# GAMP-ID: FS-680-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-680-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-680-HDS-010-SDS-010-SMS-030
# GAMP-ID: FS-680-HDS-010-SDS-010-SMS-040
# GAMP-ID: FS-680-HDS-010-SDS-010-SMS-050
# GAMP-ID: FS-690-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
intent="${repo_root}/GAMP/SAT/intent.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs650-fs690-profile-matrices: $*" >&2
  exit 1
}

nix-instantiate --parse "${intent}" >/dev/null
nix eval --impure --json --expr "import ${intent}" >"${tmp_dir}/intent.json"

jq -e '
  def has_nonempty($key):
    has($key) and (.[$key] != null) and (
      ((.[$key] | type) == "array" and (.[$key] | length) > 0)
      or ((.[$key] | type) == "object" and (.[$key] | length) > 0)
      or ((.[$key] | type) == "string" and (.[$key] | length) > 0)
      or ((.[$key] | type) == "boolean")
    );

  def required_support_fields:
    [
      "sites",
      "scopes",
      "accessSpaces",
      "attachmentPoints",
      "localNames",
      "sharedServices",
      "internetPaths",
      "dnsPaths",
      "managementPaths",
      "publicIngressPaths",
      "deniedPaths",
      "troubleshootingChecks"
    ];

  def required_realization_exclusions:
    [ "host", "interface", "vlan", "secret", "runtimeBinding" ];

  def row_by($rows; $key; $value):
    [ $rows[] | select(.[$key] == $value) ] as $matches
    | if ($matches | length) == 1 then $matches[0] else error("expected one matching row") end;

  def profile_ok($site_name; $site):
    ($site.profileManifest // null) as $manifest
    | ($manifest != null)
    and ($manifest.sourceClass == "intent-profile-manifest")
    and ($manifest.profileIdentity.profileId == ("esp." + $site_name))
    and ($manifest.profileIdentity | has_nonempty("deploymentType"))
    and ($manifest.profileIdentity | has_nonempty("sitePurpose"))
    and ($manifest.profileIdentity.inferredFromRealization == false)
    and (($manifest.surfaces.provider // []) | length > 0)
    and ($manifest.surfaces.management | has_nonempty("scope"))
    and ($manifest.surfaces.management | has_nonempty("source"))
    and (($manifest.surfaces.overlayOrInterSite // []) | length > 0)
    and ($manifest.surfaces.publicIngressCapability.enabled | type == "boolean")
    and (required_realization_exclusions - ($manifest.surfaces.realizationFieldsExcluded // []) | length == 0)
    and (($manifest.scopeManifest.tenants // []) | length > 0)
    and (($manifest.scopeManifest.services // []) | length > 0)
    and (($manifest.scopeManifest.accessSpaces // []) | sort == (($manifest.accessSpaces // {}) | keys | sort))
    and (($manifest.scopeManifest.accessSpaces // []) | sort == (($manifest.tenantAccessMatrix // []) | map(.scope) | sort))
    and (($manifest.scopeManifest.services // []) as $source_services
      | (($site.communicationContract.services // []) | map(.name) - $source_services | length == 0))
    and (($manifest.internetProviderProfile.providers // []) | length > 0)
    and ($manifest.internetProviderProfile | has_nonempty("defaultInternetMode"))
    and (($manifest.accessSpaces // {}) | to_entries | all(
      (.value.attachment | has_nonempty("method"))
      and (.value.attachment | has_nonempty("sourceNode"))
      and ((.value.clientIdentityRules // []) | length > 0)
      and (.value.addressAssignment.ipv4 | has_nonempty("mode"))
      and (.value.addressAssignment.ipv4 | has_nonempty("servedPrefix"))
      and (.value.addressAssignment.ipv6 | has_nonempty("mode"))
      and (.value.addressAssignment.ipv6 | has_nonempty("servedPrefix"))
      and (.value | has_nonempty("resolverAdvertisement"))
      and (.value | has_nonempty("localServiceDiscovery"))
      and (.value | has_nonempty("clientIsolation"))
      and (.value | has_nonempty("onboarding"))
      and (.value | has_nonempty("revocation"))
    ))
    and (($manifest.tenantAccessMatrix // []) | all(
      has_nonempty("scope")
      and has_nonempty("purpose")
      and ((.clientClasses // []) | length > 0)
      and has_nonempty("internetMode")
      and has_nonempty("resolver")
      and has("discoveryExports")
      and has("allowedServices")
      and has("deniedLateralPaths")
      and (.managementExcluded | type == "boolean")
      and ((.negativeProbes // []) | length > 0)
      and has_nonempty("operatorName")
    ))
    and (($manifest.sharedServiceMatrix // []) | length > 0)
    and (($manifest.sharedServiceMatrix // []) | all(
      ((.requesterScopes // []) | length > 0)
      and has_nonempty("responderScope")
      and has_nonempty("serviceClass")
      and has_nonempty("service")
      and (.discovery | has_nonempty("protocol"))
      and (.discovery | has_nonempty("direction"))
      and (.payload | has_nonempty("protocol"))
      and ((.payload.ports // []) | length > 0)
      and (.payload | has_nonempty("direction"))
      and (.payload | has_nonempty("returnBehavior"))
      and has_nonempty("exposure")
      and has_nonempty("authenticationBoundary")
      and has_nonempty("cloudDependency")
      and ((.deniedByDesign // []) | length > 0)
      and has_nonempty("managementBoundary")
    ))
    and (($manifest.tenantAccessMatrix // []) as $tenant_rows
      | ($manifest.sharedServiceMatrix // []) as $service_rows
      | all($tenant_rows[]; . as $tenant
        | all(($tenant.discoveryExports // [])[]; . as $service_name
          | any($service_rows[];
            .service == $service_name
            and ((.requesterScopes // []) | index($tenant.scope)) != null
            and .discovery.protocol != "none"
          )
        )
      )
    )
    and (($manifest.operatorSupportViewSource.fields // []) | sort == (required_support_fields | sort))
    and ($manifest.operatorSupportViewSource.createsAuthority == false)
    and (([
      "profileIdentity",
      "surfaces",
      "scopeManifest",
      "accessSpaces",
      "tenantAccessMatrix",
      "sharedServiceMatrix"
    ] - ($manifest.operatorSupportViewSource.modeledSources // [])) | length == 0)
    and (($manifest.operatorSupportViewSource.inventorySources // []) | length > 0)
    and (($manifest.operatorSupportViewSource.runtimeSources // []) | length > 0);

  .esp as $esp
  | ($esp | keys | sort) == [ "clab", "hetz", "nixos" ]
  and ($esp | to_entries | all(profile_ok(.key; .value)))
  and (row_by($esp.nixos.profileManifest.tenantAccessMatrix; "scope"; "client").discoveryExports == [ "cast-discovery" ])
  and (row_by($esp.nixos.profileManifest.tenantAccessMatrix; "scope"; "streaming").discoveryExports == [ ])
  and (row_by($esp.clab.profileManifest.tenantAccessMatrix; "scope"; "client").discoveryExports == [ "cast-discovery" ])
  and (row_by($esp.clab.profileManifest.tenantAccessMatrix; "scope"; "streaming").discoveryExports == [ ])
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "GAMP/SAT/intent.nix profileManifest rows are missing required FS-650..FS-690 source fields"

for marker in \
  SAT-SRC-PROFILE-MANIFEST-NIXOS \
  SAT-SRC-PROFILE-MANIFEST-HETZ \
  SAT-SRC-PROFILE-MANIFEST-CLAB; do
  grep -Fq "${marker}" "${intent}" || fail "missing ${marker}"
done

echo "PASS fs650-fs690-profile-matrices"
