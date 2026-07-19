# s-router-prod: minimale migratie naar model-owned reservations

Deze operatornotitie beschrijft de migratiekandidaat; zij geeft geen
toestemming om productie te activeren. De canonical `github/nixos`-repo bleef
schoon op `origin/main`. Alleen de toegestane worktree
`github/.worktrees/nixos-s-router-prod-reservations/` is lokaal gecompileerd.

## Doel en pinset

Vervang de lokale VLAN2/VLAN3 Kea-reservation- en leasepad-overwrites door één
opaque bron per served scope:

```nix
reservationSource = {
  schema = "gamp-protected-reservation-set-v1";
  sourceClass = "protected";
  sourceFile = "/run/secrets/<scope>-reservations.json";
};
```

De complete records blijven in SOPS: private hostname, IPv4/IPv6-reservering,
MAC, stabiele IPv6-IID en, waar DHCPv6 die gebruikt, DUID/IAID. Publieke
inventory bevat geen per-client record. De renderer mount de bron read-only en
maakt de Kea-config pas runtime.

De drie geïsoleerde cold stages gebruikten exact deze gepushte flake-pins. De
`network-labs`-pin wisselde uitsluitend om iedere row afzonderlijk als
`current-lab` te starten:

| Input | Revision |
| --- | --- |
| `network-labs` | `665bdc0e2f91` (FS-970), `c7b47da3bb63` (FS-270), `3639443eabf8` (FS-540) |
| `network-compiler-prod` | `688fe9e201fb` |
| `network-forwarding-model-prod` | `1ab37e18a20c` |
| `network-control-plane-model{,-prod}` | `406de6f4dcda` |
| `network-renderer-nixos{,-prod}` | `69a4e773880b` |
| `network-renderer-containerlab-linux-backend` | `ed56aa15d0d8` |
| `network-renderer-access-endpoint-nixos` | `237b709048f2` |
| `network-renderer-nebula` | `0e6ee9367b40` |
| `network-renderer-wireguard` | `a12d75b229ce` |

De keten levert de protected reservationbron, dual-stack Kea-materialisatie en
leasepaden native. Dezelfde pins leveren ook de symmetrische VLAN2/VLAN3-
policyhandoffs en reproduceerbare core-DNS-selectie; de hostprofiel-overwrites
zijn daardoor geen bron van waarheid meer. Nebula/WireGuard-pins zijn als
onderdeel van dezelfde totale build vastgezet, maar verlenen geen impliciete
policy- of DNS-authoriteit.

## Migratie

1. Maak eerst een client op een geïsoleerde access-scope en noteer van dezelfde
   interface de MAC, stabiele niet-tijdelijke IPv6-IID en vereiste DUID/IAID.
2. Reboot/rebuild de client en accepteer alleen identieke waarden. Veranderende
   identifiers moeten opnieuw worden enrolled; leid een IID niet stilzwijgend
   af van een MAC.
3. Schrijf één compleet record, inclusief private hostname en gewenste
   adressen, in SOPS. Print of kopieer geen recordvelden naar inventory, logs,
   diagnostics, evaluatie-output of de Nix store.
4. Lever het gedecrypte bestand mode `0400` read-only aan de juiste runtime en
   laat alleen de renderer de Kea-config maken.
5. Verwijder de lokale reservation-/leasepad-overwrites pas nadat de kandidaat
   bouwt en een redacted runtimevergelijking exact slaagt. Bij afwijking:
   fail-closed, niet activeren en de vorige generatie behouden.

## Niet-productie-bewijs

De bewijsset gebruikt uitsluitend echte clients en geïsoleerde labnetwerken:

- `FS-970-HDS-010-SDS-020-SMS-040` en SIT
  `FS-970-HDS-010-SDS-020`: SOPS→runtime, stabiele MAC/IID/DUID/IAID en exact
  voorspelbare IPv4/IPv6 op `s-router-nixos` VLAN397 en `s-router-clab` VLAN398;
- `FS-270-HDS-010-SDS-010-SMS-020` en SIT
  `FS-270-HDS-010-SDS-010`: dezelfde dual-stack policy-state-owner, stateful
  return, reverse-new deny, geen shortcut en geen geleende egress; en
- `FS-540-HDS-010-SDS-010-SMS-045` en SIT
  `FS-540-HDS-010-SDS-010`: first-attempt IPv4/IPv6 UDP/TCP DNS via één
  modelgeselecteerde core-egress, met lokaal delen, laterale `REFUSED`,
  geblokkeerde directe paden en nul reproduceerbaarheidswaarschuwingen.

Voor iedere stage stonden alle owning revisions eerst op GitHub. Daarna gingen
`s-router-nixos`, `s-router-clab` en `s-router-test-clients` tegelijk uit, zijn
alle drie offline waargenomen en kwamen zij terug met nieuwe boot-ID's,
guest-closures, exacte bronhashes/pins en nul failed units. De lokale
`s-router-prod`-kandidaat en alle drie labtoplevels bouwden met dezelfde pins.
Er is niet op productie-VLAN2, een productiesubnet of publiek productieadres
getest. Productieactivatie vereist afzonderlijke HAT/SAT- en operatorgoedkeuring.
