#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REPO_ROOT="${repo_root}" nix eval --impure --expr '
  let
    repo = builtins.getEnv "REPO_ROOT";
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
    check "dual-wan" expectedDedicated
' >/dev/null

echo "PASS multi-wan-nixos-wan-group-bindings"
