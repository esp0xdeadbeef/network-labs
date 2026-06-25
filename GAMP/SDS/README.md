# GAMP SDS Input Templates

This directory maps active-lab mini inputs to SDS-scoped template rows.

Each row directory uses the SDS trace id only:

```text
GAMP/SDS/FS-XXX-HDS-XXX-SDS-XXX/
```

The row `default.nix` must declare the SMS input rows it owns. Concrete source
files stay in the SMS row directories or in the existing mini-SMT renderer input
fixtures; the SDS row records the deterministic grouping so agents can select a
small proof surface without using the full active-lab, HAT, or SAT path.
