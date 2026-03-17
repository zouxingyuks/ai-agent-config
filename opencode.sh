#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${TARGET_DIR:-$HOME/.config/opencode}"
EXTRA_FILES_VALUE="${EXTRA_FILES:-}"

FILES=("AGENTS.md" "AGENTS-compression-guide.md")
if [[ -n "${EXTRA_FILES_VALUE}" ]]; then
  # shellcheck disable=SC2206
  EXTRA_FILES_ARRAY=(${EXTRA_FILES_VALUE})
  FILES+=("${EXTRA_FILES_ARRAY[@]}")
fi

link_opencode_configs() {
  local opencode_dir="./opencode"

  if [[ ! -d "${opencode_dir}" ]]; then
    return
  fi

  shopt -s nullglob
  local jsonc_files=("${opencode_dir}"/*.jsonc)
  shopt -u nullglob

  local f
  for f in "${jsonc_files[@]}"; do
    ln -sfn "$(realpath "${f}")" "${TARGET_DIR}/$(basename "${f}")"
  done
}

link() {
  mkdir -p "${TARGET_DIR}"

  local f
  for f in "${FILES[@]}"; do
    if [[ -e "${f}" ]]; then
      ln -sfn "$(realpath "${f}")" "${TARGET_DIR}/$(basename "${f}")"
    fi
  done

  link_opencode_configs
}

backup() {
  echo "backup not implemented yet"
}

usage() {
  cat <<'EOF'
Usage: ./opencode.sh <command>

Commands:
  link      Create/update symlinks in TARGET_DIR
  backup    Placeholder command (not implemented)

Environment variables:
  TARGET_DIR   Default: ~/.config/opencode
  EXTRA_FILES  Optional space-separated extra files to link
EOF
}

main() {
  local cmd="${1:-}"

  case "${cmd}" in
    link)
      link
      ;;
    backup)
      backup
      ;;
    -h|--help|help)
      usage
      ;;
    "")
      usage
      exit 1
      ;;
    *)
      echo "Unknown command: ${cmd}" >&2
      usage
      exit 1
      ;;
  esac
}

main "$@"

