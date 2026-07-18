# FS-540-HDS-010-SDS-010-SMS-045

Template row for prod-like access recursive DNS over controlled lab provider
surfaces.

The SMT source is
`GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/`. It models the production-style
five-node router chain with a real `s-router-test-clients` endpoint and an
emulated provider, avoiding PPPoE and public DNS dependencies so recursive
resolver behavior remains deterministic when the real ISP handoff or public
authority is unavailable. The selected provider owns a harness-scoped
dual-stack authoritative hierarchy with root, delegated test namespace, and
terminal record. The core remains iterative: the fixture replaces only the
provider-side authority realization, not DNS policy or the production
resolver mode. The row models access DNS as
an explicit service-origin flow from the lab-only tenant gateway address so
recursive resolver traffic does not rely on an unscoped default-route source.
The NixOS realization uses the `dnsclient` VLAN304 test-client bridge. The CLAB
realization is bound to the separate `dnsclab` VLAN305 bridge so it cannot
answer ARP for the NixOS router's gateway while both surfaces are online.

Status: NOT OK for the revised contract.

The 2026-07-03 run is historical evidence for the earlier IPv4 recursion atom
only. It did not prove exact provider-side terminal listener identity,
dual-stack UDP/TCP, bilateral local-only isolation, deterministic multi-egress
warnings, or a zero-warning valid profile. Those predicates require new pushed
construction followed by a cold-staged NixOS and CLAB run with real isolated
test clients. Acceptance also requires the selected multi-egress path to work
for the resolver's first upstream route decision, the resolver process and
authorized listeners to remain present throughout the live protocol, and
unchanged dynamic next-hop state to converge to stable, quiescent operation.
For routed IPv6, the cold-boot predicate is functional RA consumption: the
selected core interface must acquire a global address from the controlled
provider and install the provider default in the selected policy table while
forwarding remains enabled. A source flag, a kernel sysctl value, or visible
RS/RA traffic without that address and route is not sufficient evidence.
The controlled provider must originate RA from a valid link-local address and
the packet must be observed on the core-facing bridge port; an authority log
claiming `RTR-ADVERT` without a transmitted packet does not pass.
Selected egress applies only to upstream resolver-origin requests: a route
probe under the resolver UID plus UDP/TCP destination port 53 must select the
provider during the initial socket route lookup, while replies for internal
access/client destinations retain the modeled relationship return path. An
output-hook-only mark does not pass when the socket fails before packet
emission; completed recursion does not pass when a process-wide provider
selector loses the internal reply.

The live protocol must derive the controlled authority endpoints and trust
material from the staged fixture artifact. A public name, an Internet root
server, host resolver state, or a transparent recursive proxy is invalid
evidence. The alternate eligible-looking provider shall not be able to answer
the accepted hierarchy; otherwise the row has not proved deterministic DNS
egress selection.
