# SIT Runtime Evidence: FS-080-HDS-010-SDS-010

Status: OK - active-lab SMT/SIT runtime evidence recorded.

The full-loop active-lab run on 2026-07-04 selected
`FS-080-HDS-010-SDS-010-SMS-010` and verified the locked runtime artifacts on
`s-router-nixos`, `s-router-clab`, and `s-router-test-clients`. Router hosts
had five bounded runtime targets and no required-fact violation, downstream
repair, or unknown source-class records. Test-clients exposed the trace with
zero router runtime targets. This is SIT integration evidence for the active
lab only; it does not promote HAT/SAT.
