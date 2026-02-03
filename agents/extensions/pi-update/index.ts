import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { spawn } from "node:child_process";

const { createUpdateHandler } = require("./restart");

export default function (pi: ExtensionAPI) {
	const handler = createUpdateHandler({
		argv: process.argv,
		env: process.env,
		exec: (command: string, args: string[]) => pi.exec(command, args),
		spawn,
	});

	pi.registerCommand("update", {
		description: "Update pi and restart",
		handler,
	});
}
