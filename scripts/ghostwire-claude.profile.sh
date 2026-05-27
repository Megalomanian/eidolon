[ -n "$BASH_VERSION" ] || return 0

# ---- Claude Code + DeepSeek Integration ----
export ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-https://api.deepseek.com/anthropic}"
export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-${DEEPSEEK_API_KEY}}"
export CLAUDE_AGENT_MODEL="${CLAUDE_AGENT_MODEL:-deepseek-v4-pro}"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="${CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC:-1}"

# Claude Code aliases
alias claude='claude'
alias cc='claude -p'

echo "[claude] Model: DeepSeek @ ${ANTHROPIC_BASE_URL}"
echo "[claude] Commands: claude (interactive), cc 'prompt' (one-shot)"
echo "[claude] Methodology: /opt/ghostwire-methodology.md | gw help"
