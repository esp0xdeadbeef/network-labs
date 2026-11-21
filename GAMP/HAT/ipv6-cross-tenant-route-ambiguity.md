# BLOCKED: IPv6 cross-tenant transfer — equal-cost tenant ULA advertisements

Blocker for the HAT goal ("internet access in cobalt and neon from the client
perspective, including cross-tenant service discovery, with IPv6 working").
Owner of the fix: `network-renderer-nixos`,
`s88/ControlModule/access/lookup/advertisements/`.

## What is proven live

Fixtures booted with `nixos-shell` and driven by the site acceptance harness's
`hat-isp.py` (the harness is a private checkout; it is described here, not
named). Both sites, from the innermost tenant client:

| probe | cobalt | neon |
| --- | --- | --- |
| dns | RESOLVED | RESOLVED |
| https | 301 | 301 |
| ipv6-address | present | present |
| ipv6-site-routes | 8 | 8 |
| tang-dns (cross-tenant) | RESOLVED 10.2.90.10 | RESOLVED |
| tang (signed payload) | returned | returned |
| tang-dns6 | RESOLVED `fd42:dead:beef:290::10` | RESOLVED |
| **tang6** | **NO-PAYLOAD** | **NO-PAYLOAD** |

So internet access works from the client perspective on both sites, and
cross-tenant Tang discovery works over IPv4 and returns a real signed `adv`
payload. The IPv6 name resolves; the IPv6 transfer does not.

## Why it is blocked, not merely unfixed

Every access interface advertises every tenant ULA `/64` at the same metric
(1024), so route selection is a kernel tie-break rather than modelled intent:

```
# ip -6 route get fd42:dead:beef:290::10
fd42:dead:beef:290::10 from :: via fe80::2492:92ff:feac:a1a1 dev svc proto ra
  src fd42:dead:beef:220:b003:53ff:fe12:d6e3 metric 1024 pref medium
# ip -6 route | grep -c 290
7
```

The source address shows the packet leaving from the `svc` tenant's prefix
(`fd42:dead:beef:220::/64`), not the client's. It is non-deterministic: a
previous run of the same fixture selected `dev iot` with source
`fd42:dead:beef:250::/64`, and neon (10 candidates) selected `dev mgmt` with
source `fd42:dead:beef:310::/64`.

The correct route is `dev unlock` — the Tang host is on the unlock wire
(`GAMP/HAT/egress-chain/isp/tenant-tang.nix`) — and it loses the tie-break every
time.

This is **not** a missing route, a missing service, or a dead responder: the
IPv4 path reaches the same host and returns a valid signed payload. The defect
is that a prefix owned by one tenant is announced at equal cost on all of them.

## Why the fix is not in this commit

The correction belongs in the RA emission layer, not in a fixture or a test, and
changing what is announced per interface requires the renderer's RA regression
suite to be re-run against the new output. Applying it without that would trade
one unverified live result for another.

## To unblock

1. Scope each tenant ULA RA to the interface that owns that tenant (and/or give
   it a metric that reflects the modelled preference) in
   `network-renderer-nixos/s88/ControlModule/access/lookup/advertisements/`
   (`authoritative.nix`, `derived.nix`).
2. Re-run the renderer's RA tests.
3. Re-run `scripts/hat-isp.py client cobalt` and `... client neon`; `tang6` must
   return a signed payload on both.
