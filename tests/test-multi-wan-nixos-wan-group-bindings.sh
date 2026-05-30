#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${NETWORK_REPO_SWEEP:-0}" != "1" && "${NETWORK_REPO_DIRECT_TEST_OK:-0}" != "1" ]]; then
  echo "FAIL: $0 is a direct repo spot test. Set NETWORK_REPO_DIRECT_TEST_OK=1 for an intentional focused run, or NETWORK_REPO_SWEEP=1 from the locked full network-* sweep." >&2
  exit 1
fi

nix eval --impure --expr '
  let
    repo = builtins.getEnv "REPO_ROOT";
    expectedMultiWan = {
      "esp0xdeadbeef::site-a::s-router-core-isp-a" = "uplink0";
      "esp0xdeadbeef::site-a::s-router-core-isp-b" = "uplink1";
      "esp0xdeadbeef::site-b::s-router-core-isp-a" = "uplink0";
      "esp0xdeadbeef::site-b::s-router-core-isp-b" = "uplink1";
    };
    expectedDedicated = {
      "esp0xdeadbeef::site-a::s-router-core-isp-a" = "uplink0";
      "esp0xdeadbeef::site-a::s-router-core-isp-b" = "uplink1";
    };
    check = example: expected:
      let
        inventory = import (repo + "/examples/" + example + "/inventory-nixos.nix");
        host = inventory.deployment.hosts.lab-host or {};
        mapping = host.wanGroupToUplink or {};
      in
        if mapping == expected then
          true
        else
          throw "${example}: inventory-nixos.nix must explicitly map WAN groups to host uplinks";
  in
    check "multi-wan" expectedMultiWan
    && check "multi-wan-dedicated-lanes" expectedDedicated
' >/dev/null

echo "PASS multi-wan-nixos-wan-group-bindings"
