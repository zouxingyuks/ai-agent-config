#!/usr/bin/env bash

npx skills update -g
npx skills add --agent opencode -g https://github.com/vercel-labs/skills --skill find-skills -y
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill grill-me -y
npx skills add --agent opencode -g https://github.com/mattpocock/skills --skill improve-codebase-architecture
npx skills ls --agent opencode -g