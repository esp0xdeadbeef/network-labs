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
  namePublication = {
    namespace = "<scope>.lan.";
    ownerScope = "<scope>";
    requesterScopes = [ "<scope>" ];
    recordClasses = [ "A" "AAAA" "PTR" ];
    fallbackBehavior = "local-only";
    publicationDenialDiagnostic =
      "diagnostic.protected-reservation-name-publication-denied";
    source = "protected-reservation-set";
    sourceFamily = "ipv4";
  };
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
| `network-labs` | `665bdc0e2f91` (FS-970), `c7b47da3bb63` (FS-270), `720f3958c3b3` (FS-540) |
| `network-compiler-prod` | `688fe9e201fb` |
| `network-forwarding-model-prod` | `1ab37e18a20c` |
| `network-control-plane-model{,-prod}` | `406de6f4dcda` |
| `network-renderer-nixos{,-prod}` | `69a4e773880b` |
| `network-renderer-containerlab-linux-backend` | `ed56aa15d0d8` |
| `network-renderer-access-endpoint-nixos` | `237b709048f2` |
| `network-renderer-nebula` | `0e6ee9367b40` |
| `network-renderer-wireguard` | `a12d75b229ce` |

Die tabel is historische stage-evidence en wordt niet stilzwijgend herschreven.
De daaropvolgende native FS-560-implementatiekandidaat staat gepusht als CPM
`56eaa3119f4c`, NixOS-renderer `c4be339150dc` en CLAB-renderer
`59bc38e9fbd7`. Zij telt pas als nieuwe stage nadat de consumerpins zijn
bijgewerkt en dezelfde cold-stageprocedure opnieuw is geslaagd.

De native FS-800-implementatiekandidaat staat gepusht als CPM
`cb67a88234b1`, NixOS-renderer `108966e` en CLAB-renderer `f3b67ef`. De
PPPoE-interface, IAID en PD-request-ID blijven expliciete site-input; de
IPv6-default, DHCPv6-PD-client, ordering en reply-firewall worden door die
native keten gemaakt. Ook deze kandidaat is nog geen live stagebewijs.

De native FS-230-implementatiekandidaat staat gepusht als CPM
`4a28239803ec`, NixOS-renderer `e665b9475b7e` en CLAB-renderer
`1ebfa486465c`. De intent bezit alleen de IPv6 UDP/4242-allow, service,
stateful return en no-translation-authority. Inventory bezit de ene provider-
uplink, de ene service-endpointbinding en de protected runtime-prefixbron. De
CPM-uitkomst en beide rendererconstructies zijn groen; consumerpin en cold
stage zijn nog geen live bewijs.

De gestagede keten levert de protected reservationbron, dual-stack
Kea-materialisatie en leasepaden native. Dezelfde pins leveren ook de
symmetrische VLAN2/VLAN3-policyhandoffs en reproduceerbare
core-DNS-selectie. De oude Kea-overwrites zijn daardoor geen bron van waarheid
meer. De lokale protected-reservation-DNS-projectie kan pas weg op de nieuwe
FS-560-pins; andere DNS-, hostmanagement- en IPv6-compatibiliteit blijft
afzonderlijk geclassificeerd en mag niet onder deze reservationmigratie worden
meeverwijderd. Nebula/WireGuard-pins verlenen geen impliciete policy- of
DNS-authoriteit.

De brede lokale `nix flake check --all-systems` gebruikte daarnaast in de
toegestane NixOS-worktree het host-specifieke
`active-lab/intent-s-router-hetz.nix`-entrypoint. Canonical NixOS bleef schoon;
die consumerregel moet dus upstream beschikbaar zijn voordat deze kandidaat
buiten de lokale compilatieboundary wordt gebruikt.

## Configuratiefeit of pipeline-gap

Niet ieder concreet gegeven in `intent.nix` of `inventory.nix` is een fout. De
intent bepaalt welke verbinding of dienst is toegestaan; inventory levert de
site- en hostgebonden realization-input. Een pipeline-defect bestaat pas als
een downstreamlaag die expliciete invoer verliest, zelf nieuwe autoriteit
verzint of host-lokale netwerkcode nodig heeft om haar te materialiseren.

