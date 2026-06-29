# FS-540-HDS-010-SDS-010 SIT

SIT row stub for the mini DNS resolver config integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-540-HDS-010-SDS-010-SMS-020`

Run the small row input independently:

```sh
tests/run-active-lab-mini-smt.sh dns-resolver-config
```

Run the live recursive DNS SIT probe against the active lab:

```sh
S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab \
  tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh
```

The live probe must verify resolver-source artifacts, local recursive resolver
state, bounded DNS recursion from NixOS and CLAB runtime targets, and absence
of Docker/host public resolver fallback on the CLAB core recursive path.
