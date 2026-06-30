#!/usr/bin/env bash
# GAMP-ID: FS-470-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-470-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-470-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: active-lab mini SMT/SIT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
wireguard_renderer_root="${NETWORK_RENDERER_WIREGUARD_ROOT:-/home/deadbeef/github/network-renderer-wireguard}"

fail() {
  echo "FAIL active-lab-mini-smt-wireguard-remote-egress: $*" >&2
  exit 1
}

[[ -d "${wireguard_renderer_root}" ]] || fail "missing network-renderer-wireguard repo at ${wireguard_renderer_root}"

result="$(
  REPO_ROOT="${repo_root}" \
  WIREGUARD_RENDERER_ROOT="${wireguard_renderer_root}" \
  nix eval --json --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  rendererRoot = builtins.getEnv "WIREGUARD_RENDERER_ROOT";
  system = builtins.currentSystem;
  renderer = builtins.getFlake ("path:" + rendererRoot);
  pkgs = import renderer.inputs.nixpkgs { inherit system; };
  lib = pkgs.lib;
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  mini = import (repoRoot + "/GAMP/SMT/mini-smt/default.nix");
  entry = manifest.tests.wireguard-remote-egress;
  lab = mini.labs."FS-470-HDS-010-SDS-010-SMS-010";
  cpm = import entry.source.cpm;
  controlPlane = cpm.control_plane_model;
  providerContract = controlPlane.providerContracts.wireguard.wg-remote-egress;
  renderResult =
    renderer.libBySystem.${system}.renderer.buildWireGuardProviderRenderResult providerContract;
  hostModule =
    renderer.libBySystem.${system}.renderer.hostModule {
      hostName = "s-router-nixos";
      controlPlane = cpm;
    };
  hostOutput = (hostModule { config = { }; inherit lib pkgs; }).content;
  container = hostOutput.containers.wireguard-remote-egress;
  evaluated = import (renderer.inputs.nixpkgs + "/nixos/lib/eval-config.nix") {
    inherit system;
    modules = [ container.config ];
  };
  cfg = evaluated.config;
in
{
  manifest = {
    inherit (entry) id traceId rendererTarget script maxRuntimeTargets;
    sourceKind = entry.source.kind;
    sourcePath = toString entry.source.cpm;
  };
  lab = {
    inherit (lab) kind traceId maxRuntimeTargets;
    runtimeTargets = builtins.attrNames lab.runtimeTargets;
    liveSurfaces = lab.liveSurfaces;
  };
  controlPlane = {
    traceId = controlPlane.meta.traceId;
    warningCodes = map (warning: warning.code) controlPlane.meta.layerEntry.warnings;
    runtimeTargets = builtins.attrNames controlPlane.data.acme.lab.runtimeTargets;
    overlayTargets = controlPlane.data.acme.lab.overlays.wg-remote-egress.terminateOn;
    wgInterface = controlPlane.wgInventory.wg-remote-egress.interface;
    providerContractId = providerContract.id;
    providerContractPrivateKey = providerContract.profile.generatedPeer.privateKeyFile;
    providerPrefixAuthority = providerContract.provider.prefixAuthority;
    providerDns = providerContract.profile.generatedPeer.dns;
  };
  render = {
    targetRenderer = renderResult.targetRenderer;
    rendererClass = renderResult.rendererClass;
    hasProviderRuntimeModule = renderResult.artifacts.nixosModules ? providerRuntime;
    capabilities = renderResult.capabilities;
  };
  hostModule = {
    containers = builtins.attrNames hostOutput.containers;
    extraFlags = container.extraFlags or [ ];
  };
  containerConfig = {
    providerRuntimeEnabled =
      cfg.services.network-renderer-wireguard.providerRuntime.enable;
    providerRuntimeContractId =
      cfg.services.network-renderer-wireguard.providerRuntime.providerContract.id;
    dispatcherDescription =
      cfg.systemd.services.wireguard-provider-dispatcher.description;
    hasNetdevService =
      cfg.systemd.services ? "s88-provider-interface-wg-re-egress0-egress";
    nftables = cfg.networking.nftables.ruleset;
    dhcp4Config =
      builtins.fromJSON cfg.environment.etc."kea/kea-dhcp4.conf".text;
    radvdConfig = cfg.environment.etc."radvd.conf".text;
  };
}
'
)"

for phrase in \
  '"id":"wireguard-remote-egress"' \
  '"traceId":"FS-470-HDS-010-SDS-010-SMS-010__mini-wireguard-remote-egress"' \
  '"sourceKind":"renderer-input"' \
  '"rendererTarget":"wireguard"' \
  '"script":"tests/test-active-lab-mini-smt-wireguard-remote-egress-only.sh"' \
  '"maxRuntimeTargets":1' \
  '"runtimeTargets":["wireguard-remote-egress"]' \
  '"liveSurfaces":["s-router-nixos"]' \
  '"providerContractId":"fs470-remote-egress"' \
  '"providerContractPrivateKey":"/run/secrets/wireguard-mini-provider-private-key"' \
  '"providerPrefixAuthority":"host-only-128"' \
  '"providerDns":["10.47.0.1"]' \
  '"targetRenderer":"wireguard-provider"' \
  '"rendererClass":"provider"' \
  '"hasProviderRuntimeModule":true' \
  '"wireguard-host-only-nat44"' \
  '"wireguard-host-only-nat66"' \
  '"containers":["wireguard-remote-egress"]' \
  '"--bind-ro=/run/secrets/wireguard-mini-provider-private-key:/run/secrets/wireguard-mini-provider-private-key"' \
  '"providerRuntimeEnabled":true' \
  '"providerRuntimeContractId":"fs470-remote-egress"' \
  '"hasNetdevService":false' \
  '"dispatcherDescription":"Bring up provider tunnel wg-re-egress0 from model/provider contract"' \
  'iifname \"edge-lan0\" oifname \"wg-re-egress0\" accept comment \"wg-provider-lan-to-vpn fs470-remote-egress\"' \
  'iifname \"edge-lan0\" oifname \"uplink0\" drop comment \"wg-provider-deny-lan-to-wan fs470-remote-egress\"' \
  'ip saddr 10.147.0.0/24 oifname \"wg-re-egress0\" masquerade comment \"wg-provider-nat44 fs470-remote-egress\"' \
  'ip6 saddr fd47:147::/64 oifname \"wg-re-egress0\" masquerade comment \"wg-provider-nat66 fs470-remote-egress\"' \
  '"subnet":"10.147.0.0/24"' \
  '"pool":"10.147.0.100 - 10.147.0.180"' \
  '"data":"10.147.0.1"' \
  'interface edge-lan0' \
  'prefix fd47:147::/64' \
  'RDNSS fd47:147::1'; do
  grep -Fq "${phrase}" <<<"${result}" || fail "missing expected phrase: ${phrase}"
done

if grep -Fq "10.47.0.1" <<<"$(grep -o '"dhcp4Config":{[^}]*}' <<<"${result}" || true)"; then
  fail "bootstrap DNS leaked into DHCP payload"
fi

echo "PASS active-lab-mini-smt-wireguard-remote-egress"
