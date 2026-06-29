# FS-800-HDS-010-SDS-020 SIT

Status: NOT OK - focused source structure passes, but live active-lab
provider-handoff default-route behavior is not PPPoE-backed.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-800-HDS-010-SDS-020-SMS-040`

Run the row-local source structure check:

```sh
bash tests/FS-800-HDS-010-SDS-020-SMS-040-provider-access-default-route.sh
```

Run the live provider-handoff default-route SIT against the active lab:

```sh
S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 \
  bash tests/FS-800-HDS-010-SDS-020-SIT-live-provider-access-default-route.sh
```

Live row evidence on 2026-06-29:

- `ppp0` is up on the provider-handoff runtime containers.
- The PPP session address is present on `ppp0`.
- Public route selection from the PPP session address still uses the fabric
  `ens*` route via the local fabric next hop instead of the PPP interface.
- Observed failures:
  - `nixos-provider-handoff-access-a`: `203.0.113.5`, default and
    `ip route get 1.1.1.1 from 203.0.113.5` use `ens21 via 10.10.44.50`.
  - `nixos-provider-handoff-access-b`: `203.0.113.1`, default and
    `ip route get 1.1.1.1 from 203.0.113.1` use `ens21 via 10.10.44.52`.
  - `clab-provider-handoff-access-a`: `203.0.113.5`, default and
    `ip route get 1.1.1.1 from 203.0.113.5` use `ens21 via 10.50.44.50`.
  - `clab-provider-handoff-access-b`: `203.0.113.1`, default and
    `ip route get 1.1.1.1 from 203.0.113.1` use `ens21 via 10.50.44.52`.

That means the existing source-only SMT is not enough for this behavior. The
SIT must stay NOT OK until the live route probe uses the PPP session interface
for provider-access default egress.
