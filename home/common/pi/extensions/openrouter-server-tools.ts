import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

interface OpenRouterRequest {
  model?: unknown;
  tools?: unknown;
  [key: string]: unknown;
}

export default function (pi: ExtensionAPI) {
  pi.on("before_provider_request", (event, ctx) => {
    const payload = event.payload as OpenRouterRequest;
    if (ctx.model.provider !== "openrouter") return;

    const tools = Array.isArray(payload.tools) ? payload.tools : [];
    const configuredTypes = new Set(
      tools.flatMap((tool) =>
        typeof tool === "object" && tool !== null && "type" in tool && typeof tool.type === "string"
          ? [tool.type]
          : [],
      ),
    );
    const serverTools = [
      ...(!configuredTypes.has("openrouter:web_search")
        ? [{ type: "openrouter:web_search", parameters: { engine: "auto", max_uses: 5 } }]
        : []),
      ...(!configuredTypes.has("openrouter:web_fetch")
        ? [{ type: "openrouter:web_fetch", parameters: { engine: "auto", max_uses: 5 } }]
        : []),
    ];
    if (serverTools.length === 0) return;

    return {
      ...payload,
      tools: [
        ...tools,
        ...serverTools,
      ],
      max_tool_calls: 10,
    };
  });
}
