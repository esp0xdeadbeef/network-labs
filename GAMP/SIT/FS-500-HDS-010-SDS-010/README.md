# FS-500-HDS-010-SDS-010 SIT

SIT row stub for the mini reachability decision and point-to-point next-hop
integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-500-HDS-010-SDS-010-SMS-010`
- `FS-500-HDS-010-SDS-010-SMS-040`

Run the small row inputs independently:

```sh
tests/run-active-lab-mini-smt.sh reachability-decision p2p-next-hop
```
