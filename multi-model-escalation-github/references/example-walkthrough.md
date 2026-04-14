# Example Walkthrough

Use this example to see the full workflow end to end.

## Scenario

A cheap or local model tries to install a skill from ClawHub. The install fails repeatedly with `429`, a raw incident note is written, and the team must decide whether the lesson should be promoted into `TOOLS.md`.

## Step 1. Preserve the raw result

Save:

1. the original model output that described the failure
2. the relevant log lines showing `429`
3. the first draft of the learning or error entry

Example artifacts:

- `docs/review-artifacts/clawhub-rate-limit/before/agent-note.md`
- `docs/review-artifacts/clawhub-rate-limit/evidence.log`

## Step 2. Build the evidence chain

Extract only supported facts:

1. first failed install timestamp
2. repeated failure timestamp
3. exact `429` message
4. whether a second slug or command also failed

Separate facts from inferences:

- fact: `429` happened multiple times
- inference: the rate limit may be broader than a single slug

## Step 3. Produce a structured revision

Turn the raw note into a compact packet:

- `docs/review-artifacts/clawhub-rate-limit/after/ERRORS.md`
- `docs/review-artifacts/clawhub-rate-limit/brief.md`

The packet should include:

1. task statement
2. evidence summary
3. primary draft
4. reviewer questions
5. adoption policy

## Decision. Soft or Hard Escalation

In this example, choose **Hard escalation** because:

1. repeated external failure already occurred
2. the conclusion may affect a long-lived rule in `TOOLS.md`
3. wording about rate-limit scope needs stronger review

If the incident were only a one-off formatting cleanup with no promotion target, a soft escalation would be enough.

## Step 4. Run the audit

Ask the stronger reviewer to check:

1. whether the evidence really supports the causal chain
2. whether the conclusion overclaims
3. whether the lesson should become a tool rule

## Step 5. Adopt selectively

Possible outcomes:

1. accept the reviewer finding that repeated short retries are unsafe
2. soften unsupported wording like `account-wide` into `broader than a single slug`
3. reject purely stylistic rewrites

## Step 6. Promote stable rules

If the lesson is broadly useful, promote a concise rule into `TOOLS.md`, for example:

`Always search for the exact skill slug before install, and stop short-interval retries after a 429.`

Keep the full incident details in `.learnings/` or the review packet, not in the long-lived rule file.
