---
author: Jevgeni Diede
pubDatetime: 2026-03-04T00:00:00Z
title: "Alert Tuning Is Not a One-Time Fix"
description: "On the difference between alerts that need threshold adjustment and alerts that are telling you the architecture is wrong."
wip: true
tags:
  - sre
  - observability
  - alerting
  - prometheus
  - on-call
---

Every SRE team I have seen goes through the same cycle with alerting.
You set up Prometheus, write a bunch of alerting rules, and within
weeks the on-call engineer is drowning in noise. Someone suggests an
"alert cleanup sprint." You raise some thresholds, silence some rules,
and declare the problem solved. Three months later you are back in the
same place.

The problem is treating alert tuning as a project that finishes. It
does not. It is an ongoing operational practice - closer to gardening
than to construction.

## The Question That Changed How I Thought About It

When reviewing a noisy alert, the first instinct is usually: "the
threshold is wrong, let's raise it." Sometimes that is correct. But
the more useful first question is: **is this alert noisy because the
threshold is wrong, or because the system is actually misbehaving that
often?**

These require completely different responses. One is a monitoring fix.
The other is an engineering conversation.

<!-- TODO: Add a concrete example here. Something like a disk usage
alert that kept firing - was the threshold too low, or was the
application leaking temporary files? Without revealing client details,
walk through the diagnostic process. -->

## What I Did In Practice

During my time supporting multiple Kubernetes-based production
environments, I reviewed alerting rules on an ongoing basis - not in
sprints, but as a continuous part of on-call work. After each on-call
shift, I would look at which alerts fired, whether the on-call
engineer had to act on them, and whether the action was useful.

Over time this produced a rough classification:

- **Threshold alerts** - the system is healthy, the threshold is just
  wrong for this workload pattern. Fix: adjust the threshold or add
  time-based conditions.
- **Symptom alerts** - the system is genuinely degraded but in a way
  that does not require immediate human action. Fix: downgrade
  severity or convert to a ticket rather than a page.
- **Architectural alerts** - the system is behaving as designed, but
  the design has a problem that surfaces under real load. Fix: this is
  not an alerting fix at all. This is a conversation with the
  development team.

The third category is the one most teams miss. It is easy to silence
an alert. It is harder to say "this alert is telling us something real
about a design limitation, and silencing it means we lose visibility
into a problem we have chosen not to fix."

## The On-Call Feedback Loop

<!-- TODO: Describe the lightweight process I used - post-shift alert
review, tracking which alerts were actionable vs noise, feeding that
back into rule changes. Keep it practical and low-ceremony. -->

The key insight was making alert review part of the on-call handoff,
not a separate maintenance task. When the outgoing on-call engineer
hands off to the incoming one, part of that handoff is: "these alerts
fired, here is what was real and what was noise." That creates a
natural feedback loop without requiring a dedicated process.

## What I Got Wrong

I was too slow to push back on architectural alerts. It is
uncomfortable to tell a client or a development team that their
application design is generating operational noise. It is easier to
just tune the alert. But tuning an alert that is telling you something
true is just hiding information from yourself.

<!-- TODO: Expand this section. Be honest about the organizational
difficulty of this conversation. -->
