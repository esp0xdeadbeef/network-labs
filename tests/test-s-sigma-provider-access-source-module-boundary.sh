#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-012-SMS-010
# GAMP-ID: FS-800-HDS-010-SDS-013-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${NETWORK_REPO_DIRECT_TEST_OK:-0}" != "1" && "${NETWORK_REPO_SWEEP:-0}" != "1" ]]; then
  echo "WARN: direct repo tests are partial; set NETWORK_REPO_DIRECT_TEST_OK=1 for intentional focused runs." >&2
fi

# shellcheck disable=SC2016
REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
  let
    root = builtins.getEnv "REPO_ROOT";
    intent = import (root + "/sat/intent.nix");
    inventory = import (root + "/sat/inventory.nix");
    table = import (root + "/sat/provider-access-fixture-table.nix");

    sds012 = "FS-800-HDS-010-SDS-012-SMS-010";
    sds013 = "FS-800-HDS-010-SDS-013-SMS-010";

    require = cond: msg: if cond then true else throw msg;
    attachmentNames = builtins.attrNames table.attachments;
    row = name: table.attachments.${name};

    forbiddenAuthorityFields = [
      "addressAuthority"
      "links"
      "policy"
      "policyAuthority"
      "providerAuthority"
      "routeAuthority"
      "routes"
      "sideChannel"
      "topology"
      "topologyClass"
      "uplinks"
      "upstreamEmulation"
    ];

    validateSds012Row = name: current:
      require (current.sourceClass == "provider-access-realization-fact")
        "${sds012}: provider-access ${name} must remain a realization-fact source record"
      && require (current.realizationAuthority == "inventory")
        "${sds012}: provider-access ${name} must keep inventory as the only realization authority"
      && require (current.sideChannelAuthority == false)
        "${sds012}: provider-access ${name} must reject side-channel authority"
      && require (current.topologyAuthority == false)
        "${sds012}: provider-access ${name} must reject topology authority"
      && require (builtins.all (field: !(builtins.hasAttr field current)) forbiddenAuthorityFields)
        "${sds012}: provider-access ${name} must not carry alternate policy/topology/provider authority fields";

    expectSds012Rejected = name: mutationName: mutated:
      let
        result = builtins.tryEval (validateSds012Row name mutated);
      in
        require (!result.success)
          "${sds012}: provider-access ${name} accepted forbidden ${mutationName}";

    validateSds013Row = name:
      let
        current = row name;
        access = current.attachment;
      in
        require (current.sourceClass == "provider-access-realization-fact")
          "${sds013}: provider-access ${name} must be represented as a source-module realization fact"
        && require (access.kind == "access-space")
          "${sds013}: provider-access ${name} must bind canonical provider access to access space"
        && require (access.method == "tenant-access")
          "${sds013}: provider-access ${name} must remain an ordinary tenant-access attachment"
        && require (!(current ? topologyClass))
          "${sds013}: provider-access ${name} must not be represented as an ad hoc topology class";

    encodedIntent = builtins.toJSON intent;
    encodedAttachmentStage = builtins.toJSON inventory.controlPlane.providerAccess.attachments;
    encodedTopology = builtins.toJSON intent.esp;
  in
    if require (attachmentNames != [ ])
      "${sds013}: provider-access source module must define attachment records"
      && require (inventory.controlPlane.providerAccess.attachments == table.attachments)
        "${sds013}: canonical provider-access stage must be inventory.controlPlane.providerAccess.attachments sourced from sat/provider-access-fixture-table.nix"
      && require (builtins.match ".*upstreamEmulation.*" encodedIntent == null)
        "${sds012}: intent.nix must not carry upstreamEmulation side-channel authority"
      && require (builtins.match ".*providerAccess.*" encodedIntent == null)
        "${sds012}: intent.nix must not carry providerAccess side-channel authority"
      && require (builtins.match ".*topologyClass.*" encodedAttachmentStage == null)
        "${sds013}: provider-access attachment stage must not encode ad hoc topology classes"
      && require (builtins.match ".*providerAccess.*" encodedTopology == null)
        "${sds013}: provider-access must not appear as an intent topology class"
      && builtins.all (name: validateSds012Row name (row name)) attachmentNames
      && builtins.all validateSds013Row attachmentNames
      && expectSds012Rejected "pppoeNixos" "sideChannelAuthority=true" ((row "pppoeNixos") // { sideChannelAuthority = true; })
      && expectSds012Rejected "pppoeNixos" "topologyAuthority=true" ((row "pppoeNixos") // { topologyAuthority = true; })
      && expectSds012Rejected "dhcpSlaacNixosClient" "routeAuthority" ((row "dhcpSlaacNixosClient") // { routeAuthority = "provider-access"; })
      && expectSds012Rejected "nebulaNixosUnderlay" "policyAuthority" ((row "nebulaNixosUnderlay") // { policyAuthority = "provider-access"; })
      && expectSds012Rejected "wireguardRemoteEgressHetz" "topologyClass" ((row "wireguardRemoteEgressHetz") // { topologyClass = "provider-access"; })
      && expectSds012Rejected "wireguardHost128Hetz" "providerAuthority" ((row "wireguardHost128Hetz") // { providerAuthority = "alternate-policy-source"; })
    then "true"
    else "unreachable"
' >/dev/null

echo "PASS s-sigma-provider-access-source-module-boundary"
