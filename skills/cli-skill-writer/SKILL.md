---
name: cli-skill-writer
description: Use when turning a CLI tool's real behavior, documentation, help output, and agent-facing pitfalls into a retrieval-led Reference-style OpenCode skill with mandatory grilling, a design brief, and quality gates.
---

# CLI Skill Writer

Use this skill when a user wants to create or improve an agent skill for a command-line tool, especially when they say to "write a skill for this CLI", "turn this CLI into a skill", "follow the gh skill style", or "summarize how agents should use kubectl/docker/helm/aws/gh".

The output is not a tutorial and not a copied man page. The output is an agent-facing reference that preserves the CLI behaviors, flags, examples, counterexamples, and caveats that prevent future agents from making bad calls.

## Mandatory workflow

Follow these steps in order. Do not skip ahead because the CLI feels familiar.

1. Retrieve facts from current sources.
2. Run `grilling` to resolve design decisions with the user.
3. Produce a short design brief from the confirmed decisions.
4. Write the Reference-style `SKILL.md`.
5. Review the result against the quality gate.

If the user asks you to immediately write the skill, still perform the retrieval and grilling phases first unless they explicitly waive them. If they waive grilling, say that this skill requires grilling and ask whether they want a different, lower-confidence drafting workflow instead.

## Retrieval requirements

Prefer facts from the actual CLI and official documentation over memory. Use the user's notes only as leads.

Check the surfaces that affect agent behavior:

- Command tree and relevant `--help` output.
- Non-interactive behavior, prompts, pagers, color, TTY detection, and required flags.
- Structured output such as `--json`, `--output json`, `--format`, templates, or machine-readable modes.
- Pagination, default limits, truncation, cursors, and aggregate count behavior.
- Targeting context such as repo, namespace, cluster, profile, account, region, project, or config file.
- Authentication state, environment variables, config locations, and token precedence.
- Dangerous side effects: delete, overwrite, publish, deploy, switch context, mutate remote state, or leak secrets.
- Fallback paths such as raw API commands, SDKs, REST/GraphQL calls, dry-run modes, or lower-level tools.
- Version-specific, preview, experimental, deprecated, or host-specific behavior.

For each important claim, either verify it or mark it as something to verify before relying on it. Do not invent flags, JSON fields, defaults, or safety behavior.

## Grilling requirements

Before writing the final skill, invoke `grilling` and interview the user one decision at a time.

Rules for the grilling phase:

- Ask one question at a time.
- Provide your recommended answer with every question.
- Ask decisions, not facts that can be retrieved.
- Walk dependencies in order: purpose before scope, scope before sections, danger policy before examples.
- Do not write the final `SKILL.md` until the user confirms shared understanding.

Good decision questions:

- Should this skill be narrow to one CLI or reusable across a family of tools?
- Should destructive commands be documented, forbidden, or gated behind confirmation?
- Should the skill prefer typed CLI commands, raw API calls, SDKs, or a fallback hierarchy?
- Which workflows are in scope, and which adjacent workflows should route to other skills?

Bad decision questions:

- What does `tool --help` print?
- Does this CLI support JSON output?
- What is the default page size?
- Which environment variable stores the token?

Retrieve those facts instead.

## Design brief

After grilling, write a short design brief before drafting the final skill. Keep it compact, but make every decision explicit.

Use this shape:

```markdown
## Design Brief

- Skill name:
- Target CLI or CLI family:
- Intended users or agents:
- Trigger phrases:
- In scope:
- Out of scope:
- Required reference sections:
- Danger policy:
- Preferred output and parsing modes:
- Fallback hierarchy:
- Evidence sources:
- Verification checklist:
```

The design brief is the contract for the `SKILL.md`. If the draft starts diverging from it, stop and ask the user whether the brief should change.

## Reference-style skill anatomy

Model the final skill after a dense reference like `gh`, not a broad tutorial.

Use this default structure:

```markdown
---
name: cli-name-or-skill-name
description: Use when... Include concrete trigger words and boundaries.
---

# Reference

## Topic or risk area

Short principle paragraph.

- Actionable rule.
- Exact flag or command pattern.
- Caveat, limit, or exception.
- Example or counterexample when it prevents a likely mistake.
```

Prefer topic sections over chronological lessons. Put high-frequency agent rules first: non-interactive use, structured output, pagination, targeting, search/list semantics, auth, dangerous commands, and fallback APIs.

A strong section usually contains:

- The default behavior agents should assume.
- The flag or command that makes automation safe.
- The common wrong command and why it fails.
- The edge case that changes the advice.
- The version or preview caveat when relevant.

## Writing rules

Write for future agents operating in terminals.

- Be concise and operational.
- Use exact commands, flags, field names, and output modes.
- Prefer bullets and small examples over long explanations.
- Include counterexamples for parsing, quoting, filtering, paging, or targeting mistakes.
- State when a command mutates local files, remote state, credentials, context, or deployments.
- Mark irreversible or externally visible operations clearly.
- Route adjacent work to a better tool or skill when appropriate.
- Keep official docs and `--help` as sources of truth for version-sensitive syntax.

Do not copy the full manual. Include only what helps an agent choose and invoke the CLI correctly.

## Quality gate

Before finishing, verify the skill against this checklist:

- Frontmatter has `name` and a trigger-rich `description` beginning with `Use when` or equivalent.
- The skill has clear in-scope and out-of-scope boundaries.
- Key claims are backed by retrieved docs, help output, or explicit verification.
- Non-interactive behavior is covered.
- Structured output and parsing are covered if the CLI supports them.
- Pagination, truncation, or result limits are covered if the CLI lists resources.
- Targeting context is covered if commands depend on repo, cluster, account, region, project, namespace, or config.
- Authentication and environment behavior are covered when relevant.
- Dangerous commands and side effects are named.
- Fallback paths are described for data the typed CLI cannot expose.
- Examples are exact enough to run or adapt.
- The content is a reference, not a tutorial or full docs mirror.

## Anti-patterns

Avoid these failures:

- Writing from memory because the CLI is familiar.
- Asking the user for facts that `--help` or docs can answer.
- Skipping `grilling` and guessing the scope.
- Producing a template with placeholders instead of an opinionated reference.
- Copying the whole man page.
- Omitting non-interactive behavior.
- Omitting machine-readable output rules.
- Omitting pagination or silent truncation.
- Documenting destructive commands without a danger policy.
- Treating unverifiable behavior as fact.
- Registering or publishing a skill before checking its frontmatter and installability.
