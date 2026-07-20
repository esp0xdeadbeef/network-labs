# SMT Construction Row: FS-162-HDS-010-SDS-030-SMS-010

Status: OK at the construction boundary.

`checks.<system>.openconfig-emission-negatives` proves canonical interface
mapping fails closed. The previous direct-CPM fixture is retained as the
`OC_RAW_CPM_INPUT` negative, not deleted and not accepted as current input.
All other mapping diagnostics and recoveries are tested explicitly. No live
device is claimed.
