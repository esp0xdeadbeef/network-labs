# FS-166-HDS-010-SDS-010-SMS-900

This SMS owns six controlled replacement-CPM scenarios for NixOS, access
endpoint NixOS, Containerlab, WireGuard, and Nebula. Non-conformant direct-CPM
sources and runners are absent from the controlled tree; Git history is the
audit record.

## Executable contract

`packages.<system>.validation-scheme` shall perform this exact sequence for
each trace:

1. Load the named CPM replacement artifact and validate its envelope, identity,
   digest, trace, contract, and declared boundary.
2. Invoke the compiler, NFM, and CPM controlled-skip APIs in stage order.
3. Require each acknowledgement to match repository, locked revision, trace,
   normal input contract, replacement contract, first active boundary, prior
   stage, next stage, and unchanged replacement digest.
4. Inject the replacement exactly once at `network-realization-model`.
5. Execute realization and `network-realization-schema` validation normally.
6. Construct one normalized platform-binding bundle with one identity and the
   `interfaceIdentity`, `deployment`, `secretDelivery`, `lifecycle`, and
   `backend` categories.
7. Validate bundle identity, binding identity, target, scope, and release
   validation at the selected renderer's canonical input.
8. Emit machine-readable control-flow, artifact-flow, and evidence records.

The package exits 0 only when all predicates pass. The skipped repositories
remain `notCovered`; they are never reported as tested or passed.

## Required diagnostics

| Injection | Diagnostic | Exit | Recovery |
| --- | --- | --- | --- |
| Remove boundary, source, target, trace, or runtime cap. | `NS_MINI_MANIFEST_INCOMPLETE` naming the field. | 2 | Restore the exact manifest field and rerun. |
| Pair a source artifact with the wrong target, trace, or host class. | `NS_MINI_SOURCE_TARGET_MISMATCH` naming both identities. | 2 | Restore the declared replacement and target. |
| Send replacement CPM directly to a renderer. | `NS_REPLACEMENT_BOUNDARY_INVALID` and `NS_REALIZATION_GATE_MISSING`. | 2 before renderer execution | Inject once at realization and require schema validation. |
| Change target names or exceed the runtime cap. | `NS_RUNTIME_SCOPE_MISMATCH` naming expected and observed targets. | 2 | Restore the exact target set. |
| Mutate or omit a skip acknowledgement. | The repository-owned `NS_SKIP_*` diagnostic naming the failed field. | 2 | Reissue one acknowledgement from the locked repository API. |
| Supply raw CPM or an unvalidated/mismatched binding to a renderer. | `NR_RENDERER_BUNDLE_UNVALIDATED`, `NR_PLATFORM_BINDING_UNVALIDATED`, or the exact identity/target diagnostic. | 2 | Release the bundle and binding under the common schema and matching target. |
| Supply a raw CPM attrset without the replacement envelope. | `NS_REPLACEMENT_ARTIFACT_INVALID`. | 2 before realization | Supply a conformant `network-control-plane-artifact/v1` envelope with matching digest, trace, and boundary. |

Every negative rerun shall emit the same diagnostic and exit. Its recovery
assertion shall reuse the original network meaning and pass only after the
injected defect is removed.

This row is construction and runtime-source control. It does not claim HAT or
SAT approval.
