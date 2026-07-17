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

Geteste revisions:

| Repository | Revision |
| --- | --- |
| `network-labs` | `e6a757284aad` |
| `network-compiler` / `nixos-network-compiler` | `f267ab67b866` |
| `network-forwarding-model` | `d1290e8606f4` |
| `network-control-plane-model` | `9e78e2ca078e` |
| `network-renderer-nixos` | `85d433856bc6` |
| `network-renderer-containerlab-linux-backend` | `3aa56a0759ea` |
| `network-renderer-access-endpoint-nixos` | `697cb43c8d17` |

Deze keten maakt uitsluitend de reservation- en Kea-leasepad-overwrites
overbodig. Zij is geen bewijs dat overige `s-router-prod`-compatibiliteitslagen
kunnen verdwijnen.

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

## Bewezen grens

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

Er is niet op VLAN2, een productiesubnet of een publiek productieadres getest.
Een lokale `s-router-prod`-build bewijst alleen dat de migratiekandidaat
compileert; productieactivatie vereist afzonderlijke toestemming en de
geldende HAT/SAT-gates. Bij afwijking: niet activeren, behoud de encrypted bron
en vorige systeemgeneratie en herstel die atomair.
