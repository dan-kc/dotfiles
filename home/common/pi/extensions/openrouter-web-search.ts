import { Type } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const OPENROUTER_ENDPOINT = "https://openrouter.ai/api/v1/chat/completions";
const SEARCH_PROVIDER = "openrouter";
const SEARCH_MODEL = "x-ai/grok-4.7";
const REQUEST_TIMEOUT_MS = 120_000;

interface SearchSource {
  title: string;
  url: string;
}

interface SearchDetails {
  provider: typeof SEARCH_PROVIDER;
  model: typeof SEARCH_MODEL;
  searches?: number;
  sources: SearchSource[];
  error?: boolean;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function extractText(content: unknown): string {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";

  return content
    .map((part) => {
      if (!isRecord(part)) return "";
      if (typeof part.text === "string") return part.text;
      if (typeof part.content === "string") return part.content;
      return "";
    })
    .filter(Boolean)
    .join("\n");
}

function titleFromUrl(url: string): string {
  try {
    return new URL(url).hostname;
  } catch {
    return url;
  }
}

function extractSources(...collections: unknown[]): SearchSource[] {
  const sources = new Map<string, SearchSource>();

  for (const collection of collections) {
    if (!Array.isArray(collection)) continue;

    for (const item of collection) {
      if (typeof item === "string") {
        if (item.startsWith("http://") || item.startsWith("https://")) {
          sources.set(item, { title: titleFromUrl(item), url: item });
        }
        continue;
      }
      if (!isRecord(item)) continue;

      const citation = isRecord(item.url_citation) ? item.url_citation : item;
      const url = typeof citation.url === "string" ? citation.url : undefined;
      if (!url || (!url.startsWith("http://") && !url.startsWith("https://"))) continue;

      const title = typeof citation.title === "string" && citation.title.trim()
        ? citation.title.trim()
        : titleFromUrl(url);
      sources.set(url, { title, url });
    }
  }

  return [...sources.values()].slice(0, 20);
}

function appendSources(text: string, sources: SearchSource[]): string {
  const missing = sources.filter((source) => !text.includes(source.url));
  if (missing.length === 0) return text;

  const links = missing.map((source) => `- [${source.title}](${source.url})`).join("\n");
  return `${text}\n\nSources:\n${links}`;
}

async function getResponseError(response: Response): Promise<string> {
  const body = (await response.text()).slice(0, 2_000);
  try {
    const parsed: unknown = JSON.parse(body);
    if (isRecord(parsed) && isRecord(parsed.error) && typeof parsed.error.message === "string") {
      return parsed.error.message;
    }
  } catch {
    // Fall back to the bounded response body below.
  }
  return body || response.statusText;
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "web_search",
    label: "Web Search",
    description:
      "Search the live web with the dedicated OpenRouter x-ai/grok-4.7 model. Use for current, changing, niche, or source-dependent information.",
    promptSnippet: "Search the live web with Grok 4.7 through OpenRouter.",
    parameters: Type.Object({
      query: Type.String({ description: "The search query or question to research" }),
    }),

    async execute(_toolCallId, { query }, signal, onUpdate, ctx) {
      const details: SearchDetails = {
        provider: SEARCH_PROVIDER,
        model: SEARCH_MODEL,
        sources: [],
      };

      try {
        const model = ctx.modelRegistry.find(SEARCH_PROVIDER, SEARCH_MODEL);
        if (!model) {
          throw new Error(`Pi does not know the configured search model ${SEARCH_PROVIDER}/${SEARCH_MODEL}`);
        }

        const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
        if (!auth.ok) throw new Error(auth.error);

        const headers = new Headers(auth.headers);
        headers.set("Content-Type", "application/json");
        if (auth.apiKey && !headers.has("Authorization")) {
          headers.set("Authorization", `Bearer ${auth.apiKey}`);
        }
        if (!headers.has("Authorization")) {
          throw new Error("No OpenRouter credential is configured; use /login openrouter");
        }

        onUpdate?.({
          content: [{ type: "text", text: `Searching the web with ${SEARCH_MODEL}…` }],
          details,
        });

        const timeoutSignal = AbortSignal.timeout(REQUEST_TIMEOUT_MS);
        const requestSignal = signal ? AbortSignal.any([signal, timeoutSignal]) : timeoutSignal;
        const response = await fetch(OPENROUTER_ENDPOINT, {
          method: "POST",
          headers,
          signal: requestSignal,
          body: JSON.stringify({
            model: SEARCH_MODEL,
            messages: [
              {
                role: "system",
                content:
                  "You are a web research subagent. You must search the web before answering. Give a concise, factual answer with inline Markdown links to primary sources where possible.",
              },
              { role: "user", content: query },
            ],
            tools: [
              {
                type: "openrouter:web_search",
                parameters: { engine: "native" },
              },
            ],
            tool_choice: "required",
            max_tool_calls: 8,
            max_tokens: 4_096,
            stream: false,
          }),
        });

        if (!response.ok) {
          throw new Error(`OpenRouter returned HTTP ${response.status}: ${await getResponseError(response)}`);
        }

        const payload: unknown = await response.json();
        if (!isRecord(payload) || !Array.isArray(payload.choices) || !isRecord(payload.choices[0])) {
          throw new Error("OpenRouter returned an unexpected response");
        }

        const message = isRecord(payload.choices[0].message) ? payload.choices[0].message : undefined;
        const text = extractText(message?.content).trim();
        if (!text) throw new Error("OpenRouter returned no search answer");

        details.sources = extractSources(message?.annotations, message?.citations, payload.citations);
        if (isRecord(payload.usage) && isRecord(payload.usage.server_tool_use)) {
          const searchCount = payload.usage.server_tool_use.web_search_requests;
          if (typeof searchCount === "number") details.searches = searchCount;
        }

        return {
          content: [{ type: "text", text: appendSources(text, details.sources) }],
          details,
        };
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        return {
          content: [{ type: "text", text: `Web search failed: ${message}` }],
          details: { ...details, error: true },
        };
      }
    },
  });
}
