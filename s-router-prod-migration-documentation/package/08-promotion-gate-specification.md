# Candidate -> Canary -> Prod Promotion-Gate Specification

Trace: FS-950-HDS-010-SDS-010-SMS-050

This is a future gate definition only. This package does not register or
start any image and does not access the canary or live production
environment. No acceptance status is asserted by this package.

Gate order (each transition requires explicit human authorization):

1. Candidate build from target pins (offline artifact only).
2. Offline artifact review of this documentation package.
3. Non-autostart s-tau canary with `autoStart=false`.
4. Explicit human approval recorded outside this package.
5. Production migration as a separately authorized maintenance operation.

The canary VM definition MUST carry `autoStart=false`; automatic start of
the canary or production image from this package is prohibited.
