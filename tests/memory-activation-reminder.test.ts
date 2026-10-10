import { expect, test } from "bun:test";
import { MemoryActivationReminderPlugin } from "../opencode/plugins/memory-activation-reminder/index";

function skillEvent(sessionID: string, callID: string, name: string) {
  return {
    type: "message.part.updated",
    properties: {
      sessionID,
      part: {
        type: "tool",
        sessionID,
        callID,
        tool: "skill",
        state: { status: "completed", input: { name } },
      },
    },
  };
}

test("reminds after task skill when memory activation is missing", async () => {
  const toasts: Array<{ title: string; message: string; variant: string }> = [];
  const logs: Array<{ service: string; level: string; message: string; sessionID: string }> = [];
  const client = {
    app: { log: async ({ body }: { body: any }) => { logs.push(body); return {}; } },
    tui: { showToast: async ({ body }: { body: any }) => { toasts.push(body); return {}; } },
  };
  const plugin = await MemoryActivationReminderPlugin({ client } as any);

  await plugin.event?.({ event: skillEvent("session-1", "skill-1", "create-github-pr") as any });
  await plugin["tool.execute.before"]?.({ sessionID: "session-1", tool: "bash" } as any, {} as any);

  expect(toasts).toHaveLength(1);
  expect(toasts[0]).toMatchObject({ title: "Memory activation", variant: "warning" });
  expect(toasts[0].message).toContain("create-github-pr");
  expect(logs).toHaveLength(1);
  expect(logs[0].service).toBe("memory-activation-reminder");
});

test("does not remind when memory activation skill clears pending state", async () => {
  const toasts: any[] = [];
  const client = {
    app: { log: async () => ({}) },
    tui: { showToast: async ({ body }: { body: any }) => { toasts.push(body); return {}; } },
  };
  const plugin = await MemoryActivationReminderPlugin({ client } as any);

  await plugin.event?.({ event: skillEvent("session-2", "skill-1", "review-pr") as any });
  await plugin.event?.({ event: skillEvent("session-2", "skill-2", "memory-activation") as any });
  await plugin["tool.execute.before"]?.({ sessionID: "session-2", tool: "bash" } as any, {} as any);

  expect(toasts).toEqual([]);
});

test("injects one agent-visible system reminder for pending task skill", async () => {
  const client = {
    app: { log: async () => ({}) },
    tui: { showToast: async () => ({}) },
  };
  const plugin = await MemoryActivationReminderPlugin({ client } as any);
  const output = { system: [] as string[] };

  await plugin.event?.({ event: skillEvent("session-6", "skill-1", "custom-opencode") as any });
  await plugin["experimental.chat.system.transform"]?.({ sessionID: "session-6" } as any, output as any);
  await plugin["experimental.chat.system.transform"]?.({ sessionID: "session-6" } as any, output as any);

  expect(output.system).toHaveLength(1);
  expect(output.system[0]).toContain("[Memory activation reminder]");
  expect(output.system[0]).toContain("custom-opencode");
});

test("does not inject after memory activation clears pending state", async () => {
  const client = {
    app: { log: async () => ({}) },
    tui: { showToast: async () => ({}) },
  };
  const plugin = await MemoryActivationReminderPlugin({ client } as any);
  const output = { system: [] as string[] };

  await plugin.event?.({ event: skillEvent("session-7", "skill-1", "custom-opencode") as any });
  await plugin.event?.({ event: skillEvent("session-7", "skill-2", "memory-activation") as any });
  await plugin["experimental.chat.system.transform"]?.({ sessionID: "session-7" } as any, output as any);

  expect(output.system).toEqual([]);
});

test("skips memory and reference skills", async () => {
  const toasts: any[] = [];
  const client = {
    app: { log: async () => ({}) },
    tui: { showToast: async ({ body }: { body: any }) => { toasts.push(body); return {}; } },
  };
  const plugin = await MemoryActivationReminderPlugin({ client } as any);

  await plugin.event?.({ event: skillEvent("session-3", "skill-1", "memory-discipline") as any });
  await plugin["tool.execute.before"]?.({ sessionID: "session-3", tool: "bash" } as any, {} as any);
  await plugin.event?.({ event: skillEvent("session-3", "skill-2", "agentmemory-mcp-tools") as any });
  await plugin["tool.execute.before"]?.({ sessionID: "session-3", tool: "bash" } as any, {} as any);

  expect(toasts).toEqual([]);
});

test("reminds only once per pending skill load", async () => {
  const toasts: any[] = [];
  const client = {
    app: { log: async () => ({}) },
    tui: { showToast: async ({ body }: { body: any }) => { toasts.push(body); return {}; } },
  };
  const plugin = await MemoryActivationReminderPlugin({ client } as any);

  await plugin.event?.({ event: skillEvent("session-4", "skill-1", "issue-from-idea") as any });
  await plugin["tool.execute.before"]?.({ sessionID: "session-4", tool: "read" } as any, {} as any);
  await plugin["tool.execute.before"]?.({ sessionID: "session-4", tool: "bash" } as any, {} as any);

  expect(toasts).toHaveLength(1);
});

test("allows memory recall tools before the reminder fires", async () => {
  const toasts: any[] = [];
  const client = {
    app: { log: async () => ({}) },
    tui: { showToast: async ({ body }: { body: any }) => { toasts.push(body); return {}; } },
  };
  const plugin = await MemoryActivationReminderPlugin({ client } as any);

  await plugin.event?.({ event: skillEvent("session-5", "skill-1", "custom-opencode") as any });
  await plugin["tool.execute.before"]?.({ sessionID: "session-5", tool: "agentmemory_memory_lesson_recall" } as any, {} as any);
  expect(toasts).toEqual([]);
  await plugin["tool.execute.before"]?.({ sessionID: "session-5", tool: "bash" } as any, {} as any);
  expect(toasts).toHaveLength(1);
});
