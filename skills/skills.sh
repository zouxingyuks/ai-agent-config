#!/usr/bin/env bash

# Refresh the global skills index before installing pinned favorites.
npx skills update -g

# Core discovery skill used to find and manage additional skills.
npx skills add --agent opencode -g https://github.com/vercel-labs/skills --skill find-skills -y

# Design documentation.
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill grill-me -y
npx skills add --agent opencode -g https://github.com/spillwavesolutions/design-doc-mermaid --skill design-doc-mermaid -y

# Workflow and architecture helpers.
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill improve-codebase-architecture -y
npx skills add --agent opencode -g https://github.com/github/awesome-copilot --skill refactor -y

# Personal or project-specific skills.
npx skills add --agent opencode -g https://github.com/zouxingyuks/skills --skill skill-retrospective -y

# Language-specific skill packs.
## Go
npx skills add --agent opencode -g https://github.com/samber/cc-skills-golang -y

## Python
npx skills add --agent opencode -g https://github.com/wshobson/agents --skill python-design-patterns -y

# Show the final global skill set for OpenCode.
npx skills ls --agent opencode -g -y