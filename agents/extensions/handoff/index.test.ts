import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { getEffectiveHandoffOptions } from "./lib/effective-options.js";
import { prepareToolHandoff } from "./lib/tool-path.js";

describe("handoff model preservation", () => {
	it("preserves the current model when no explicit mode or model is provided", () => {
		assert.deepEqual(
			getEffectiveHandoffOptions(undefined, "anthropic/claude-sonnet-4-6"),
			{ model: "anthropic/claude-sonnet-4-6" },
		);
	});

	it("does not override an explicit mode with the current model", () => {
		assert.deepEqual(
			getEffectiveHandoffOptions({ mode: "rush" }, "anthropic/claude-sonnet-4-6"),
			{ mode: "rush" },
		);
	});

	it("does not override an explicit model", () => {
		assert.deepEqual(
			getEffectiveHandoffOptions({ model: "anthropic/claude-haiku-4-5" }, "anthropic/claude-sonnet-4-6"),
			{ model: "anthropic/claude-haiku-4-5" },
		);
	});
});

describe("handoff tool", () => {
	it("prepares a /handoff command instead of switching sessions from the tool path", () => {
		let editorText = "";
		let notifications = 0;

		const result = prepareToolHandoff(
			{
				hasUI: true,
				ui: {
					setEditorText(text: string) {
						editorText = text;
					},
					notify() {
						notifications += 1;
					},
				},
			},
			{
				goal: "investigate the next bug",
				mode: "rush",
				model: "anthropic/claude-haiku-4-5",
			},
		);

		assert.equal(editorText, "/handoff -mode rush -model anthropic/claude-haiku-4-5 investigate the next bug");
		assert.equal(notifications, 1);
		assert.equal(result.details.ok, true);
		assert.match(result.content[0].text, /Submit it to create the new session safely\./);
	});
});
