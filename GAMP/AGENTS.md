# AGENTS.md: GAMP lab-source and validation rules

This directory carries controlled GAMP lab sources and validation preparation
for `network-labs`. Keep changes narrow, source-backed, and testable.

## Scope

- `../examples/` contains examples. Normalize those examples only when the
  task explicitly targets examples.
- `SAT/` is the controlled SAT source, not an example.
- `HAT/` contains host-acceptance preparation fixtures, not SAT evidence.
- `sat/` and `HAT/` paths at the repository root are legacy locations in this
  checkout. Do not reintroduce references to those paths when editing files
  under `GAMP/`.
- Validation indexes live in `../tests/SMT.md`, `../tests/SIT.md`,
  `../tests/HAT.md`, and `../tests/SAT.md`.

Before editing, inspect the live tree instead of trusting stale counts:

```bash
find ../examples -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
```

## Example Normalization Rules

Every example under `../examples/` must be understandable and copyable as a
standalone fixture with these files:

```text
examples/<case>/
|-- intent.nix
|-- inventory-clab.nix
`-- inventory-nixos.nix
```

Do not leave thin wrappers or imports to:

- another example directory;
- `_shared-inventory-clab.nix`;
- `inventory-base.nix`, `inventory-static.nix`, or `inventory.nix`;
- local helper directories such as `inventory-parts/` or `profiles/`;
- per-folder reference files used only to assemble the final files.

Preserve existing coverage while normalizing:

- single-WAN;
- dual-WAN or multi-WAN;
- BGP;
- VLAN trunking;
- overlays;
- dedicated transit lanes;
- renderer-specific inventory coverage.

Keep renderer-specific differences in full `inventory-clab.nix` and
`inventory-nixos.nix` files. Keep core WAN-side routing behavior explicit in
the fixture data; do not hide it behind normalization helpers, inferred
defaults, or generated JSON payloads.

Generated examples must remain readable Nix attrsets. Do not use
`builtins.fromJSON` to compress examples or lab files.

## Routing Mode Rules

BGP/static selection must be granular per relevant P2P link or uplink. Do not
model routing style as one global example-wide switch.

Required behavior:

- one P2P link may use BGP;
- another P2P link in the same example may use static routing;
- mixed static/BGP cases must stay representable;
- core WAN-side routes stay hardcoded or explicit where the topology requires
  them.

## Validation Layer Rules

SMT, SIT, HAT, and SAT are distinct validation layers. A check may support a
later layer, but it must not claim that later layer passed without that layer's
own evidence.

- SMT: module or construction checks. Examples-only SMT may inspect examples
  and distributed `network-*` module outputs, but it is not live acceptance.
- SIT: integrated artifact checks. SIT may prove a locked source/artifact chain
  is internally coherent, but it is not live hardware or site acceptance.
- HAT: host-acceptance execution on the owning host or harness. HAT fixture
  source checks are preparation only until the harness starts the substrate and
  records bounded runtime probes.
- SAT: controlled acceptance against the locked SAT source and runtime evidence.
  SAT may cite SMT, SIT, and HAT inputs, but those inputs never become SAT by
  naming alone.

Stub validation files are allowed only as placeholders that keep missing work
visible. A stub must say what evidence is missing and must not mark a row `OK`.

## Live Testing Rule

Live-test every GAMP rule that can be live-tested. Use the smallest practical
setup that exercises the rule, and record the command, source path, artifact or
host context, and observed result.

For on-prem hosts, everything except Hetzner-hosted surfaces must have
`eth0.2` configured for DHCP on the host before the live run. Without that,
the host may be offline and the validation result is not meaningful.

Do not promote source, parser, renderer, or fixture checks to live evidence.
When live testing is impossible in the current turn, leave the row or stub
blocked with the exact missing harness, host, or command.

## Focused Test Commands

Run the focused checks that match the edit:

```bash
bash ../tests/test-smt-traceability-docs.sh
bash ../tests/test-hat-traceability-docs.sh
bash ../tests/test-sit-traceability-docs.sh
bash ../tests/test-sat-traceability-docs.sh
```

For a broader local sweep from the repository root:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test.sh
```

Only run live HAT/SAT harnesses when the host prerequisites are satisfied and
the target harness is the owning runtime surface.

## Commit Message

Use this commit message for the example-normalization task:

```text
Normalize examples into standalone intent and inventory files
```
