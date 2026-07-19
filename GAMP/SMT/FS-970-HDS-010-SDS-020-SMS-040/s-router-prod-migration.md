# s-router-prod: minimale migratie naar model-owned netwerkgedrag

Dit is een korte operatornotitie, geen productie-activatiegoedkeuring. De
canonieke `github/nixos`-repo blijft schoon op `origin/main`; alleen
`github/.worktrees/nixos-s-router-prod-reservations/` is lokaal gebouwd. Alle
runtimeproeven horen op de geïsoleerde `s-router-{nixos,clab,test-clients}` en
niet op VLAN2, een productiesubnet of een productieadres.

## Kandidaatpins en resultaat

De lokale consumerkandidaat gebruikt deze gepushte revisions:

| Flake-input | Revision | Verantwoordelijkheid |
| --- | --- | --- |
| `network-labs` | `b1a84a5c8cbd` | geïsoleerde rows, protected endpointcontract, SOPS-delivery en actieve FS-230-labselectie |
| `network-compiler-prod` / `nixos-network-compiler-prod` | `6dea1cd4315d` | expliciete ingress-only intent zonder fictieve egress behouden |
| `network-forwarding-model-prod` | `a114b33ae555` | fysieke ingress-anchor scheiden van egress-/NAT-authority |
| `network-control-plane-model{,-prod}` | `0684468ba982` | protected reservations/namen, IPv6-ingress en expliciete egress-selectie |
| `network-renderer-nixos{,-prod}` | `1761fc229c44` | native NixOS Kea/DNS/routes/firewall en vijf-node ingressbewijs |
| `network-renderer-containerlab-linux-backend` | `15264eb1e7e5` | equivalente CLAB-materialisatie en runtime-regelvalidatie |
| `network-renderer-access-endpoint-nixos` | `d2d78859130a` | echte geïsoleerde test-clients met runtime-only protected `/128` |
| `network-renderer-nebula` / `network-renderer-wireguard` | `0e6ee9367b40` / `a12d75b229ce` | overlay-output, zonder extra policy- of DNS-autoriteit |

Met deze pinset bouwt `s-router-prod` zonder de lokale reservation-DNS-parser,
DNS-projecties, IPv6/Nebula-compatibiliteitsmodule of VLAN2-policy-override.
Kea, lokale protected A/AAAA/PTR-publicatie, DNS-paden, protected IPv6-routes
en de exacte firewallhandoffs komen uit CPM plus renderers. Host-DHCPv4,
QEMU-bridges, NIC-volgorde en de MAC’s van de VM-facing host-NICs blijven
normale hostrealization; die hoeven niet naar een generieke network-*-laag.
Client-MAC’s die een reservation identificeren blijven daarentegen uitsluitend
in de protected SOPS-recordset.

## Configuratie of defect

Een wijziging in `prod-network/s-router-prod/{intent,inventory}.nix` is niet
automatisch een bug. Intent bezit allows, denies, familie/protocol/poort,
return- en translation-authority. Inventory/site-realization bezit host,
interface, endpoint, secretpad en providerbinding. Een pipeline-defect bestaat
pas wanneer een downstreamlaag die invoer verliest, zelf nieuwe autoriteit
verzint of host-lokale netwerkcode nodig heeft om haar te materialiseren.
Ontbreekt de gewenste s-router-prod-authority of sitefact nog in deze twee
consumerbestanden, dan is het toevoegen of corrigeren daarvan dus gewone
migratieconfiguratie. Dat wordt in deze notitie benoemd en niet als een
network-*-defect geregistreerd.

| Vereiste consumentinvoer | Hoort in | Geen pipelinebug omdat |
| --- | --- | --- |
| aparte IPv4-NAPT- en IPv6-no-translation-Nebula-relaties | `intent.nix` | alleen de operator ingress-authority kan verlenen |
| VLAN2→core DNS, VLAN3 local-only sharing en expliciete denies | `intent.nix` | laterale toegang mag nooit impliciet recursie of egress erven |
| core-DNS-provider, access-listeners en provider/uplinkbinding | `inventory.nix` | dit zijn site- en endpointfacts |
| PPPoE DHCPv6-PD-modus, IAID/request-ID en reserverings-publicatieschema | `inventory.nix` | dit zijn expliciete site-/protocolinputs, geen rendererdefaults |
| hostmanagement-DHCP en VM-facing bridge/NIC/MAC | hostrealization | dit beschrijft de fysieke consumerhost |
| private hostname, client-MAC, IPv4, IPv6/IID, DUID en IAID | SOPS-runtimebron | deze waarden mogen evaluatie en Nix store niet in |

- De Nebula-migratie splitst IPv4-NAPT en IPv6-no-translation. IPv6 staat op
  UDP/4242, `preserve-source` en stateful return. De provider-uplink bindt aan
  exact één bestaand VLAN3-endpoint; diens lage 64 bits zijn de stabiele IID.
  Dit zijn geldige `intent.nix`/`inventory.nix`-wijzigingen, geen bugfix op
  zichzelf.
