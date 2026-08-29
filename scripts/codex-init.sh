#!/usr/bin/env bash
set -euo pipefail

CODEX_DIR="${CODEX_HOME:-${HOME:?HOME is required when CODEX_HOME is not set}/.codex}"
CONFIG_FILE="${CODEX_DIR}/config.toml"

toml_escape() {
	local value="${1//\\/\\\\}"
	printf '%s' "${value//\"/\\\"}"
}

validate_env() {
	if [[ -z "${OPENAI_BASE_URL:-}" ]]; then
		echo "Error: OPENAI_BASE_URL is required." >&2
		echo "Set it before running this script, for example:" >&2
		echo "  export OPENAI_BASE_URL='http://127.0.0.1:8090/v1'" >&2
		exit 1
	fi

	if [[ -z "${OPENAI_AUTH_TOKEN:-}" ]]; then
		echo "Warning: OPENAI_AUTH_TOKEN is not set. Codex will read it from this environment variable when it runs." >&2
		echo "Set it before using Codex, for example:" >&2
		echo "  export OPENAI_AUTH_TOKEN='<your-axonhub-api-key>'" >&2
	fi
}

write_config() {
	local base_url
	base_url="$(toml_escape "${OPENAI_BASE_URL}")"

	mkdir -p "${CODEX_DIR}"

	cat >"${CONFIG_FILE}" <<EOF
model = "gpt-5"
model_provider = "axonhub-responses"

[model_providers.axonhub-responses]
name = "AxonHub using Responses API"
base_url = "${base_url}"
env_key = "OPENAI_AUTH_TOKEN"
wire_api = "responses"
query_params = {}
EOF

	echo "Codex config written to: ${CONFIG_FILE}"
}

usage() {
	cat <<'EOF'
Usage: ./scripts/codex-init.sh

Environment variables:
  CODEX_HOME          Default: ~/.codex
  OPENAI_BASE_URL     Required
  OPENAI_AUTH_TOKEN   Optional; Codex reads the token from this env var
EOF
}

main() {
	local cmd="${1:-}"

	case "${cmd}" in
	-h | --help | help)
		usage
		;;
	"")
		validate_env
		write_config
		;;
	*)
		echo "Unknown command: ${cmd}" >&2
		usage
		exit 1
		;;
	esac
}

main "$@"