| Onderwerp | Eigenaar en migratie | Classificatie |
| --- | --- | --- |
| VLAN2-hostmanagement met DHCPv4 en `UseDNS = false` | Het minimale hostprofiel mag vereiste managementbereikbaarheid vastleggen. Beschrijf de interface in inventory/hostprofiel; leid er geen tenantpolicy uit af. | Realization-input, geen defect. |
| QEMU-bridges, NIC-volgorde en bestaande host-MAC's | Dit zijn eigenschappen van de productiehost en hypervisorhandoff. Houd ze in de host/inventory-boundary en gebruik ze niet als generiek SMS-voorbeeld. | Realization-input, geen defect. |
| Adressen van `core-dns`, access-resolvers en listeners | Dit zijn toegewezen endpointadressen. Intent verwijst naar de benoemde service; inventory bindt die service aan concrete adressen. Meerdere geldige core/egress-kandidaten moeten door de FS-540-selectie exact één reproduceerbare binding opleveren of een warning/failure geven. | Realization-input; alleen ambigue of downstream verzonnen selectie is een defect. |
| `reservationSource.sourceFile` en SOPS-mount | Inventory mag alleen schema, classificatie en runtimepad leveren. Hostname, MAC, IPv4, IPv6-IID en DUID/IAID blijven volledig protected. | Secret-delivery en datamigratie, geen policydefect. |
| Reservationnamen naar lokale A/AAAA/PTR-data | Inventory declareert alleen de bovenstaande lokale publicatiepolicy en opaque bron. Dat expliciete `namePublication`-blok is vereiste migratie-invoer, geen fout. CPM en beide renderers materialiseren de records pas runtime; een NixOS-profielscript dat zelf Unbound-records maakt is geen blijvende eigenaar. | Native kandidaat gepusht onder `FS-560-HDS-010-SDS-010-SMS-050`; de row blijft `NOT OK` totdat consumerpin, cold stage en live NixOS/CLAB-bewijs zijn afgerond. |
| PPPoE IPv6/Prefix Delegation | Interface, provider, IAID en PD-request-ID zijn inventoryfeiten. De IPv6-default, DHCPv6-PD-client, ordering en exacte reply-firewall horen uit CPM en de NixOS/CLAB-renderers te komen. | Invoer is geen defect; native gap: `FS-800-HDS-030-SDS-020-SMS-020`. |
| Nebula public ingress | Maak van de bestaande gemengde familie-neutrale NAPT-relatie twee expliciete authorities: behoud IPv4-NAPT alleen voor de afzonderlijk benoemde IPv4-tuples en declareer IPv6 als `family = "ipv6"`, UDP/4242, `translationMode = "none"`, `sourcePreservation = "preserve-source"` en stateful return. Bind in inventory de benoemde provider-uplink aan exact één bestaande VLAN3-service-endpoint; de lage 64 bits van diens inventory-adres vormen de stabiele IID. Lever daarnaast exact één protected runtime routed-prefix. Provider-interface, next hop, gateway en geselecteerde routetabellen blijven inventory/site-realization. Zet `publicSurface`, `targetEndpoint`, IID of prefixwaarde niet nogmaals als policyautoriteit in de relation. | De wijziging aan `intent.nix`/`inventory.nix` is migratie, geen fout. De native constructiekandidaat onder `FS-230-HDS-010-SDS-010-SMS-040` is gepusht en groen; alleen consumerpin, cold stage en live NixOS/CLAB-bewijs staan nog open. |

Een literal is dus niet op zichzelf verboden. Zij is fout geplaatst wanneer zij
policyautoriteit vervangt, protected clientdata lekt of in een downstreamlaag
een waarde dupliceert die al door de benoemde upstreambron wordt geleverd.

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
   laat alleen de renderer de Kea- en lokale Unbound-data maken. Declareer de
   gewenste naamruimte en A/AAAA/PTR-klassen via `namePublication`; kopieer
   daarvoor geen hostnaam of adres naar `inventory.nix`.
5. Verwijder de lokale reservation-/leasepad-overwrites pas nadat de kandidaat
   bouwt en een redacted runtimevergelijking exact slaagt. Bij afwijking:
   fail-closed, niet activeren en de vorige generatie behouden.
6. Verwijder host-lokale IPv6/DNS-compatibiliteitscode alleen nadat de owning
   `network-*`-laag dezelfde expliciete intent- en inventory-input native
   materialiseert voor zowel NixOS als CLAB. Verplaats host- of sitefeiten niet
   naar intent om alleen een lokaal bestand te kunnen verwijderen.
7. Splits voor Nebula de IPv4-NAPT- en IPv6-no-translation-authority. Gebruik
   voor IPv6 alleen UDP/4242 en koppel de bestaande protected VLAN3-prefix aan
   de stabiele IID van de endpoint. Neem geen afgeleide GUA, wildcard-prefix,
   TCP-toestemming of NAT66 op in plain inventory of intent.

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
