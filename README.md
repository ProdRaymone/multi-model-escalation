# Multi-Model Escalation

A cost-aware OpenClaw skill for running a cheap-first, review-gated multi-model workflow.

This skill is designed for cases where:

- a cheap or local model produces the first draft
- the result may become a long-term rule or workflow
- another model should review, challenge, or audit the result
- repeated tool or API failures create uncertainty
- the user explicitly wants model comparison or adjudication

## What This Skill Does

`multi-model-escalation` helps separate work into three roles:

1. primary executor
2. evidence structurer
3. auditor / challenger

It aims to keep costs low by defaulting to the cheapest capable model, and only escalating when a real gate is met.

## Included Files

- `SKILL.md`: main skill definition
- `references/escalation-matrix.md`: escalation decision table
- `references/review-packet.md`: review packet guidance
- `references/example-walkthrough.md`: end-to-end incident example
- `assets/review-packet-template.md`: fill-in template
- `scripts/escalation-check.sh`: lightweight detector for automatic trigger checks

## Notes

- This repository contains the public skill files only.
- Local machine-specific runtime configuration is intentionally excluded.
- License is not included yet. Add one before broader public reuse if needed.

## Suggested Tags

`openclaw`, `skill`, `agents`, `workflow`, `review`, `cost-control`, `governance`
