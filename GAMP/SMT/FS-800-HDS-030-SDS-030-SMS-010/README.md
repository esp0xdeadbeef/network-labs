# FS-800-HDS-030-SDS-030-SMS-010 SMT

Row-local source for the mini PPPoE provider/customer pairing SMT.

Run:

```bash
tests/run-active-lab-mini-smt.sh pppoe-pairing
```

This row may start only the five-node current-lab path:

- `pppoe-client`
- `downstream-selector`
- `policy`
- `upstream-selector`
- `pppoe-provider`

The row must not select full HAT/SAT or aggregate renderer POC sources.
