# s-router-prod: protected reservations migreren

Deze operatornotitie beschrijft de minimale migratie van lokale Kea-
reservationoverwrites naar de gepinde `network-*`-keten. Zij geeft geen
toestemming om productie te activeren. De kandidaat is alleen lokaal gebouwd
vanuit `github/.worktrees/nixos-s-router-prod-reservations/`; de canonical
`github/nixos`-repo bleef schoon en exact op `origin/main`.

## Wat verandert

Publieke inventory bevat per served scope alleen een opaque runtimebron:

```nix
reservationSource = {
  schema = "gamp-protected-reservation-set-v1";
  sourceClass = "protected";
  sourceFile = "/run/secrets/<scope>-reservations.json";
};
```

Het volledige record blijft in SOPS: private hostname, gereserveerde IPv4- en
IPv6-adressen, IPv4-MAC en de IPv6 IID, DUID en IAID. CPM draagt alleen de
bronreferentie. De NixOS- en CLAB-renderers mounten die bron read-only en
materialiseren Kea pas runtime. De inventory declareert daarnaast het normale
Kea-leasepad, waardoor een post-render leasepad-rewrite niet meer nodig is.

Lokaal samen gebouwde revisions (2026-07-18):

| Repository | Revision |
| --- | --- |
| `network-labs` | `260ad0a32e6a` |
| `network-compiler` / `nixos-network-compiler` | `688fe9e201fb` |
| `network-forwarding-model` | `1ab37e18a20c` |
| `network-control-plane-model` | `406de6f4dcda` |
| `network-renderer-nixos` | `007c8ce8abfa` |
| `network-renderer-containerlab-linux-backend` | `6f7a8671a2e4` |
| `network-renderer-access-endpoint-nixos` | `237b709048f2` |

Deze keten maakt de VLAN2/VLAN3 reservation- en Kea-leasepad-overwrites
overbodig. `FS-270-HDS-010-SDS-010-SMS-020` voegt daarnaast de begrensde
VLAN2-naar-VLAN3-policyselector en beide relation-scoped handoffs native toe.
In de lokale kandidaat bleef exact de CPM-selector met prioriteit 1000 over;
de priority-900-regel en beide host-specifieke nft-commentregels waren afwezig.
Alle vier NixOS-toplevels (`s-router-prod`, `s-router-nixos`, `s-router-clab` en
`s-router-test-clients`) bouwden met deze pins.

Dit bewijs geldt niet automatisch voor iedere compatibiliteitslaag. De
host-DHCP- en QEMU-contracten blijven staan. Ook de tijdelijke DNS-projecties
mogen pas weg wanneer de herziene
`FS-540-HDS-010-SDS-010-SMS-045`-SIT op dezelfde gepushte pins cold-staged
slaagt voor NixOS én CLAB. Een werkende productiequery vervangt die geïsoleerde
dual-stack/multi-egress-acceptatie niet.

## Identiteit opnemen en migreren

1. Maak de doelclient eerst aan op een geïsoleerde testscope.
2. Lees van dezelfde clientinterface de IPv4-MAC, een stabiele niet-tijdelijke
   IPv6 IID en, voor DHCPv6, de DUID en IAID.
3. Rebuild de client schoon en accepteer de identifiers alleen wanneer MAC,
   IID, DUID en IAID gelijk blijven. Een DUID uit een vluchtige machine-ID is
   niet geschikt.
4. Schrijf één compleet record met private hostname en gewenste adressen in
   SOPS. Zet geen recordvelden in `inventory.nix`, logs, diagnostics of de Nix
   store.
5. Lever de gedecrypte bron mode `0400`, read-only, aan de juiste access-
   runtime. Laat alleen de renderer de runtime Kea-config maken.
6. Verwijder de lokale reservation-/leasepad-overwrites pas nadat build en
   redacted runtimevergelijking slagen. Vergelijk hashes en predicaten; print
   geen protected waarden.

## Bewezen grens en staging

`FS-970-HDS-010-SDS-020-SMS-040` is live uitgevoerd via
`GAMP/SIT/FS-970-HDS-010-SDS-020` op:

- `s-router-nixos` met `reservation-probe` op lab-VLAN397;
- `s-router-clab` met `reservation-probe-clab` op lab-VLAN398; en
- `s-router-test-clients` als echte clienthost voor beide branches.

Voor de run stonden alle relevante `network-*`-wijzigingen op GitHub. Alle
drie hosts zijn daarna aantoonbaar uitgegaan en teruggekomen met nieuwe boot-
ID's, byte-identieke staged sources en exacte pins. NixOS en CLAB bewezen beide
actieve UDP 67/547-sockets, exact SOPS-naar-runtime materiaal, stabiele
MAC/DUID/IAID/IID en precies één voorspelbaar IPv4- en IPv6-adres zonder extra
globale adressen. Protected waarden bleven afwezig uit publieke bron en
buildtemplates.

De actuele pinset voegt nieuw construction-bewijs toe:

- `FS-970-HDS-010-SDS-020-SMS-040` en SIT
  `FS-970-HDS-010-SDS-020` bewaken de echte clientidentiteit en SOPS-runtimebron;
- `FS-270-HDS-010-SDS-010-SMS-020` en SIT
  `FS-270-HDS-010-SDS-010` bewaken dezelfde dual-stack policy-state-owner voor
  request en reply, zonder geleende/transitieve egress; en
- `FS-540-HDS-010-SDS-010-SMS-045` en SIT
  `FS-540-HDS-010-SDS-010` bewaken reproduceerbare DNS-selectie bij meerdere
  egresses en blijven NOT OK totdat de nieuwe cold-stage slaagt.

Voor promotie moeten de huidige GitHub-revisions eerst op alle drie hosts zijn
gestaged. Daarna: alle drie volledig uit, offline toestand vaststellen, nieuwe
boot-ID's en exacte source revisions controleren, en de rows één voor één met
echte clients uitvoeren. Een oude live run of alleen lokale compilatie is geen
stagingbewijs.

Er is niet op VLAN2, een productiesubnet of een publiek productieadres getest.
Een lokale `s-router-prod`-build bewijst alleen dat de migratiekandidaat
compileert; productieactivatie vereist afzonderlijke toestemming en de
geldende HAT/SAT-gates. Bij afwijking: niet activeren, behoud de encrypted bron
en vorige systeemgeneratie en herstel die atomair.
