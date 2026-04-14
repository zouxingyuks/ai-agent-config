|IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning

|Must use: sequential-thinking in all time.
|Core Tools: always use this tools|serena (semantic code ops)|context7 (3rd-party docs)|sequential-thinking (decisions)
|Language Policy:Chinese for main|English for proper nouns and notes
|Compression Rule:Follow ~/.config/opencode/AGENTS-compression-guide.md (pipe-index format, concise, no prose/code blocks)
|Memory Policy:session-start→search_nodes for relevant user/project context before acting|Store: key decisions, user preferences, learned patterns, architecture insights|Entity types: preference, decision, pattern, concept, project, convention|Link entities via create_relations (active voice)|Update via add_observations when facts evolve, don't duplicate|Read-before-write: search_nodes before create to avoid duplicates
