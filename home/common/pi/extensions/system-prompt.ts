import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function getClipboardCommand(): string {
  switch (process.platform) {
    case "darwin":
      return "pbcopy";
    case "linux":
      return "wl-copy";
    default:
      throw new Error(`Clipboard copying is unsupported on ${process.platform}`);
  }
}

function copyToClipboard(text: string): Promise<void> {
  const command = getClipboardCommand();

  return new Promise((resolve, reject) => {
    const child = spawn(command, [], { stdio: ["pipe", "ignore", "pipe"] });
    let stderr = "";

    child.stderr.setEncoding("utf8");
    child.stderr.on("data", (chunk: string) => {
      stderr += chunk;
    });
    child.on("error", reject);
    child.stdin.on("error", reject);
    child.on("close", (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`${command} failed${stderr.trim() ? `: ${stderr.trim()}` : ""}`));
      }
    });

    child.stdin.end(text, "utf8");
  });
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("system-prompt", {
    description: "Copy Pi's current effective system prompt to the clipboard",
    handler: async (_args, ctx) => {
      try {
        await copyToClipboard(ctx.getSystemPrompt());
        if (ctx.hasUI) {
          ctx.ui.notify("Copied system prompt to clipboard", "info");
        }
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        if (ctx.hasUI) {
          ctx.ui.notify(`Failed to copy system prompt: ${message}`, "error");
        } else {
          throw error;
        }
      }
    },
  });
}
