# FS-470-HDS-010-SDS-010 SIT Integration

SIT integration container for FS-470-HDS-010-SDS-010 SMS-010 and sibling traces.

**Status:** NOT OK.

SMS-010 has a canonical renderer construction test:

```sh
bash tests/FS-470-HDS-010-SDS-010-SMS-010.sh
```

That command proves only the owning WireGuard renderer module. The former
direct CPM-to-renderer mini-lab source is removed. SIT remains NOT OK until a
controlled canonical-bundle scenario runs through realization, schema
validation, platform-binding validation, renderer emission, and a fresh cold
stage on the declared isolated substrates.
