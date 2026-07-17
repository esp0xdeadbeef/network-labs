# s-router-prod: minimale migratienotitie

Dit is een operatornotitie voor de migratie van lokale `s-router-prod`-
overwrites naar de gepinde `network-*`-keten. Het is geen activatiegoedkeuring.
De NixOS-wijziging is alleen lokaal gecompileerd vanuit
`github/.worktrees/nixos-s-router-prod-reservations/`; deze repo is niet gepusht.

## Pins en verwijderde overwrites

De gewone en `*-prod` lock-nodes moeten dezelfde keten gebruiken:

| Flake-input | Pin | Gevolg |
| --- | --- | --- |
| `network-compiler(-prod)` | `e2da177f747d` | compileert de expliciete intent zonder prod-profielinterpretatie |
| `network-forwarding-model(-prod)` | `58c6ad13d994` | bewaart delegated-prefixmetadata en leidt de public-ingress-doellane af |
| `network-control-plane-model(-prod)` | `4bf86985903b` | draagt protected reservation-bronnen, runtime prefixafleiding en tuple-scoped ingress door |
| `nixos-network-compiler(-prod)` | `e2da177f747d` | bindt dezelfde compilerketen aan de NixOS-consument |
| `network-renderer-nixos(-prod)` | `7fa1a85d1b56` | materialiseert reservations en prefixes pas runtime en rendert native DNAT/SNAT/forwarding |

Met deze samenhangende pins vervallen drie profielhacks:

- `vlan2-kea-reservations-override.nix` en
  `vlan3-kea-reservations-override.nix`;
- de lokale `s-router-prod-ipv6-routes` prefixderiver; en
- `nebula-public-ingress-hotpatch.nix`.

Dit zegt niet dat iedere overige profieloverride is opgelost. De QEMU-NIC- en
Kea-leasepadcompatibiliteit vallen buiten deze drie bewezen contracten en mogen
niet stilzwijgend worden verwijderd.

## Protected reservation migreren

1. Lees de bestaande reservation alleen binnen een mode-`0700` werkdirectory.
2. Noteer van een echte, geïsoleerde test-clientinterface:
   - voor IPv4: MAC-adres;
   - voor IPv6: stabiele IID, link-layer DUID en IAID;
   - daarnaast een opaque record-ID, private hostname, gereserveerd IPv4-adres
     en gereserveerd IPv6-adres.
3. Plaats het volledige record in SOPS. Hostname/serial, adressen en identifiers
   horen niet in publieke `inventory.nix`, buildoutput, logs of de Nix store.
4. Public inventory bevat alleen
   `reservationSource = { schema = "gamp-protected-reservation-set-v1";
   sourceClass = "protected"; sourceFile = "/run/secrets/..."; };`.
5. Lever de bron mode `0400` en read-only aan de access-runtime. Alleen de
   renderer-materializer mag hieruit de runtime Kea-config schrijven.
6. Vergelijk oud en nieuw met hashes, aantallen en gelijkheidspredicaten; print
   nooit de records. Verwijder plaintext tijdelijke bestanden.

Een willekeurige vendor-DUID is niet voorspelbaar na een rebuild. Gebruik de
werkelijk opgevraagde link-layer DUID en bewijs na een schone clientrebuild dat
MAC, DUID, IAID en IID gelijk blijven voordat het record wordt gepromoveerd.

## Bewijs en toegestane testgrens

De URS scheidt controlled-lab bewijs van productie-input. Deze migratie is
daarom getest op de rij-eigen test-VLAN `397` en documentatieprefixen, nooit op
VLAN2, een prod-subnet of een publiek productieadres.

| Contract | Context en actuele status |
| --- | --- |
| `FS-970-HDS-010-SDS-020-SMS-040` | `OK`: `s-router-nixos` leverde SOPS read-only aan Kea en `s-router-test-clients/reservation-probe` kreeg na rebuild exact voorspelbare IPv4/IPv6; MAC, DUID, IAID en IID bleven stabiel. `s-router-clab` is geen NixOS-Kea-bewijscontext voor deze rij. |
| `FS-350-HDS-010-SDS-010-SMS-060` | `OK` construction/local-candidate bewijs: complete `/48` -> slot-`/64` metadata, runtime afleiding en geen lokale route-override. Geen productieactivatie. |
| `FS-310-HDS-020-SDS-010-SMS-075` | `OK` construction/local-candidate bewijs: native TCP/UDP ingress, exacte per-hop route/forwarding en zeven syntaxgeldige rulesets. Geen publieke live probe. |
| `GAMP/SIT/FS-970-HDS-010-SDS-020` | `NOT OK`: nog source-stub; de praktische SMS-run promoveert de SDS-brede SIT niet. |
| `GAMP/SIT/FS-350-HDS-010-SDS-010` | Integratiegap: SMS-060 is nog niet als geïntegreerde SIT-input gesloten. |
| `GAMP/SIT/FS-310-HDS-020-SDS-010` | Integratiegap: SMS-075 is nog niet met een controlled-lab SIT-run gesloten. |

## Uitvoering en rollback

Pin eerst de hele keten, evalueer daarna zonder overrides en bouw de volledige
lokale kandidaat. Controleer redaction, SOPS-mounts, Kea-parser, afgeleide
routes en `nft --check`. Activeer pas na afzonderlijke toestemming en gesloten
SIT/HAT-gates. Bij enige afwijking: niet activeren; behoud het vorige systeem,
de encrypted bronnen en Kea-state en herstel die atomair.
