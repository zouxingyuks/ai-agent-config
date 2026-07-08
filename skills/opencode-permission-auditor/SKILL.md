---
name: opencode-permission-auditor
description: Audit and configure OpenCode permission rules for CLI commands, MCP tools, built-in tools, and agent-level permissions. Use when users ask to set, review, harden, or explain OpenCode allow/ask/deny permissions, bash command rules, MCP tool permissions, external_directory, read/glob/grep/list/edit/lsp/skill permissions, or tool safety policies in opencode.json/opencode.jsonc/OHMyOpenAgent configs.
---

# OpenCode Permission Auditor

Use this skill only for OpenCode permission configuration. Do not generalize to unrelated agent frameworks unless the user explicitly asks for a comparison.

The goal is safe, reviewable permission changes: make common low-risk work smooth, keep ordinary state-changing operations behind `ask`, and force high-risk operations to `deny` when appropriate.

## Non-negotiable workflow

1. **Calibrate against current OpenCode docs first**
   - Always read <https://opencode.ai/config.json> before analyzing or editing.
   - Also read the current OpenCode permissions docs when available.
   - Treat live docs/schema as authority over this skill. If docs and local assumptions differ, say so and follow the docs.
   - Confirm the active schema for `permission`, `PermissionActionConfig`, `PermissionObjectConfig`, `PermissionRuleConfig`, built-in permission keys, agent-level `permission`, and MCP configuration.

2. **Inventory local OpenCode config**
   - Search for `opencode.json`, `opencode.jsonc`, `oh-my-openagent.jsonc`, `.opencode/**`, and `AGENTS.md` guidance.
   - Inspect both top-level `permission` and `agent.<name>.permission` blocks.
   - Identify whether comments or existing ordering imply intentional policy.
   - Preserve unrelated edits and user/concurrent changes.

3. **Inventory the capability surface**
   - For CLI permissions, inspect help output for the target command and common subcommands, for example `<cli> -h` and `<cli> <subcommand> -h`.
   - For MCP/additional tools, list actual exposed tool names and classify each operation by effect.
   - Treat MCP tools as OpenCode tool-name permissions, commonly registered with the MCP server name as a prefix; verify actual names instead of guessing.
   - Use direct search plus code/config exploration. Do not stop at the first result.
   - For third-party CLIs or OpenCode behavior, consult official docs before relying on memory.

4. **Classify operations using the fixed model**
   - Default unknown or broad command/tool surface to `ask`.
   - Allow high-frequency read-only operations that do not mutate local files, remote resources, credentials, auth state, billing, secrets, or workflow execution.
   - Let ordinary mutating operations inherit `ask`; do not enumerate redundant `ask` rules when a broad fallback already covers them.
   - Deny high-risk operations, especially credential/token exposure, auth logout/destructive auth changes, irreversible deletes, force/destructive git-style actions, secret exfiltration, key deletion, broad prune/purge operations, or commands that can bypass the intended permission model.
   - Record any user-requested exception as an explicit **Special Allow** with rationale.

5. **Respect OpenCode rule semantics**
   - `permission` may be a single action or an object of tool-specific rules.
   - Tool rules may be a single action or pattern-to-action object.
   - Pattern rules are order-sensitive; OpenCode docs state the last matching rule takes precedence.
   - Put broad fallbacks before specific overrides.
   - Put high-risk `deny` rules after broader `ask` or `allow` rules so they win.
   - Prefer exact patterns for sensitive commands when a wildcard variant could expose more than intended.
   - Include both bare-command and argument forms when OpenCode glob semantics require it, for example `cmd` plus `cmd *`, or a carefully verified `cmd*` only when that is safe.

## OpenCode permission surfaces to check

Prioritize CLI and MCP/tool permissions, but audit all relevant OpenCode permission surfaces:

- `permission` at config top level.
- `agent.<name>.permission` for subagents and primary agents.
- `bash` command rules.
- Additional tool keys and MCP-derived tool names via schema `additionalProperties`.
- Built-in tool permissions: `read`, `glob`, `grep`, `list`, `edit`, `task`, `external_directory`, `todowrite`, `question`, `webfetch`, `websearch`, `lsp`, `skill`, `doom_loop`, and any current schema additions.
- Deprecated `tools` fields only as migration context; prefer `permission` when supported by schema.

## Required permission audit package

