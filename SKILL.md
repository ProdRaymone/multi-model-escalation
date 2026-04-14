---
name: multi-model-escalation
description: "Cost-aware multi-model workflow for turning failures, conflicting evidence, or important decisions into audited outcomes. Use when: (1) a cheap or local model produced a draft that may become a long-term rule, (2) another model should check or challenge a result, (3) the user explicitly asks for model comparison, second opinion, or cross-check, (4) repeated retries or tool/API failures create uncertainty, or (5) work should be escalated from the cheapest capable model to a stronger reviewer only when justified. Complements self-improvement: self-improvement logs incidents; this skill decides escalation, evidence packaging, reviewer scope, and promotion to TOOLS.md / AGENTS.md."
metadata:
---

# Multi-Model Escalation

Use this skill to run a **cheap-first, review-gated** workflow.

Do not default to the strongest model. Default to the **cheapest capable model**, then escalate only when evidence or risk justifies it.

## Core Idea

Split work into 3 roles:

1. **Primary executor**
   - Default: local or cheap model
   - Job: attempt the task, generate the first draft, produce raw artifacts

2. **Evidence structurer**
   - Default: same model if possible; otherwise a medium-cost model
   - Job: extract timeline, clean up artifacts, prepare a compact review packet

3. **Auditor / challenger**
   - Default: strongest available reviewer, or a human reviewer if already available
   - Job: challenge the draft, find missing evidence, reject overclaims, suggest promotion targets

If the auditor is unavailable or too expensive for the current task, stop after step 3 and leave a clean review packet for later human-triggered review.

## Scope Limitation

Optimize this skill for the most common path:

1. cheap or local model executes first
2. same or medium-tier model structures the evidence
3. stronger reviewer checks only when a gate is met

Do not assume this skill fully covers:

1. peer review between same-tier models
2. repeated independent runs of the same model as self-review
3. a fully human-only adjudication workflow

The packet format is intentionally human-readable, but the core workflow is still optimized for cheap-first model escalation.

## When to Trigger

Use this skill when any of these are true:

1. A failure or bug may become a long-term rule, memory, or workflow
2. Two models disagree, or one model's answer feels suspicious
3. A local/cheap model completed the task, but the result needs stronger validation
4. A tool or external API failed repeatedly and the incident needs reliable write-up
5. The user explicitly asks for model comparison, second opinion, audit, or adjudication
6. The work affects `TOOLS.md`, `AGENTS.md`, `.learnings`, automation, or other long-lived instructions

Do **not** trigger for routine low-stakes tasks where a second model adds little value.

## Escalation Gates

Escalate from the primary model only if at least one gate is met:

1. **Repeated failure**: same or related operation failed more than once
2. **Conflicting evidence**: logs, outputs, or files do not support the current conclusion
3. **Long-term promotion**: result may be promoted into `TOOLS.md`, `AGENTS.md`, `SOUL.md`, or memory
4. **High consequence**: change is expensive, hard to undo, or likely to mislead later work
5. **Explicit user request**: user asks for comparison, review, or model-vs-model judgment

If no gate is met, do not escalate.

For a more explicit decision table, read [references/escalation-matrix.md](references/escalation-matrix.md).

## Automatic Triggers

Treat these as low-judgment triggers. If any match, consider a gate met without waiting for subjective confidence checks:

1. the same command, API call, or error signature failed at least 2 times in the current session
2. the draft will write to `TOOLS.md`, `AGENTS.md`, `SOUL.md`, `.learnings/`, or another long-lived instruction file
3. the primary model explicitly signals uncertainty with phrases like `I'm not sure`, `I may be wrong`, `unclear`, or `needs review`
4. the task deletes, overwrites, or materially changes an existing long-lived rule, automation, or memory file

For hook or wrapper integration, use [scripts/escalation-check.sh](scripts/escalation-check.sh) as a lightweight detector.

### Hook Setup (Optional)

For Claude Code or Codex-style command hooks, attach the detector to shell output after tool execution.

Example `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "printf '%s\n' \"$TOOL_RESULT\" | /absolute/path/to/multi-model-escalation/scripts/escalation-check.sh"
      }]
    }]
  }
}
```

The same pattern works in `.codex/settings.json`.

Operational notes:

1. the script reads tool output from `stdin` by default
2. if your hook runner writes output to a file instead, pass the file path as the first argument
3. the script emits `[escalation] ...` lines only when a trigger fires
4. use `ESCALATION_SESSION_KEY` if you want separate repeated-error counters per task or session

## Cost Policy

Follow this priority order:

1. Try local or cheap model first
2. Reuse the same model for evidence cleanup if it can do the job
3. Only call a stronger reviewer after assembling a compact packet
4. If a stronger reviewer is unavailable, leave a review-ready packet instead of improvising a fake audit

Never spend expensive-model budget just to restate the same unsupported conclusion more elegantly.

Define **compact packet** concretely:

