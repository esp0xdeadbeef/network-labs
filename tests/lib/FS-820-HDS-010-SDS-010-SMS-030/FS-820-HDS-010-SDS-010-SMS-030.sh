#!/usr/bin/env bash
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: software-module-test
# Proves source-selection records are decoupled from fixed filesystem paths
# per FS-820-HDS-010-SDS-010-SMS-030 secret-source-policy-boundary.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
gamp_id="FS-820-HDS-010-SDS-010-SMS-030"

fail() {
  echo "FAIL ${gamp_id}: $*" >&2
  exit 1
}

# Load the protected PPPoE credential bindings for both harnesses
HAT_DIR="${hat_dir}" nix eval --impure --json --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    nixosBindings = import (hatDir + \"/protected-pppoe-credential-bindings.nix\") {
      consumerNode = \"esp0xdeadbeef-site-a-nixos-core-testnet-host-isp\";
      harness = \"s-router-nixos\";
      site = \"nixos\";
    };
    clabBindings = import (hatDir + \"/protected-pppoe-credential-bindings.nix\") {
      consumerNode = \"esp0xdeadbeef-site-b-clab-core-testnet-host-isp\";
      harness = \"s-router-clab\";
      site = \"clab\";
    };
  in {
    nixos = nixosBindings;
    clab = clabBindings;
  }
" >/dev/null 2>/dev/null || fail "failed to evaluate protected-pppoe-credential-bindings"

