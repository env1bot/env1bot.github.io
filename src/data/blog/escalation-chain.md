---
author: Jevgeni D.
pubDatetime: 2026-03-01T00:00:00Z
title: "Designing an Escalation Chain That Actually Works"
description: "What I learned from inheriting a broken escalation process and rebuilding it across multiple production environments under 24/7 support."
wip: true
tags:
  - sre
  - incident-management
  - on-call
  - operations
---

When I took operational ownership of our SRE team, one of the first
problems that surfaced was escalation. Not the concept - everyone
understood that incidents should escalate - but the mechanics.
Escalations were failing silently. Incidents stalled because the
on-call engineer did not know who to contact next, or contacted
someone unavailable, or assumed someone else had already picked it up.

This was not a tooling problem. We had alerting, Slack channels, and
documentation. What we did not have was a clear, tested chain of
responsibility that accounted for real-world conditions - people being
asleep, unreachable, or unfamiliar with a specific environment.

## What Was Broken

We supported multiple independent production environments, each with
different application architectures and different stakeholder
expectations. The on-call engineer might get paged for one system at
2 AM and a completely different system at 6 AM - different failure
modes, different runbooks, different severity definitions.

The escalation process was roughly: "page the on-call, if they can't
fix it, page the team lead." In practice:

- On-call engineers sometimes spent too long on problems outside their
  area before escalating.
- "Page the team lead" was a single point of failure.
- There was no defined timeout. The decision to escalate was entirely
  subjective.
- For less familiar environments, there was no guidance on who held the
  relevant context.

## What I Changed

<!-- TODO: Expand with specifics while keeping client details out. -->

The core principle: remove decision-making from the escalation step.
During an incident, the on-call engineer already has enough cognitive
load. Asking them to also decide *whether* and *to whom* to escalate
introduces delay and anxiety.

I restructured the chain around two ideas: time-based triggers and
environment-specific routing. Each production environment got a
defined primary and secondary contact - someone who actually had
context for that system. Escalation timeouts were tied to severity
levels, not to the engineer's confidence.

Escalation became a default action. If the timeout hits, you escalate.
No judgment call, no guilt.

## What Changed Afterward

Incidents stopped stalling. The time between initial page and either
resolution or correct escalation dropped noticeably. Senior leadership
specifically called this out as a resolved problem area.

The less obvious effect was psychological. On-call became less
stressful when escalation was a structured, expected action rather
than an admission of failure. On-call burnout is often driven not by
incident volume but by the anxiety of ambiguous responsibility. Making
the process mechanical reduced that.

## What I Would Do Differently

<!-- TODO: Honest reflection. Starting points:
- Should have formalized earlier instead of relying on informal
  knowledge
- Per-environment routing needed ongoing maintenance, easy to let slip
- Fire drills would have caught gaps faster
-->

Still drafting this section. The core lesson: escalation is not a
culture problem or a tooling problem. It is a design problem, and it
responds to engineering rather than exhortation.