# FS-320-HDS-010-SDS-010-SMS-020 SMT

Row-local source stub for bridge link realization contract.

Construction-only — no active-lab mini-SMT runtime targets.
Governing SMS: CLAB renderer translates CPM link contracts with explicit bridge fields into containerlab topology links. Rejects links with missing bridge (MISSING_CPM_BRIDGE_FIELD), unknown endpoint nodes, or missing interfaces.

Construction test: network-renderer-containerlab-linux-backend/tests/test-fs320-hds010-sds010-sms020-bridge-link-realization.sh