Before editing, output a concise audit package and wait for user confirmation unless the user already explicitly authorized editing after seeing the package.

Include:

1. **Docs/schema calibration**
   - What schema/docs were read.
   - Current permission keys and rule shapes relevant to the task.
   - Any version-sensitive findings.

2. **Local policy inventory**
   - Files and permission blocks found.
   - Existing broad defaults and notable overrides.
   - Existing comments or conventions that must be preserved.

3. **Capability inventory**
   - CLI subcommands or MCP/tools inspected.
   - Operations grouped by read-only, ordinary mutating, high-risk, and unknown.

4. **Proposed policy**
   - Broad default rule, usually `ask` for unknown surface.
   - Explicit `allow` rules for safe high-frequency read-only operations.
   - Special Allow rules requested by the user, with rationale.
   - High-risk `deny` rules ordered after broader rules.
   - Redundant rules intentionally omitted because they inherit from fallback.

5. **Patch plan**
   - Exact files to edit.
   - Where rules will be inserted or replaced.
   - Ordering rationale, especially for last-match precedence.

6. **Verification matrix**
   - Representative examples expected to resolve to `allow`.
   - Representative examples expected to resolve to `ask`.
   - Representative examples expected to resolve to `deny`.
   - Bare command and with-argument cases when patterns differ.

## Editing rules

Only edit after the user confirms the audit package or has already clearly authorized confirmed editing.

When editing:

- Make the smallest surgical change.
- Keep existing formatting, comments, grouping, and ordering style.
- Do not add long lists of `ask` rules when a fallback already covers them.
- Prefer adding clear comments only when they explain a non-obvious security or precedence decision.
- Do not weaken existing denials unless the user explicitly requests it and the audit package calls out the risk.
- Do not broaden read/edit/external directory access while working on CLI/MCP permissions unless required and confirmed.

## Mandatory verification gate

A permission change is not complete until all applicable checks pass:

1. **Schema/JSONC diagnostics**
   - Run diagnostics or an equivalent parser/schema check on changed config files.

2. **Diff hygiene**
   - Run a whitespace/config diff check when available.
   - Confirm the diff contains only intended permission changes.

3. **Last-match simulation**
   - Simulate OpenCode pattern matching for the changed rule set.
   - Verify every example in the audit package resolves to the expected action.
   - Include fallback, explicit allow, Special Allow, ordinary ask, and high-risk deny examples.

4. **Surface smoke test**
   - If safe, run harmless allowed CLI commands such as help, status, view, or list commands.
   - Do not run mutating or denied commands just to test them; simulate those instead.

5. **Report residual risk**
   - Mention any unknown OpenCode behavior, undocumented tool naming, schema ambiguity, or pre-existing config issue.

If any verification fails, fix the rule or stop with the exact blocker. Do not deliver unverified permission changes.

## Classification guide

Usually safe to consider for `allow` when confirmed read-only:

- Help/version/status commands.
- Search, view, list, diff, checks, inspect, describe, get, config get/list, key list, secret name list when values are not revealed.
- Documentation or metadata queries.

Usually keep as `ask` through fallback:

- Create, edit, update, enable, disable, run, rerun, cancel, download, upload, clone, fork, install, upgrade, remove, login, refresh, configure, sync, checkout, watch, exec.
- Any command that writes local files, changes remote state, starts jobs, changes auth/config, or may incur cost.

Usually force `deny`:

- Token printing or credential export.
- Secret value reads or broad secret access.
- Logout or destructive auth changes when they would break the environment.
- Delete/archive/purge/prune/destroy operations.
- Key deletion and credential deletion.
- Force push, hard reset, recursive destructive filesystem operations, or equivalents.
- Raw API escape hatches that can perform arbitrary methods, unless constrained and confirmed.

## Common mistakes

- Trusting stale memory instead of reading OpenCode `config.json`.
- Forgetting agent-level permissions when top-level permissions look safe.
- Adding many explicit `ask` rules that are already covered by a fallback.
- Placing `deny` before a later broad `allow`, making the deny ineffective.
- Allowing wildcard variants of sensitive commands, such as auth/token commands with flags.
- Testing only commands with arguments and missing bare-command behavior.
- Treating MCP tool names as obvious without listing the actual exposed tools.
- Weakening read/glob/grep/list secret protections while focusing on bash rules.
