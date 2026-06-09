|IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning

|Must use: sequential-thinking in all time.
|Core Tools: always use this tools|serena (semantic code ops)|context7 (3rd-party docs)|sequential-thinking (decisions)
|Language Policy:Chinese for main|English for proper nouns and notes
|Compression Rule:Follow ~/.config/opencode/AGENTS-compression-guide.md (pipe-index format, concise, no prose/code blocks)
|Memory Policy:session-start→search_nodes for relevant user/project context before acting|Store: key decisions, user preferences, learned patterns, architecture insights|Entity types: preference, decision, pattern, concept, project, convention|Link entities via create_relations (active voice)|Update via add_observations when facts evolve, don't duplicate|Read-before-write: search_nodes before create to avoid duplicates
|MCP Policy:retry on failure|analyze error and adjust params|never skip or abandon
|Think Before Coding:state assumptions before implementation|if multiple interpretations present options|ask only when materially unclear|surface tradeoffs and simpler alternatives
|Simplicity First:minimum code that solves request|no speculative features/abstractions/configurability|rewrite if overcomplicated
|Surgical Changes:touch only required lines|match existing style|no unrelated cleanup/refactor|remove only orphans created by own changes
|Goal-Driven Execution:define verifiable success criteria|for multi-step tasks use brief plan with checks|loop until verified through requested surface
