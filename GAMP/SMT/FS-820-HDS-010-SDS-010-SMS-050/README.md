# SMT Source: FS-820-HDS-010-SDS-010-SMS-050

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-050-network-labs-sops-configuration-validation.md`

Status: OK - focused CMC construction guard verified.

Focused evidence: `NETWORK_REPO_DIRECT_TEST_OK=1 bash
tests/FS-820-HDS-010-SDS-010-SMS-050.sh` passed on 2026-06-30. The guard rejects
network-labs `sops.defaultSopsFile` overrides, host-owned keys such as
`deadbeef-passwd`, unmodeled arbitrary host-owned keys such as `qqqqabc`, and
encrypted YAML payload ownership under `active-lab/secrets`. The accepted path
keeps lab-runtime secrets in owning HAT, SAT, SIT, or SMT row/fixture
directories with per-secret `sopsFile` references.

Title slug: `network-labs-sops-configuration-validation`
