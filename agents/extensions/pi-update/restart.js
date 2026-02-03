const NPM_INSTALL_COMMAND = "npm";
const NPM_INSTALL_ARGS = ["install", "-g", "@mariozechner/pi-coding-agent"];
const FALLBACK_COMMAND = "pi";
const STATUS_KEY = "pi-update";
const MAX_ERROR_LENGTH = 200;

function getRestartCommand(argv) {
  if (!Array.isArray(argv) || argv.length < 2) {
    return { command: FALLBACK_COMMAND, args: [] };
  }

  return {
    command: argv[0],
    args: argv.slice(1),
  };
}

function formatErrorMessage(stdout, stderr) {
  const combined = [stderr, stdout]
    .map((value) => value.trim())
    .filter(Boolean)
    .join(" ")
    .replace(/\s+/g, " ");

  if (!combined) {
    return "Update failed.";
  }

  if (combined.length <= MAX_ERROR_LENGTH) {
    return `Update failed: ${combined}`;
  }

  return `Update failed: ${combined.slice(0, MAX_ERROR_LENGTH - 1)}…`;
}

async function performUpdate({ argv, cwd, env, exec, spawn, shutdown }) {
  const result = await exec(NPM_INSTALL_COMMAND, NPM_INSTALL_ARGS);
  const stdout = result?.stdout ?? "";
  const stderr = result?.stderr ?? "";

  if (!result || result.code !== 0) {
    return { success: false, stdout, stderr };
  }

  const { command, args } = getRestartCommand(argv);
  let child;

  try {
    child = spawn(command, args, {
      cwd,
      env,
      stdio: "inherit",
      detached: true,
    });
  } catch (error) {
    return {
      success: false,
      stdout,
      stderr: error instanceof Error ? error.message : String(error),
    };
  }

  if (child && typeof child.unref === "function") {
    child.unref();
  }

  shutdown();
  return { success: true };
}

function createUpdateHandler({ argv, env, exec, spawn }) {
  return async (_args, ctx) => {
    if (ctx.hasUI) {
      ctx.ui.notify("Updating pi...", "info");
      ctx.ui.setStatus(STATUS_KEY, "Updating pi...");
    }

    const result = await performUpdate({
      argv,
      cwd: ctx.cwd,
      env,
      exec,
      spawn,
      shutdown: () => ctx.shutdown(),
    });

    if (!result.success && ctx.hasUI) {
      ctx.ui.setStatus(STATUS_KEY, undefined);
      ctx.ui.notify(formatErrorMessage(result.stdout ?? "", result.stderr ?? ""), "error");
    }
  };
}

module.exports = {
  createUpdateHandler,
  getRestartCommand,
  performUpdate,
  NPM_INSTALL_ARGS,
};
