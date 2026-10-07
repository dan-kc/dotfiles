import { spawnSync } from "node:child_process";
import { mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI, ToolInfo } from "@earendil-works/pi-coding-agent";

function structuredBlock(value: unknown): string {
  return `\`\`\`json\n${JSON.stringify(value, null, 2)}\n\`\`\``;
}

function renderContent(content: unknown): string {
  if (typeof content === "string") {
    return content;
  }
  if (!Array.isArray(content)) {
    return structuredBlock(content);
  }

  return content
    .map((item) => {
      if (!item || typeof item !== "object") {
        return structuredBlock(item);
      }

      const block = item as Record<string, unknown>;
      switch (block.type) {
        case "text":
          return String(block.text ?? "");
        case "thinking":
          return `#### Thinking\n\n${String(block.thinking ?? "")}`;
        case "toolCall":
          return [
            `#### Tool call: ${String(block.name ?? "unknown")}`,
            "",
            `ID: \`${String(block.id ?? "unknown")}\``,
            "",
            structuredBlock(block.arguments),
          ].join("\n");
        default:
          return structuredBlock(block);
      }
    })
    .join("\n\n");
}

function renderMessage(message: unknown, index: number): string {
  if (!message || typeof message !== "object") {
    return `## ${index + 1}. Unknown message\n\n${structuredBlock(message)}`;
  }

  const record = message as Record<string, unknown>;
  const role = String(record.role ?? "unknown");
  const heading =
    role === "toolResult"
      ? `## ${index + 1}. Tool result: ${String(record.toolName ?? "unknown")}`
      : `## ${index + 1}. ${role}`;
  const details: string[] = [];

  if (role === "toolResult") {
    details.push(`Call ID: \`${String(record.toolCallId ?? "unknown")}\``);
    if (record.isError === true) {
      details.push("Status: error");
    }
  }

  return [heading, ...details.map((detail) => `\n${detail}`), "", renderContent(record.content)].join("\n");
}

function renderTool(tool: ToolInfo): string {
  return [
    `### ${tool.name}`,
    "",
    tool.description,
    "",
    "Parameters:",
    "",
    structuredBlock(tool.parameters),
  ].join("\n");
}

function renderContext(systemPrompt: string, tools: ToolInfo[], messages: unknown[]): string {
  return [
    "# Pi model context",
    "",
    "> Human-readable projection of the current model context. Provider transport encoding and request headers are not included.",
    "",
    "## Effective system prompt",
    "",
    systemPrompt,
    "",
    "# Active tools",
    "",
    tools.length > 0 ? tools.map(renderTool).join("\n\n") : "(none)",
    "",
    "# Conversation",
    "",
    messages.length > 0 ? messages.map(renderMessage).join("\n\n") : "(no messages)",
    "",
  ].join("\n");
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("context", {
    description: "Open the complete current model context in Neovim",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") {
        throw new Error("/context requires Pi's interactive TUI");
      }

      const activeToolNames = new Set(pi.getActiveTools());
      const activeTools = pi.getAllTools().filter((tool) => activeToolNames.has(tool.name));
      const messages = ctx.sessionManager
        .buildSessionContext()
        .messages.filter((message) => message.role !== "system");
      const document = renderContext(ctx.getSystemPrompt(), activeTools, messages);
      const directory = await mkdtemp(join(tmpdir(), "pi-context-"));
      const file = join(directory, "context.md");

      try {
        await writeFile(file, document, "utf8");

        const result = await ctx.ui.custom<{ status: number | null; error?: string }>(
          (tui, _theme, _keybindings, done) => {
            tui.stop();
            process.stdout.write("\x1b[2J\x1b[H");

            const editor = process.env.EDITOR || "nvim";
            const child = (() => {
              try {
                return spawnSync(editor, ["-R", file], {
                  stdio: "inherit",
                  env: process.env,
                });
              } finally {
                tui.start();
                tui.requestRender(true);
              }
            })();

            done({
              status: child.status,
              ...(child.error ? { error: child.error.message } : {}),
            });

            return { render: () => [], invalidate: () => {} };
          },
        );

        if (result.error) {
          throw new Error(`Failed to start Neovim: ${result.error}`);
        }
        if (result.status !== 0) {
          throw new Error(`Neovim exited with status ${result.status ?? "unknown"}`);
        }
      } finally {
        await rm(directory, { recursive: true, force: true });
      }
    },
  });
}