- Het huidige consumer-schema bewaart protected `routedPrefixes`, slot,
  prefixlengtes en het opaque `sourceFile` onder `ownership` in `intent.nix`.
  Ondanks de bestandsnaam zijn dit allocation-/site-inputs, geen egresspolicy.
  Verplaats ze niet alleen voor cosmetische file ownership; het geheime prefix
  zelf blijft uitsluitend runtime in SOPS.
- Reservation-`namePublication` in plain inventory bevat alleen namespace,
  owner/requesters, `A`/`AAAA`/`PTR`, `local-only` fallback en een redacted
  diagnostic. CPM leidt `source` en `sourceFamily` af. Hostnaam, MAC, IPv4,
  IPv6/IID, DUID en IAID horen niet in plain inventory of de Nix store.
- DNS-adressen zijn endpointrealization; intent verwijst naar benoemde
  services. Bij multi-egress moet exact één family-complete core/egressbinding
  reproduceerbaar volgen. Anders worden zonder adressen deze warnings
  uitgegeven: `DNS_EGRESS_SELECTION_MISSING`,
  `DNS_EGRESS_SELECTION_AMBIGUOUS`, `DNS_CORE_ENDPOINT_PATH_MISMATCH` of
  `DNS_CORE_FAMILY_INCOMPLETE`.
- PPPoE-interface, IAID en DHCPv6-PD-request-ID zijn site-input. Default route,
  PD-client, ordering en reply-firewall horen native uit CPM/renderers te
  komen.

## Migratie van reservations en compatibiliteit

1. Start een client op een geïsoleerde access-scope. Noteer van dezelfde
   interface MAC, stabiele niet-tijdelijke IPv6-IID en zo nodig DUID/IAID.
   Reboot de client en accepteer alleen identieke identifiers. Gebruik geen
   productie-VLAN of productieadres voor deze opname.
2. Zet één volledig record met private hostname, gewenste IPv4/IPv6 en de
   identifiers in SOPS. Een hostname kan een serienummer bevatten en is daarom
   net zo protected als MAC, IID, DUID en IAID. Print of kopieer geen recordveld
   naar inventory, logs, diagnostics, evaluatie-output of de Nix store.
3. Declareer uitsluitend het opaque schema, `sourceClass = "protected"`,
   `/run/secrets/...`-pad en de owner-scoped `namePublication`. Lever het
   gedecrypte bestand mode `0400`, read-only, aan de geselecteerde runtime.
4. Laat dezelfde protected recordset pas runtime Kea én lokale Unbound-data
   maken. De namespace is authoritative/static: een onbekende lokale naam of
   reverse-entry eindigt lokaal en valt nooit door naar publieke recursie.
   Bewijs na een reboot dat dezelfde MAC een voorspelbare IPv4-reservation en
   dezelfde IID/prefixbinding een voorspelbare IPv6-`/128` opleveren.
5. Verwijder host-lokale generators/overrides pas nadat NixOS én CLAB dezelfde
   row uit gepushte pins bouwen, alle drie labhosts tegelijk uit zijn geweest,
   offline zijn waargenomen en met nieuwe boot-ID/closure plus exacte
   bronhashes/pins terugkomen. Een `switch-to-configuration`, namespace-edit of
   andere runtime-hotpatch is geen stagebewijs.

## Bewijsgrens

- `FS-970-HDS-010-SDS-020-SMS-040` plus SIT
  `FS-970-HDS-010-SDS-020`: echte clients bewijzen SOPS→runtime en
  voorspelbare IPv4/IPv6 uit stabiele MAC/IID/DUID/IAID op NixOS en CLAB.
- `FS-270-HDS-010-SDS-010-SMS-020` plus SIT: vijf-node state-owner,
  stateful return, reverse-new deny en geen geleende egress.
- `FS-540-HDS-010-SDS-010-SMS-045` plus SIT: IPv4/IPv6 UDP/TCP DNS via één
  modelgeselecteerde core-egress, lokale sharing, laterale `REFUSED`, directe
  VLAN3→core blokkade en nul selectie-warnings.
- `FS-560-HDS-010-SDS-010-SMS-050`: native protected A/AAAA/PTR en
  local-only namespace zijn construction-green; de verse driehost-cold-stage
  en live NixOS/CLAB-predicate staan nog `NOT OK`.
- `FS-230-HDS-010-SDS-010-SMS-040`: exact IPv6 UDP/4242, geen NAT66/TCP,
  stateful return en selected-path scoping zijn construction-green; de echte
  geïsoleerde NixOS/CLAB/test-clientstage staat nog `NOT OK`.

De lokale `s-router-prod`-build en migratietest zijn compilatiebewijs. Pas na
de twee open cold stages en de vereiste HAT/SAT/operatorgoedgekeuring mag de
productieconfig worden gemigreerd.