1. keep evidence excerpts under roughly 2000 tokens before sending to a stronger reviewer
2. deduplicate repeated errors
3. keep only the first, last, and distinct relevant log entries
4. link the full raw artifact instead of pasting it all into the review prompt

## Artifact Protocol

When this skill triggers, preserve evidence before editing conclusions.

Preferred case structure:

```text
docs/review-artifacts/<case-name>/
  before/
  after/
  final/
  brief.md
  review-notes.md
  evidence.log
```

Minimum required artifacts:

1. **before**: raw output from the first model
2. **after**: structured revision
3. **final**: adopted version after review
4. **evidence**: exact timestamps, commands, logs, file references
5. **review note**: which suggestions were accepted, rejected, or softened

If a project already uses another structure, reuse it consistently instead of forcing this layout.

Write the review packet itself as Markdown at `docs/review-artifacts/<case-name>/brief.md`.

For packet contents and prompt structure, read [references/review-packet.md](references/review-packet.md).
For a fill-in template, copy [assets/review-packet-template.md](assets/review-packet-template.md).
For an end-to-end incident example, read [references/example-walkthrough.md](references/example-walkthrough.md).

## Workflow

### Step 1. Preserve the raw result

Before improving anything:

1. Save the original output
2. Save the relevant logs
3. Save the exact files being reviewed

Do not overwrite the first draft before creating a snapshot.

### Step 2. Build the evidence chain

Extract only the facts that can be supported directly:

1. timestamps
2. commands
3. errors
4. file diffs
5. concrete outputs

Separate:

1. **facts**
2. **inferences**
3. **recommendations**

If a statement is only an inference, label it that way.

If raw evidence is too large, compress it before review:

1. keep the first relevant event
2. keep the last relevant event
3. keep each distinct error once
4. summarize the gap between them in one line
5. link the full log or file for on-demand reading

### Step 3. Produce a structured revision

The structuring pass should:

1. fix obvious formatting or schema issues
2. fill in missing causal links when supported by evidence
3. remove claims that are not evidenced
4. prepare a compact artifact set for review

This pass should improve clarity, not invent certainty.

### Decision. Soft or Hard Escalation

After step 3, decide which path you are on:

1. **Soft escalation**: evidence is clean, no disputed conclusion remains, and no permanent rule is at stake
   - save `brief.md`
   - stop here if a stronger reviewer is unnecessary, unavailable, or too expensive
2. **Hard escalation**: conclusion may still be wrong, or a long-lived rule is about to be created
   - continue to step 4

See [references/escalation-matrix.md](references/escalation-matrix.md) for the full decision table.

### Step 4. Run the audit

The auditor should answer:

1. What is still missing?
2. Which claims are too strong?
3. Which recommendations are truly evidence-backed?
4. Should any lesson be promoted into long-lived instructions?

Treat the auditor as a challenger, not a rubber stamp.

### Step 5. Adopt selectively

After review:

1. accept evidence-backed improvements
2. soften overconfident claims into narrower wording
3. reject purely stylistic rewrites unless they materially improve correctness

Do not "accept all suggestions" by default.

### Step 6. Promote stable rules

Promote only if the lesson is:

1. likely to recur
2. broadly applicable
3. useful beyond the single incident

Promotion targets:

1. `.learnings/` for incident history
2. `TOOLS.md` for tool usage rules and integration gotchas
3. `AGENTS.md` for workflow and delegation rules
4. `SOUL.md` for behavioral principles

## Output Requirements

When using this skill, produce a result with these sections when relevant:

1. **Evidence Timeline**
2. **Primary Draft Weaknesses**
3. **Reviewer Findings**
4. **Adopted Changes**
5. **Promotion Decision**

If no reviewer was used, explicitly say:

`Audit deferred: review packet prepared, stronger reviewer not used in this pass.`

## Relationship to self-improvement

Use `self-improvement` to **log** incidents.

Use `multi-model-escalation` to decide:

1. whether the incident deserves a second model
2. how to assemble the evidence packet
3. which reviewer suggestions to trust
4. whether the lesson should become a long-lived rule

`self-improvement` is the memory layer.
`multi-model-escalation` is the adjudication layer.

When both skills are loaded, follow this precedence:

1. routine recurrence-based logging and low-stakes promotion into `.learnings/` stays with `self-improvement`
2. promotion from a single incident into `TOOLS.md`, `AGENTS.md`, or `SOUL.md` should go through at least a structuring pass here
3. if an automatic trigger or escalation gate is met, let this skill decide whether a stronger reviewer is needed before promotion

## Practical Default for Cost Control

If the user does not specify otherwise, use this default strategy:

1. **Execution**: local or cheapest capable model
2. **Structuring**: same model or medium-cost model
3. **Audit**: only when an escalation gate is met

Good examples:

1. Local model installs or debugs first
2. Medium model rewrites the incident into a clean artifact
3. Expensive model only reviews the artifact when a rule may be promoted or evidence is ambiguous

That keeps expensive review rare and intentional.
