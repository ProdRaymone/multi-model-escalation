# Multi-Model Escalation

A cost-aware OpenClaw skill for cheap-first, review-gated multi-model workflows.

## Why

Most tasks do not need the strongest model first. This skill helps agents and operators:

- start with the cheapest capable model
- escalate only when evidence, risk, or user intent justifies it
- separate facts from inferences before review
- prepare compact review packets for stronger models or human reviewers
- decide whether a result should be promoted into long-lived files such as `TOOLS.md`, `AGENTS.md`, or `.learnings`

## Best Used For

- repeated failures or retry loops
- conflicting evidence across logs, files, or model outputs
- model comparison, second opinions, or adjudication
- work that may turn into a long-term rule or workflow
- cost-sensitive review pipelines

## Repository Layout

- `SKILL.md` — main skill definition
- `references/escalation-matrix.md` — escalation decision table
- `references/review-packet.md` — review packet guidance
- `references/example-walkthrough.md` — end-to-end incident example
- `assets/review-packet-template.md` — fill-in template
- `scripts/escalation-check.sh` — lightweight automatic trigger detector

## Notes

This repository contains the public reference copy of the skill.

The live runtime version may evolve in a local OpenClaw workspace before being published to registries such as ClawHub.

## Status

Public GitHub release. ClawHub publication is planned.

## License

See `LICENSE`.
