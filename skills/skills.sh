#!/usr/bin/env bash

npx skills update -g
npx skills add --agent opencode -g https://github.com/vercel-labs/skills --skill find-skills -y
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill grill-me -y
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill improve-codebase-architecture
npx skills add --agent opencode -g https://github.com/zouxingyuks/skills --skill skill-retrospective -y
npx skills add --agent opencode -g https://github.com/github/awesome-copilot --skill refactor -y
npx skills ls --agent opencode -g