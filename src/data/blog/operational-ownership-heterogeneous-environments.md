---
author: Jevgeni D.
pubDatetime: 2026-03-04T00:00:00Z
title: "Operational Ownership Across Systems You Did Not Build"
description: "What it means to be responsible for production reliability across multiple independent systems with different architectures, different stakeholders, and different failure modes."
wip: true
tags:
  - sre
  - operations
  - production
  - kubernetes
---

Most SRE writing assumes you are working on one product. Your team
built it or inherited it, you know its architecture deeply, and
reliability work means improving that one system over time.

My experience was different. At any given point I was operationally
responsible for 8-10 independent production environments across AWS
and Azure. These were not microservices within one product - they were
entirely separate applications for different clients. A video
interviewing platform, a large-scale video hosting system, a
fundraising platform. Different technology stacks, different
deployment patterns, different failure modes, different people to call
when something went wrong.

This post is about what that is actually like and what it teaches you
that single-product SRE does not.

## The Context-Switching Problem

The hardest part is not any individual system. Each one, in isolation,
is manageable. The hard part is the context switch.

At 2 AM you might get paged for a Kubernetes pod crash loop in one
environment. You pull up the runbook, check the dashboards, identify
the issue, resolve or escalate. By 4 AM you might get paged for a
completely different environment - different cluster, different
application, different monitoring setup, different stakeholder
expectations around response time.

Your brain has to swap out one entire mental model and load another.
Under sleep deprivation. Under time pressure. This is where most
mistakes happen - not from lack of knowledge, but from accidentally
applying the wrong mental model to the wrong system.

<!-- TODO: Add a concrete (anonymized) example of a time when context
switching led to a near-miss or a slower response. -->

## What Helps

**Runbook standardization.** When every environment has a different
documentation structure, the cognitive cost of finding information
during an incident multiplies. I pushed for a consistent runbook
format across all environments - same sections, same structure,
regardless of the underlying application. The content differs, but the
shape is predictable.

**Per-environment dashboards with consistent layout.** Grafana
dashboards for each environment followed the same visual pattern:
top row is SLI overview, second row is resource utilization, third row
is application-specific metrics. When you are half-awake and looking
at a dashboard, muscle memory matters.

**Explicit "what is different about this environment" documentation.**
For each system, a short document covering: what makes this one
unusual, what are the known failure modes that do not apply elsewhere,
who are the stakeholders and what are their expectations. This was the
most valuable documentation we maintained.

<!-- TODO: Expand each of these with more detail. What did the runbook
template look like? What were the standard dashboard sections? -->

## What It Teaches You

Working across heterogeneous environments forces a kind of
generalization that single-product work does not. You start to see
patterns: the failure modes that recur regardless of application, the
operational practices that scale across systems, the monitoring
approaches that work everywhere versus the ones that are specific to
a particular architecture.

It also teaches you humility about depth. You cannot be a deep expert
in 10 systems simultaneously. You have to be honest about what you
know and what you are pattern-matching on, and you have to build
systems - runbooks, escalation paths, documentation - that compensate
for the limits of individual knowledge.

<!-- TODO: This is the section with the most room for honest
reflection. What did I struggle with? Where did the lack of depth
actually cost us? How did I balance breadth vs depth in practice? -->

## The SLO Dimension

<!-- TODO: Add section on how SLO/SLI calculation works when you have
multiple independent systems with different contractual obligations.
The practical challenge of tracking error budgets across environments
with different definitions of availability. Keep it honest about what
was rigorous and what was approximate. -->

This section is not written yet. The short version: calculating
SLO/SLI metrics across multiple environments with different
contractual SLA obligations - where breaches trigger real financial
consequences - is its own discipline. I want to write about this
properly rather than superficially.