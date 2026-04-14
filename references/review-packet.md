# Review Packet

When escalating to another model, keep the packet compact and auditable.

Store the packet as Markdown at:

`docs/review-artifacts/<case-name>/brief.md`

If the full evidence is too large, keep that raw material elsewhere in the same case folder and link to it from the packet.

For a ready-to-fill skeleton, copy [../assets/review-packet-template.md](../assets/review-packet-template.md).

## Evidence Size Limit

Keep the evidence excerpt portion under roughly 2000 tokens.

If logs or command output are larger than that, include only:

1. the first relevant event
2. the last relevant event
3. each distinct error message once
4. a one-line summary of what happened between them

Link the full artifact instead of pasting it all into the review prompt.

## Required Contents

1. **Task statement**
   - What is being judged?

2. **Raw evidence**
   - logs
   - command output
   - file snapshots
   - timestamps

3. **Primary draft**
   - what the first model concluded

4. **Questions for the reviewer**
   - what should be checked?
   - what claims are uncertain?
   - what should be promoted, if anything?

5. **Adoption policy**
   - reviewer should not rewrite everything
   - reviewer should focus on evidence gaps, overclaims, and promotion decisions

## Recommended File Layout

```text
docs/review-artifacts/<case-name>/
  before/
  after/
  final/
  brief.md
  review-notes.md
  evidence.log
```

## Recommended Reviewer Prompt

```text
Review this case as an auditor, not as a rewriter.

Please:
1. verify the evidence chain
2. identify unsupported or overstated claims
3. point out missing facts
4. say which lessons should or should not be promoted into long-lived rules

If you suggest changes, separate:
- evidence-backed corrections
- optional stylistic improvements
```

## Adoption Rule

After review, classify every suggestion as one of:

1. **accept**
2. **reject**
3. **soften**
4. **defer**

Use `soften` when the reviewer is directionally right but the wording is too strong for the available evidence.
