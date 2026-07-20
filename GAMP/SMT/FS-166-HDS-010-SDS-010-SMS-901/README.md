# SMT Construction Row: FS-166-HDS-010-SDS-010-SMS-901

Status: NOT OK overall. Construction is OK; fresh cold-stage runtime evidence
is not yet recorded.

`replacement-artifacts/nixos-single.nix` is a conformant CPM replacement
artifact for exactly `poc-router`. It contains network meaning only. The
validation scheme supplies deployment and backend mechanics through one
validated NixOS platform-binding bundle, records compiler, NFM, and CPM skip
acknowledgements, injects the artifact once at the realization-model input,
validates the canonical bundle, and invokes the NixOS canonical adapter.

```bash
bash tests/FS-166-HDS-010-SDS-010-SMS-901.sh
```

No direct-CPM runner or legacy source is part of this row. A fresh cold stage
on the declared real substrates is required before live status can become OK.
