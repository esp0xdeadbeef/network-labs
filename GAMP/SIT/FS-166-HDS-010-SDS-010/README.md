# FS-166-HDS-010-SDS-010 SIT

Status: NOT OK.

The six child SMS rows pass their construction boundary through the
deterministic validation scheme:

```bash
for trace in FS-166-HDS-010-SDS-010-SMS-{901,902,903,904,905,906}; do
  bash "tests/${trace}.sh"
done
```

Each scenario uses a row-derived replacement artifact, repository-owned skip
acknowledgements, realization, schema validation, one normalized
platform-binding bundle, and a canonical renderer adapter. Direct
CPM-to-renderer fixtures and their live runners are absent.

SIT remains NOT OK until the exact pushed revisions are cold-staged on the
declared isolated substrates and the rendered runtime is compared with the
canonical bundle and binding identities. This row does not authorize VLAN2,
production, HAT, or SAT testing.
