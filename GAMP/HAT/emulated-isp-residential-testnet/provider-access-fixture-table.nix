# HAT source shim for Hetzner inventory compatibility.
#
# The provider-access fixture authority remains the controlled SAT source table.
# This local file exists so profile-specific HAT inventories do not depend on a
# missing sibling path when selected by HAT/SAT source-manifest checks.
import ../../SAT/provider-access-fixture-table.nix
