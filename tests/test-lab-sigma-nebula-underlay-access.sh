#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

if [[ "${NETWORK_REPO_DIRECT_TEST_OK:-0}" != "1" && "${NETWORK_REPO_SWEEP:-0}" != "1" ]]; then
  echo "WARN: direct repo tests are partial; set NETWORK_REPO_DIRECT_TEST_OK=1 for intentional focused runs." >&2
fi

export REPO_ROOT="$repo_root"

nix-instantiate --eval --strict --json --expr '
let
  intent = import (builtins.getEnv "REPO_ROOT" + "/labs/lab-s-sigma/s-router-test-three-site/intent.nix");

  require = label: cond:
    if cond then true else throw label;

  getSite = site: intent.esp.${site};

  hasAccessNode = site: node: tenant:
    let
      n = (getSite site).topology.nodes.${node} or null;
    in
    n != null
    && (n.role or null) == "access"
    && builtins.any
      (attachment:
        (attachment.kind or null) == "tenant"
        && (attachment.name or null) == tenant)
      (n.attachments or []);

  hasTenantAttachment = site: node: tenant:
    let
      n = (getSite site).topology.nodes.${node} or null;
    in
    n != null
    && builtins.any
      (attachment:
        (attachment.kind or null) == "tenant"
        && (attachment.name or null) == tenant)
      (n.attachments or []);

  hasLink = site: a: b:
    builtins.any
      (link:
        builtins.length link == 2
        && (
          (builtins.elemAt link 0 == a && builtins.elemAt link 1 == b)
          || (builtins.elemAt link 0 == b && builtins.elemAt link 1 == a)
        ))
      ((getSite site).topology.links or []);

  overlay = site: builtins.head ((getSite site).transport.overlays or []);

  checkSite = site: core: access:
    require "${site}: missing selected client access router for Nebula underlay WAN side"
      (hasAccessNode site access "client")
    && require "${site}: Nebula core underlay must be a host-like client tenant attachment"
      (hasTenantAttachment site core "client")
    && require "${site}: Nebula underlay must not be a p2p link to the selected access router"
      (! hasLink site core access)
    && require "${site}: Nebula underlay must not be a direct p2p link to upstream"
      (! hasLink site core ((if site == "hetz" then "hetz" else if site == "clab" then "clab" else "nixos") + "-router-upstream"))
    && require "${site}: selected underlay access must still traverse downstream/policy fabric"
      (hasLink site access ((if site == "hetz" then "hetz" else if site == "clab" then "clab" else "nixos") + "-router-downstream"))
    && require "${site}: overlay must select client as explicit underlayAccess"
      ((overlay site).underlayAccess == { kind = "tenant"; name = "client"; });
in
  checkSite "nixos" "nixos-router-core-nebula" "nixos-router-access-client"
  && checkSite "hetz" "hetz-router-nebula-core" "hetz-router-access-client"
  && checkSite "clab" "clab-router-core-nebula" "clab-router-access-client"
' >/dev/null

echo "PASS lab-sigma-nebula-underlay-access"
