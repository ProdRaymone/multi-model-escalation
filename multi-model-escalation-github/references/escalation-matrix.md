# Escalation Matrix

Use this table to decide whether a stronger reviewer is justified.

| Situation | Primary only | Add structuring pass | Add auditor |
|---|---|---|---|
| Simple task, low stakes | yes | no | no |
| One-off tool failure, obvious fix | yes | optional | no |
| Same command or API fails 2+ times | no | yes | optional |
| Conflicting explanations between models or artifacts | no | yes | yes |
| Result may be promoted to `TOOLS.md`, `AGENTS.md`, or `SOUL.md` | no | yes | yes |
| User asks for comparison / second opinion | no | yes | yes |
| Irreversible, expensive, or hard-to-undo change | no | yes | yes |

## Automatic Triggers

These triggers require little or no subjective judgment:

1. the same command, API call, or error signature fails at least 2 times
2. the output will update `TOOLS.md`, `AGENTS.md`, `SOUL.md`, or another long-lived rule file
3. the draft includes explicit uncertainty such as `I'm not sure`, `I may be wrong`, `unclear`, or `needs review`
4. the task deletes, overwrites, or materially changes an existing long-lived rule or automation

When any automatic trigger fires, treat at least a structuring pass as required.

## Judgment-Based Triggers

These still matter, but they depend on context and should not be the only trigger source:

1. evidence feels incomplete even though nothing directly contradicts it
2. the change seems high consequence because later work may rely on it
3. another model's answer feels suspicious but the contradiction is not yet explicit

Prefer combining a judgment-based trigger with an automatic trigger whenever possible.

## Cheap-First Rule

If the same model can both execute and structure the result without losing fidelity, keep it on the same tier.

Escalate only when:

1. evidence is incomplete
2. conclusions are disputed
3. a long-lived rule may be created
4. the user explicitly wants independent review

## Hard vs Soft Escalation

### Soft escalation

Use when:

1. you only need cleaner artifacts
2. you are not yet asking another model to decide

Outcome:

- create `docs/review-artifacts/<case-name>/brief.md`
- stop there if cost or availability says no further escalation

### Hard escalation

Use when:

1. the current conclusion may be wrong
2. a stronger model must challenge the claim
3. a permanent rule is about to be promoted

Outcome:

- send the compact packet to a stronger reviewer
- adopt only evidence-backed findings
