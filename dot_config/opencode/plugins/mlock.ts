// mlock plugin for opencode: the bash tool cooperates with the machine
// lock the same way Claude Code's PreToolUse hook does.
//
// Every bash call goes through ~/.local/bin/mlock-hook with the hook's
// stdin shape, so the one heavy-command grammar lives in the hook and a
// deny there is a deny here: the call is refused with the hook's reason
// and the model wraps the command in `mlock run` / `mlock quiet`.
//
// A bash call that names no timeout gets a default sized for heavy work
// that may first wait for a quiet run to finish. opencode's own default
// is two minutes, which kills a waiting `mlock run` long before its turn.
import type { Plugin } from "@opencode-ai/plugin"
import { spawnSync } from "node:child_process"
import { homedir } from "node:os"
import { join } from "node:path"

const HOOK = join(homedir(), ".local", "bin", "mlock-hook")
const DEFAULT_TIMEOUT_MS = 30 * 60 * 1000

export const MlockPlugin: Plugin = async () => ({
  "tool.execute.before": async (input, output) => {
    if (input.tool !== "bash") return
    const args = output.args ?? (output.args = {})
    if (args.timeout === undefined || args.timeout === null) args.timeout = DEFAULT_TIMEOUT_MS
    const command = typeof args.command === "string" ? args.command : ""
    if (!command) return
    const probe = spawnSync(HOOK, [], {
      input: JSON.stringify({ tool_name: "Bash", tool_input: { command } }),
      encoding: "utf8",
      timeout: 15_000,
    })
    // A missing or broken hook admits the command: the gate never bricks
    // the session.
    if (probe.error || probe.status !== 0 || !probe.stdout.trim()) return
    let verdict: any
    try {
      verdict = JSON.parse(probe.stdout)
    } catch {
      return
    }
    const out = verdict?.hookSpecificOutput
    if (out?.permissionDecision === "deny") {
      throw new Error(`mlock: ${out.permissionDecisionReason}`)
    }
  },
})
