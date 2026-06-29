# Current Lab Selection

`current-lab/` is the network-labs-owned mutable selection used by
`active-lab/`. The nixos repository keeps importing `active-lab/`; tests and
operators select SAT, HAT, SIT, or SMT sources by overwriting these files with
`scripts/select-current-lab.sh`.

Host-specific files such as
`intent-s-router-nixos.nix`, `inventory-s-router-clab.nix`, and
`clients-s-router-test-clients.nix` are selector-written aliases for NixOS
runtime modules that bind each VM to its selected active-lab source.

Do not edit nixos source to select a lab. Select here, then build nixos with:

```bash
nix build --dry-run --no-write-lock-file --override-input network-labs path:/home/deadbeef/github/network-labs <nixos-flake-attr>
```
