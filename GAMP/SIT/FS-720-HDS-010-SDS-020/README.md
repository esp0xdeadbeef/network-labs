# FS-720-HDS-010-SDS-020 SIT

SIT row stub for the endpoint harness consumption integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently keeps these prepared SMS inputs visible:

- `FS-720-HDS-010-SDS-020-SMS-020`
- `FS-720-HDS-010-SDS-020-SMS-040`

Status: OK - construction/source-artifact evidence only. The owning NCA proof
`NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-s-router-fs720-source-harness-integration.sh`
passed at `network-codex-agent@d7f20211` with evidence under
`/tmp/hat-sat-agent-fs720-sit-source-harness-integration-high/run.Gp2DgG`.
This row is intentionally not an active-lab mini runtime selector and does not
claim HAT/SAT acceptance.
