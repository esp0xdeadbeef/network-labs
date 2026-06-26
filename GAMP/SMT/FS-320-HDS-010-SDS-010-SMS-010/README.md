# FS-320-HDS-010-SDS-010-SMS-010

This row-local SMT input provides a mini topology for verifying renderer layout
preservation: logical role identity, policy boundaries, and co-location rules
must survive renderer mapping without reinterpretation.

The intent defines a two-node, one-link topology with role co-location on the
access node (two tenant attachments), exercising layout preservation per SMS
predicates MR1-MR4 and Seeded Negative SN1.

Run:

```sh
tests/run-active-lab-mini-smt.sh --source renderer-layout-preservation
tests/run-active-lab-mini-smt.sh renderer-layout-preservation
```

This is construction evidence for the SMS row only (SMT row 128, NOT OK).
Sibling SMS-020 (bridge link realization) and SMS-030 (runtime interface mapping)
have independent construction tests OK at SMT rows 129-130.

Verification scope (per SMS Construction Handoff):
1. Role co-location: access node hosts both tenant=client and tenant=mgmt;
   renderer must preserve distinct role identities and policy boundaries.
2. Compact layout: all roles on a single access node accepted without
   discarding policy decisions.
3. Target limitation: renderer emits diagnostic when layout cannot be expressed.
