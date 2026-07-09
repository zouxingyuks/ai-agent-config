#!/usr/bin/env bash

# Refresh the global skills index before installing pinned favorites.
npx skills update -g

# Core discovery skill used to find and manage additional skills.
npx skills add --agent opencode -g https://github.com/vercel-labs/skills --skill find-skills -y

# Design documentation.
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill grill-me -y
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill grill-with-docs -y
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill grilling -y
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill handoff -y
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill domain-modeling -y
npx skills add --agent opencode -g https://github.com/spillwavesolutions/design-doc-mermaid --skill design-doc-mermaid -y

# Workflow and architecture helpers.
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill improve-codebase-architecture -y
npx skills add --agent opencode -g https://github.com/github/awesome-copilot --skill refactor -y

# Personal or project-specific skills.
npx skills add --agent opencode -g https://github.com/infituit/skills -y
npx skills add --agent opencode -g https://github.com/zouxingyuks/ai-agent-config -y

# Language-specific skill packs.
## Go
npx skills add --agent opencode -g https://github.com/samber/cc-skills-golang -y

## Python
npx skills add --agent opencode -g https://github.com/wshobson/agents --skill python-design-patterns -y

# Github
npx skills add --agent opencode -g https://github.com/xixu-me/skills --skill github-actions-docs -y

## Cli Docs
npx skills add --agent opencode -g https://github.com/cli/cli/tree/trunk --skill gh -y
npx skills add --agent opencode -g https://github.com/microsoft/playwright-cli --skill playwright-cli -y

# Show the final global skill set for OpenCode.
npx skills ls --agent opencode -g -y