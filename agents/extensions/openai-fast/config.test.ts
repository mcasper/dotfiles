import assert from "node:assert/strict";
import { existsSync, mkdirSync, mkdtempSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { describe, it } from "node:test";
import { parseSupportedModelKey, resolveFastConfig } from "./config.js";

describe("openai-fast config", () => {
	it("uses the global config as canonical for persisted state and project config for supported models", () => {
		const root = mkdtempSync(join(tmpdir(), "openai-fast-config-"));
		const cwd = join(root, "project");
		const homeDir = join(root, "home");

		mkdirSync(join(homeDir, ".pi", "agent"), { recursive: true });
		mkdirSync(join(cwd, ".pi", "extensions"), { recursive: true });

		writeFileSync(
			join(homeDir, ".pi", "agent", "openai-fast.json"),
			JSON.stringify({
				persistState: false,
				active: false,
				supportedModels: ["openai/gpt-5.4"],
			}),
		);
		writeFileSync(
			join(cwd, ".pi", "extensions", "openai-fast.json"),
			JSON.stringify({
				persistState: true,
				active: true,
				supportedModels: ["openai/gpt-5.5"],
			}),
		);

		const config = resolveFastConfig(cwd, homeDir);

		assert.equal(config.persistState, false);
		assert.equal(config.active, false);
		assert.deepEqual(config.supportedModels, [{ provider: "openai", id: "gpt-5.5" }]);
	});

	it("parses provider/model keys and rejects invalid entries", () => {
		assert.deepEqual(parseSupportedModelKey("openai/gpt-5.4"), {
			provider: "openai",
			id: "gpt-5.4",
		});
		assert.equal(parseSupportedModelKey("bad"), undefined);
	});

	it("creates the global config file and falls back to default supported models", () => {
		const root = mkdtempSync(join(tmpdir(), "openai-fast-defaults-"));
		const cwd = join(root, "project");
		const homeDir = join(root, "home");
		const globalConfigPath = join(homeDir, ".pi", "agent", "openai-fast.json");

		mkdirSync(cwd, { recursive: true });

		const config = resolveFastConfig(cwd, homeDir);

		assert.equal(existsSync(globalConfigPath), true);
		assert.deepEqual(config.supportedModels, [
			{ provider: "openai", id: "gpt-5.4" },
			{ provider: "openai-codex", id: "gpt-5.4" },
			{ provider: "openai-codex", id: "gpt-5.5" },
		]);
		assert.deepEqual(JSON.parse(readFileSync(globalConfigPath, "utf8")), {
			persistState: true,
			active: false,
			supportedModels: ["openai/gpt-5.4", "openai-codex/gpt-5.4", "openai-codex/gpt-5.5"],
		});
	});
});
