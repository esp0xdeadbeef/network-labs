#!/usr/bin/env bash
# GAMP-ID: FS-770-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"
cpm_flake="${CPM_FLAKE:-github:esp0xdeadbeef/network-control-plane-model}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

build_cpm() {
  local inventory_name="$1"
  local output_json="$2"

  nix run "${cpm_flake}#compile-and-build-control-plane-model" -- \
    "${hat_dir}/intent.nix" \
    "${hat_dir}/${inventory_name}" \
    "${output_json}" >/dev/null
}

canonicalize() {
  local input_json="$1"
  local site_name="$2"

  jq -S --arg site_name "${site_name}" '
    def normalize_profile_name:
      gsub("^nixos-"; "profile-")
      | gsub("^clab-"; "profile-")
      | gsub("^esp0xdeadbeef-site-a-"; "esp0xdeadbeef-site-")
      | gsub("^esp0xdeadbeef-site-b-"; "esp0xdeadbeef-site-");

    def dns_surface($runtime_targets):
      $runtime_targets
      | to_entries
      | map(select(.value.services.dns != null))
      | map({
          node: (.value.logicalNode.name | normalize_profile_name),
          dns: {
            allowFromCount: ((.value.services.dns.allowFrom // []) | length),
            allowedUpstreamClasses: (.value.services.dns.allowedUpstreamClasses // []),
            blockDirectEgress: (.value.services.dns.blockDirectEgress // false),
            deniedResolverCidrs: (.value.services.dns.deniedResolverCidrs // []),
            directEgressBlockedTenants: (.value.services.dns.directEgressBlockedTenants // []),
            killSwitch: (.value.services.dns.killSwitch // {}),
            listenCount: ((.value.services.dns.listen // []) | length),
            policyMatrix: (
              (.value.services.dns.policyMatrix // [])
              | map({
                  scope,
                  source,
                  dstClass: (
                    if (.dst | type) == "string" and (.dst | test(":")) then
                      "ipv6"
                    else
                      "ipv4"
                    end
                  )
                })
              | sort_by(.scope, .source, .dstClass)
            ),
            routeContracts: (
              (.value.services.dns.routeContracts // [])
              | map({
                  scope,
                  source,
                  dstClass: (
                    if (.dst | type) == "string" and (.dst | test(":")) then
                      "ipv6"
                    else
                      "ipv4"
                    end
                  )
                })
              | sort_by(.scope, .source, .dstClass)
            ),
            routePreference: (.value.services.dns.routePreference // [])
          }
        })
      | sort_by(.node);

    .control_plane_model.data.esp0xdeadbeef[$site_name] as $site
    | {
        communicationContract: {
          services: (
            ($site.communicationContract.services // [])
            | map({
                name,
                trafficType,
                providers: ((.providers // []) | map(normalize_profile_name) | sort)
              })
            | sort_by(.name)
          ),
          trafficTypes: (
            ($site.communicationContract.trafficTypes // [])
            | map({
                name,
                match: ((.match // []) | sort_by(.proto, (.family // ""), ((.dports // []) | tostring)))
              })
            | sort_by(.name)
          ),
          allowedRelations: (
            ($site.communicationContract.allowedRelations // [])
            | map({ id, action, priority, trafficType, from, to })
            | sort_by(.id)
          )
        },
        forwardingSemanticsDns: {
          explicit: ($site.forwardingSemantics.dns.explicit // false),
          accessNodeNames: (($site.forwardingSemantics.dns.accessNodeNames // []) | map(normalize_profile_name) | sort),
          nonWanCoreNodeNames: (($site.forwardingSemantics.dns.nonWanCoreNodeNames // []) | map(normalize_profile_name) | sort),
          resolverPreferenceNodeNames: (($site.forwardingSemantics.dns.resolverPreferenceNodeNames // []) | map(normalize_profile_name) | sort),
          serviceNodeNames: (($site.forwardingSemantics.dns.serviceNodeNames // []) | map(normalize_profile_name) | sort),
          wanFallbackNodeNames: (($site.forwardingSemantics.dns.wanFallbackNodeNames // []) | map(normalize_profile_name) | sort)
        },
        accessDnsSemantics: dns_surface($site.runtimeTargets)
      }
  ' "${input_json}"
}

build_cpm "inventory-nixos.nix" "${tmp_dir}/nixos.json"
build_cpm "inventory-clab.nix" "${tmp_dir}/clab.json"

canonicalize "${tmp_dir}/nixos.json" "site-a" >"${tmp_dir}/nixos-canonical.json"
canonicalize "${tmp_dir}/clab.json" "site-b" >"${tmp_dir}/clab-canonical.json"

diff -u "${tmp_dir}/nixos-canonical.json" "${tmp_dir}/clab-canonical.json" >/dev/null || {
  echo "FAIL hat-common-intent-shared-service-source: HAT CLAB and NixOS profiles do not preserve the same normalized shared-service contract, service-path relations, and DNS forwarding semantics from the common behavior source" >&2
  diff -u "${tmp_dir}/nixos-canonical.json" "${tmp_dir}/clab-canonical.json" >&2 || true
  exit 1
}

echo "PASS hat-common-intent-shared-service-source"
