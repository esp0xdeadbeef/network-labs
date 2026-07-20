# SMT Candidate: FS-560-HDS-010-SDS-010-SMS-050

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-560-HDS-010-SDS-010-SMS-050-protected-reservation-name-materialization.md`

Status: NOT OK - construction and isolated live-source wiring are green; the
required cold stage has not yet run.

The focused cross-repo construction test proves that CPM derives the protected
source kind/family, both renderers materialize the same owner-scoped
A/AAAA/PTR source, and the namespace is local-authoritative. It also rejects
wildcard ownership and overlapping transparent/forwarding authority without
printing protected values.

The row now uses the same already-enrolled encrypted lab records as the
FS-970 reservation proof, under row-owned runtime paths. It selects dedicated
VLAN399 and VLAN400 paths for NixOS and CLAB. The existing isolated FS-970
test-network egress remains unchanged; `namePublication` adds no egress or
recursion authority. This is valid lab configuration, not a pipeline defect.

This remains not SIT or live-stage evidence. Closure requires a fresh cold
stage on `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`, with
known A/AAAA/PTR answers and an unknown local-name query proving zero upstream
fallback on both substrates.

Focused test:

```sh
NETWORK_REPO_DIRECT_TEST_OK=1 \
  tests/FS-560-HDS-010-SDS-010-SMS-050-native-protected-name-publication.sh
```

Cold-stage SIT verifier (after recording pre-stage boot IDs, guest closures,
source hashes and pushed revisions):

```sh
network-codex-agent/tests/test-sit-FS-560-HDS-010-SDS-010-protected-name-publication-live.sh
```

Its row-local runtime predicate executes both of these substrate probes:

```sh
FS560_RUN_LIVE=1 FS560_ROUTER_SUBSTRATE=nixos \
  network-codex-agent/scripts/smt-live-FS-560-HDS-010-SDS-010-SMS-050.sh
FS560_RUN_LIVE=1 FS560_ROUTER_SUBSTRATE=clab \
  network-codex-agent/scripts/smt-live-FS-560-HDS-010-SDS-010-SMS-050.sh
```

Title slug: `protected-reservation-name-materialization`
