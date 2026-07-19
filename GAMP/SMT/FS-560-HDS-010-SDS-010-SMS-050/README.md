# SMT Candidate: FS-560-HDS-010-SDS-010-SMS-050

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-560-HDS-010-SDS-010-SMS-050-protected-reservation-name-materialization.md`

Status: NOT OK - construction candidate only.

The focused cross-repo construction test proves that CPM derives the protected
source kind/family, both renderers materialize the same owner-scoped
A/AAAA/PTR source, and the namespace is local-authoritative. It also rejects
wildcard ownership and overlapping transparent/forwarding authority without
printing protected values.

This is not SIT or live-stage evidence. Closure still requires a fresh cold
stage on `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`, with an
unknown local-name query proving zero upstream fallback.

Focused test:

```sh
NETWORK_REPO_DIRECT_TEST_OK=1 \
  tests/FS-560-HDS-010-SDS-010-SMS-050-native-protected-name-publication.sh
```

Title slug: `protected-reservation-name-materialization`
