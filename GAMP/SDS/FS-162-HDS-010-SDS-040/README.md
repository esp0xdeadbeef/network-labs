# SDS Construction Grouping: FS-162-HDS-010-SDS-040

Status: OK - child construction proof passed at
`network-renderer-openconfig@9cff098bc2b9`.

This row groups the OpenConfig comparable-projection construction input. The
child SMS must compile the same canonical isolated FS-230 intent with the same
compiler/CPM pins used by the NixOS and CLAB construction paths, pass the
OpenConfig realization's CPM directly to OpenConfig, and prove an identical
normalized ingress/no-egress posture without using peer output as semantic
input. Realization-specific CPM hashes may differ. No live OpenConfig device or
production network is in scope.

Complete OpenConfig instance-model coverage remains a separately reported
limitation. This grouping closes only the portable CPM posture predicate.
