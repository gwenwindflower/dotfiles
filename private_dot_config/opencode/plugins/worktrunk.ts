import type { Plugin } from "@opencode-ai/plugin";

export default (async ({ $ }) => {
	return {
		event: async ({ event }) => {
			switch (event.type) {
				case "session.status":
					await $`wt config state marker set ${"🤖"} || true`.quiet();
					break;
				case "session.idle":
					await $`wt config state marker set ${"💬"} || true`.quiet();
					break;
				case "session.deleted":
					await $`wt config state marker clear || true`.quiet();
					break;
			}
		},
	};
}) satisfies Plugin;