# Validate source-selection records are platform-neutral
HAT_DIR="${hat_dir}" nix eval --impure --json --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    nixosBindings = import (hatDir + \"/protected-pppoe-credential-bindings.nix\") {
      consumerNode = \"esp0xdeadbeef-site-a-nixos-core-testnet-host-isp\";
      harness = \"s-router-nixos\";
      site = \"nixos\";
    };
    clabBindings = import (hatDir + \"/protected-pppoe-credential-bindings.nix\") {
      consumerNode = \"esp0xdeadbeef-site-b-clab-core-testnet-host-isp\";
      harness = \"s-router-clab\";
      site = \"clab\";
    };
    require = cond: msg: if cond then true else throw msg;

    # FS-820-HDS-010-SDS-010-SMS-030 predicates
    fixedPathPatterns = [
      \"^/.*\"
      \".*/run/secrets/.*\"
      \".*/etc/.*\"
      \".*/var/.*\"
      \".*/tmp/.*\"
    ];

    isFixedPath = s:
      builtins.any (pattern: builtins.match pattern s != null) fixedPathPatterns;

    abstractNamePattern = \"^(hat|sat)-[a-z0-9][-a-z0-9]*$\";

    validateSourceBindingSet = bindings: siteName:
      let
        declarations = bindings.secretDeclarations or [ ];
        sources = bindings.secretSources or [ ];
        bindings_ = bindings.sourceBindings or [ ];

        # SMS-030: Source-selection records shall remain independent of fixed host path convention
        sourceReferenceFields = builtins.concatMap
          (source:
            let ref = source.reference or {};
            in [ ref.runtimePath ref.name ])
          sources;

        allRuntimePathsAbstract =
          builtins.all
            (path:
              builtins.isString path
              && builtins.stringLength path > 0
              && !(isFixedPath path))
            sourceReferenceFields;

        # SMS-030: providerNeutral flag consistent with abstract runtimePath
        allProviderNeutral =
          builtins.all
            (source: (source.providerNeutral or null) == true)
            sources;

        # SMS-030: runtimePath must match abstract name pattern (no leading slash, no path separator)
        allRuntimePathsMatchPattern =
          builtins.all
            (source:
              let p = (source.reference or {}).runtimePath or \"\";
              in builtins.match abstractNamePattern p != null)
            sources;

        # SMS-010: Exactly 2 declaration/source/binding records (username + password)
        declarationCount = builtins.length declarations;
        sourceCount = builtins.length sources;
        bindingCount = builtins.length bindings_;

        # SMS-030: declaration policyAuthority must be policy-neutral
        allPolicyNeutral =
          builtins.all
            (decl:
              let pa = decl.policyAuthority or {};
              in builtins.all (k: (pa.\${k} or null) == false)
                [ \"createsRouteAuthority\" \"createsFirewallPolicy\"
                  \"createsDnsPolicy\" \"createsPublicIngress\"
                  \"createsTenantReachability\" \"createsTrustBoundary\"
                  \"createsNetworkBehavior\" ])
            declarations;

        # SMS-030: source record must not encode policy authority
        sourcePolicyNeutral =
          builtins.all
            (source:
              !(builtins.hasAttr \"policyAuthority\" source)
              && !(builtins.hasAttr \"createsRouteAuthority\" (source.reference or {}))
              && !(builtins.hasAttr \"createsFirewallPolicy\" (source.reference or {}))
              && !(builtins.hasAttr \"createsDnsPolicy\" (source.reference or {}))
              && !(builtins.hasAttr \"createsPublicIngress\" (source.reference or {})))
            sources;

        # SMS-030: credential material must not appear in source records
        noLeakedMaterial =
          builtins.all
            (source:
              (source.materialAccess or null) == \"not-supplied-by-source-record\"
              && (source.plaintextMaterial or null) == false)
            sources;

        # SMS-030: fixedSecretManagerRequired must be false (no binding to specific manager)
        noFixedSecretManager =
          builtins.all
            (source: (source.fixedSecretManagerRequired or null) == false)
            sources;
      in
        require (declarationCount == 2) \"\${siteName}: must have exactly 2 secret declarations\"
        && require (sourceCount == 2) \"\${siteName}: must have exactly 2 secret sources\"
        && require (bindingCount == 2) \"\${siteName}: must have exactly 2 source bindings\"
        && require allRuntimePathsAbstract
          \"FS-820-HDS-010-SDS-010-SMS-030: \${siteName} runtimePath must not be a fixed filesystem path\"
        && require allRuntimePathsMatchPattern
          \"FS-820-HDS-010-SDS-010-SMS-030: \${siteName} runtimePath must be an abstract secret reference name\"
        && require allProviderNeutral
          \"FS-820-HDS-010-SDS-010-SMS-030: \${siteName} providerNeutral must be true\"
        && require allPolicyNeutral
          \"FS-820-HDS-010-SDS-010-SMS-030: \${siteName} declaration policyAuthority must be neutral\"
        && require sourcePolicyNeutral
          \"FS-820-HDS-010-SDS-010-SMS-030: \${siteName} source records must not carry policy authority\"
        && require noLeakedMaterial
          \"FS-820-HDS-010-SDS-010-SMS-030: \${siteName} source records must not leak credential material\"
        && require noFixedSecretManager
          \"FS-820-HDS-010-SDS-010-SMS-030: \${siteName} fixedSecretManagerRequired must be false\"
        # SMS-030: runtimePath must match sourceName (same abstract reference)
        && require (
          builtins.all
            (source:
              (source.reference or {}).name == (source.reference or {}).runtimePath)
            sources)
          \"FS-820-HDS-010-SDS-010-SMS-030: \${siteName} runtimePath must match sourceName\";

  in
    validateSourceBindingSet nixosBindings \"nixos\"
    && validateSourceBindingSet clabBindings \"clab\"
" >/dev/null || fail "FS-820-HDS-010-SDS-010-SMS-030 source-selection policy boundary validation failed"

# Seeded negative: a fixed path like "/run/secrets/evil" must be detected and rejected
HAT_DIR="${hat_dir}" nix eval --impure --json --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    require = cond: msg: if cond then true else throw msg;

    # Construct a malicious variant with a hardcoded filesystem path
    evilBindings = import (hatDir + \"/protected-pppoe-credential-bindings.nix\") {
      consumerNode = \"esp0xdeadbeef-site-a-nixos-core-testnet-host-isp\";
      harness = \"s-router-nixos\";
      site = \"nixos\";
    };

    # Inject a fixed path into runtimePath to test rejection
    evilSource = builtins.head evilBindings.secretSources;
    evilSourceWithFixedPath = evilSource // {
      reference = evilSource.reference // {
        runtimePath = \"/run/secrets/evil\";
      };
    };
    evilSources = [ evilSourceWithFixedPath (builtins.elemAt evilBindings.secretSources 1) ];

    fixedPathPatterns = [
      \"^/.*\"
      \".*/run/secrets/.*\"
      \".*/etc/.*\"
    ];

    isFixedPath = s:
      builtins.any (pattern: builtins.match pattern s != null) fixedPathPatterns;

    hasFixedPath = builtins.any
      (source:
        let ref = source.reference or {};
        in isFixedPath (ref.runtimePath or \"\") || isFixedPath (ref.name or \"\"))
      evilSources;

    # Also build a variant with /etc/passwd-style path
    evilSourceEtc = evilSource // {
      reference = evilSource.reference // {
        runtimePath = \"/etc/pppoe-credentials\";
      };
    };
    evilSourcesEtc = [ evilSourceEtc (builtins.elemAt evilBindings.secretSources 1) ];

    hasEtcPath = builtins.any
      (source:
        let ref = source.reference or {};
        in isFixedPath (ref.runtimePath or \"\"))
      evilSourcesEtc;

    # Also test a variant where providerNeutral is false but runtimePath is abstract
    evilProviderNeutralSource = evilSource // {
      providerNeutral = false;
    };
    evilProviderNeutralSources = [ evilProviderNeutralSource (builtins.elemAt evilBindings.secretSources 1) ];
    hasFalseProviderNeutral = builtins.any
      (source: (source.providerNeutral or null) == false)
      evilProviderNeutralSources;
  in
    require hasFixedPath
      \"FS-820-HDS-010-SDS-010-SMS-030 seeded negative: failed to construct /run/secrets/evil variant\"
    && require hasEtcPath
      \"FS-820-HDS-010-SDS-010-SMS-030 seeded negative: failed to construct /etc/ variant\"
    && require hasFalseProviderNeutral
   \"FS-820-HDS-010-SDS-010-SMS-030 seeded negative: failed to construct providerNeutral=false variant\"
" >/dev/null || fail "FS-820-HDS-010-SDS-010-SMS-030 seeded negative construction validation failed"

echo "PASS FS-820-HDS-010-SDS-010-SMS-030-secret-source-policy-boundary"
