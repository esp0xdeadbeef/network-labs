{
  description = "Network lab examples";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    network-labs-source = {
      url = "github:esp0xdeadbeef/network-labs";
      flake = false;
    };

    network-compiler.url = "github:esp0xdeadbeef/network-compiler";
    network-compiler.inputs.nixpkgs.follows = "nixpkgs";
    network-compiler.inputs.network-labs.follows = "network-labs-source";

    network-forwarding-model.url = "github:esp0xdeadbeef/network-forwarding-model";
    network-forwarding-model.inputs.nixpkgs.follows = "nixpkgs";
    network-forwarding-model.inputs.network-compiler.follows = "network-compiler";
    network-forwarding-model.inputs.network-labs.follows = "network-labs-source";

    network-control-plane-model.url = "github:esp0xdeadbeef/network-control-plane-model";
    network-control-plane-model.inputs.nixpkgs.follows = "nixpkgs";
    network-control-plane-model.inputs.network-forwarding-model.follows = "network-forwarding-model";
    network-control-plane-model.inputs.network-labs.follows = "network-labs-source";

    network-realization-schema.url = "github:esp0xdeadbeef/network-realization-schema";
    network-realization-schema.inputs.nixpkgs.follows = "nixpkgs";

    network-realization-model.url = "github:esp0xdeadbeef/network-realization-model";
    network-realization-model.inputs.nixpkgs.follows = "nixpkgs";
    network-realization-model.inputs.network-realization-schema.follows = "network-realization-schema";

    network-renderer-nixos.url = "github:esp0xdeadbeef/network-renderer-nixos";
    network-renderer-nixos.inputs.nixpkgs.follows = "nixpkgs";
    network-renderer-nixos.inputs.network-realization-model.follows = "network-realization-model";
    network-renderer-nixos.inputs.network-control-plane-model.follows = "network-control-plane-model";
    network-renderer-nixos.inputs.network-forwarding-model.follows = "network-forwarding-model";
    network-renderer-nixos.inputs.network-labs.follows = "network-labs-source";

    network-renderer-containerlab-linux-backend.url = "github:esp0xdeadbeef/network-renderer-containerlab-linux-backend";
    network-renderer-containerlab-linux-backend.inputs.nixpkgs.follows = "nixpkgs";
    network-renderer-containerlab-linux-backend.inputs.network-realization-model.follows = "network-realization-model";
    network-renderer-containerlab-linux-backend.inputs.network-compiler.follows = "network-compiler";
    network-renderer-containerlab-linux-backend.inputs.network-forwarding-model.follows = "network-forwarding-model";
    network-renderer-containerlab-linux-backend.inputs.network-control-plane-model.follows = "network-control-plane-model";
    network-renderer-containerlab-linux-backend.inputs.network-labs.follows = "network-labs-source";

    network-renderer-access-endpoint-nixos.url = "github:esp0xdeadbeef/network-renderer-access-endpoint-nixos";
    network-renderer-access-endpoint-nixos.inputs.nixpkgs.follows = "nixpkgs";
    network-renderer-access-endpoint-nixos.inputs.network-realization-model.follows = "network-realization-model";
    network-renderer-access-endpoint-nixos.inputs.network-control-plane-model.follows = "network-control-plane-model";
    network-renderer-access-endpoint-nixos.inputs.network-labs.follows = "network-labs-source";

    network-renderer-wireguard.url = "github:esp0xdeadbeef/network-renderer-wireguard";
    network-renderer-wireguard.inputs.nixpkgs.follows = "nixpkgs";
    network-renderer-wireguard.inputs.network-realization-model.follows = "network-realization-model";
    network-renderer-wireguard.inputs.network-control-plane-model.follows = "network-control-plane-model";

    network-renderer-nebula.url = "github:esp0xdeadbeef/network-renderer-nebula";
    network-renderer-nebula.inputs.nixpkgs.follows = "nixpkgs";
    network-renderer-nebula.inputs.network-realization-model.follows = "network-realization-model";
    network-renderer-nebula.inputs.network-control-plane-model.follows = "network-control-plane-model";
    network-renderer-nebula.inputs.network-labs.follows = "network-labs-source";

    network-renderer-openconfig.url = "github:esp0xdeadbeef/network-renderer-openconfig";
    network-renderer-openconfig.inputs.nixpkgs.follows = "nixpkgs";
    network-renderer-openconfig.inputs.network-realization-model.follows = "network-realization-model";
    network-renderer-openconfig.inputs.network-realization-schema.follows = "network-realization-schema";
    network-renderer-openconfig.inputs.network-control-plane-model.follows = "network-control-plane-model";
    network-renderer-openconfig.inputs.network-labs.follows = "network-labs-source";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      lib = builtins;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      examplesDir = ./examples;

      entries = lib.readDir examplesDir;

      isExampleDir = name: entries.${name} == "directory";

      exampleNames = lib.filter isExampleDir (lib.attrNames entries);

      mkLab =
        name:
        let
          base = examplesDir + "/${name}";
        in
        {
          path = base;
          intent = base + "/intent.nix";
          inventory =
            if lib.pathExists (base + "/inventory-nixos.nix") then
              base + "/inventory-nixos.nix"
            else if lib.pathExists (base + "/inventory.nix") then
              base + "/inventory.nix"
            else
              null;
        };

      labs = lib.listToAttrs (
        map (name: {
          name = name;
          value = mkLab name;
        }) exampleNames
      );

      rootLockIdentity = builtins.hashString "sha256" (builtins.readFile ./flake.lock);
      networkLabsRevision = self.rev or self.dirtyRev or "uncommitted";
      validationSchemes = forAllSystems (
        system:
        import ./lib/validation-scheme.nix {
          inherit
            inputs
            system
            rootLockIdentity
            networkLabsRevision
            ;
        }
      );

    in
    {
      inherit labs;

      lib.validationScheme = validationSchemes.x86_64-linux;
      libBySystem = forAllSystems (system: {
        validationScheme = validationSchemes.${system};
      });

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          scheme = validationSchemes.${system};
          result = pkgs.writeText "network-validation-scheme-results.json" (
            builtins.toJSON {
              schemaRevision = "network-validation-scheme/v1";
              inherit rootLockIdentity;
              scenarioNames = builtins.attrNames scheme.scenarios;
              inherit (scheme) scenarios;
              flowBoundaryCaseNames = builtins.attrNames scheme.flowBoundaryCases;
              flowBoundaryCases = nixpkgs.lib.mapAttrs (_: scheme.validateFlowManifest) scheme.flowBoundaryCases;
              seededNegativeCaseNames = builtins.attrNames scheme.seededNegativeCases;
              inherit (scheme) seededNegativeCases;
              fs230PeerComparison = builtins.removeAttrs scheme.fs230PeerComparison [
                "bundle"
                "bindings"
              ];
              fs540PeerComparison = builtins.removeAttrs scheme.fs540PeerComparison [
                "bundle"
                "bindings"
              ];
              inherit (scheme) rendererBoundaryConformance;
            }
          );
          fs230Bundle = pkgs.writeText "fs230-canonical-bundle.json" (
            builtins.toJSON scheme.fs230PeerComparison.bundle
          );
          fs230Bindings = nixpkgs.lib.mapAttrs (
            target: binding: pkgs.writeText "fs230-${target}-platform-binding.json" (builtins.toJSON binding)
          ) scheme.fs230PeerComparison.bindings;
          validationScheme = pkgs.writeShellApplication {
            name = "network-validation-scheme";
            runtimeInputs = [ pkgs.jq ];
            text = ''
              set -euo pipefail
              results=${result}
              case "''${1:---all}" in
                --all)
                  cat "$results"
                  ;;
                --list)
                  jq -r '.scenarioNames[]' "$results"
                  ;;
                --scenario)
                  test "$#" -eq 2 || {
                    echo "usage: network-validation-scheme --scenario TRACE_ID" >&2
                    exit 2
                  }
                  jq -e --arg traceId "$2" \
                    '.scenarios[$traceId] // error("unknown controlled scenario: " + $traceId)' \
                    "$results"
                  ;;
                --negative-case)
                  test "$#" -eq 2 || {
                    echo "usage: network-validation-scheme --negative-case CASE_ID" >&2
                    exit 2
                  }
                  case_result="$(jq -c --arg caseId "$2" \
                    '.seededNegativeCases[$caseId] // empty' "$results")"
                  test -n "$case_result" || {
                    echo "unknown seeded negative case: $2" >&2
                    exit 2
                  }
                  jq -c '.result.diagnostic' <<<"$case_result" >&2
                  exit "$(jq -r '.expectedExit' <<<"$case_result")"
                  ;;
                --recover-case)
                  test "$#" -eq 2 || {
                    echo "usage: network-validation-scheme --recover-case CASE_ID" >&2
                    exit 2
                  }
                  jq -e --arg caseId "$2" '
                    .seededNegativeCases[$caseId].recovery
                    | select(.accepted == true and .exit == 0 and .diagnostic == null)
                  ' "$results"
                  ;;
                *)
                  echo "usage: network-validation-scheme {--all|--list|--scenario TRACE_ID|--negative-case CASE_ID|--recover-case CASE_ID}" >&2
                  exit 2
                  ;;
              esac
            '';
          };
        in
        {
          inherit validationScheme;
          validation-scheme = validationScheme;
          validation-scheme-results = result;
          fs230-canonical-bundle = fs230Bundle;
          fs230-openconfig-platform-binding = fs230Bindings.openconfig;
          default = validationScheme;
        }
      );

      apps = forAllSystems (system: {
        validation-scheme = {
          type = "app";
          program = "${self.packages.${system}.validation-scheme}/bin/network-validation-scheme";
        };
        default = self.apps.${system}.validation-scheme;
      });

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          controlled-validation-scheme =
            pkgs.runCommand "controlled-validation-scheme"
              {
                nativeBuildInputs = [ pkgs.jq ];
              }
              ''
                results=${self.packages.${system}.validation-scheme-results}
                jq -e '
                  (.scenarioNames | length) == 6
                  and (.flowBoundaryCaseNames == [
                    "compiler-input",
                    "cpm-input",
                    "nfm-input",
                    "realization-input"
                  ])
                  and all(.flowBoundaryCases[];
                    .accepted == true
                    and .exit == 0
                    and .diagnostic == null
                  )
                  and all(.scenarios[];
                    .evidence.status == "construction-ok"
                    and (.controlFlow.skippedAcknowledgements | length) == 3
                    and ([.controlFlow.skippedAcknowledgements[].repository] == [
                      "network-compiler",
                      "network-forwarding-model",
                      "network-control-plane-model"
                    ])
                    and .artifactFlow.injection.boundary == "network-realization-model"
                    and .artifactFlow.realization.bundleIdentity == .artifactFlow.renderer.bundleIdentity
                    and .artifactFlow.platformBinding.bindingIdentity == .artifactFlow.renderer.bindingIdentity
                    and (.artifactFlow.platformBinding.categoryNames == [
                      "backend",
                      "deployment",
                      "interfaceIdentity",
                      "lifecycle",
                      "secretDelivery"
                    ])
                  )
                ' "$results" >/dev/null
                mkdir -p "$out"
                cp "$results" "$out/results.json"
              '';

          controlled-validation-negatives =
            pkgs.runCommand "controlled-validation-negatives"
              {
                nativeBuildInputs = [
                  self.packages.${system}.validation-scheme
                  pkgs.diffutils
                  pkgs.jq
                ];
              }
              ''
                while IFS= read -r case_id; do
                  if network-validation-scheme --negative-case "$case_id" \
                    >"$case_id.stdout" 2>"$case_id.stderr"; then
                    echo "$case_id unexpectedly succeeded" >&2
                    exit 1
                  else
                    observed_exit="$?"
                  fi
                  test "$observed_exit" -eq 2
                  test ! -s "$case_id.stdout"
                  expected_code="$(jq -r --arg caseId "$case_id" \
                    '.seededNegativeCases[$caseId].expectedDiagnostic' \
                    ${self.packages.${system}.validation-scheme-results})"
                  jq -e --arg code "$expected_code" '.code == $code' \
                    "$case_id.stderr" >/dev/null

                  if network-validation-scheme --negative-case "$case_id" \
                    >"$case_id.rerun.stdout" 2>"$case_id.rerun.stderr"; then
                    exit 1
                  else
                    rerun_exit="$?"
                  fi
                  test "$rerun_exit" -eq 2
                  test ! -s "$case_id.rerun.stdout"
                  cmp "$case_id.stderr" "$case_id.rerun.stderr"
                  network-validation-scheme --recover-case "$case_id" \
                    >"$case_id.recovery.json"
                done < <(jq -r '.seededNegativeCaseNames[]' \
                  ${self.packages.${system}.validation-scheme-results})

                jq -e '
                  .code == "NS_REPLACEMENT_BOUNDARY_INVALID"
                  and .relatedDiagnostics == ["NS_REALIZATION_GATE_MISSING"]
                ' NS-MINI-N3.stderr >/dev/null

                mkdir -p "$out"
                cp ./*.json ./*.stderr "$out/"
              '';

          openconfig-peer-posture =
            pkgs.runCommand "openconfig-peer-posture"
              {
                nativeBuildInputs = [
                  inputs.network-renderer-openconfig.packages.${system}.fs230-posture
                  pkgs.diffutils
                  pkgs.jq
                ];
              }
              ''
                bundle=${self.packages.${system}.fs230-canonical-bundle}
                intent=${./GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix}
                expected_identity="$(jq -r .bundleIdentity "$bundle")"

                for peer in nixos clab openconfig; do
                  fs230-posture "$bundle" \
                    --realization "$peer" \
                    --canonical-intent "$intent" \
                    --compiler-revision ${inputs.network-compiler.rev} \
                    --cpm-revision ${inputs.network-control-plane-model.rev} \
                    --network-labs-revision ${networkLabsRevision} \
                    --expected-bundle-identity "$expected_identity" \
                    >"$peer.json"
                  jq -e '
                    .code == "OC_FS230_POSTURE_PASS"
                    and .status == "OK"
                    and .canonicalPortable == true
                    and .openConfigModelComplete == false
                    and .networkAccess == false
                  ' "$peer.json" >/dev/null
                  jq -S .posture "$peer.json" >"$peer.posture.json"
                done

                diff -u nixos.posture.json clab.posture.json
                diff -u nixos.posture.json openconfig.posture.json
                mkdir -p "$out"
                cp ./*.json "$out/"
              '';

          openconfig-instance-emission =
            inputs.network-renderer-openconfig.checks.${system}.canonical-interface-emission;
          openconfig-emission-negatives =
            inputs.network-renderer-openconfig.checks.${system}.canonical-interface-negatives;
          openconfig-yang-validation =
            inputs.network-renderer-openconfig.checks.${system}.yang-validation-contract;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
