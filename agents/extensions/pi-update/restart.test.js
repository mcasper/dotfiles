const assert = require("node:assert/strict");
const { test } = require("node:test");

const { getRestartCommand, performUpdate, createUpdateHandler } = require("./restart");

test("getRestartCommand uses node argv", () => {
  const result = getRestartCommand(["node", "/usr/local/bin/pi", "-c", "--model", "foo"]);

  assert.deepEqual(result, {
    command: "node",
    args: ["/usr/local/bin/pi", "-c", "--model", "foo"],
  });
});

test("getRestartCommand falls back to pi when argv is too short", () => {
  assert.deepEqual(getRestartCommand([]), { command: "pi", args: [] });
  assert.deepEqual(getRestartCommand(["node"]), { command: "pi", args: [] });
});

test("performUpdate skips restart when npm install fails", async () => {
  const calls = {
    spawn: 0,
    shutdown: 0,
  };

  const result = await performUpdate({
    argv: ["node", "/usr/local/bin/pi"],
    cwd: "/tmp",
    env: { PATH: "/bin" },
    exec: async () => ({ code: 1, stdout: "oops", stderr: "boom" }),
    spawn: () => {
      calls.spawn += 1;
      return { unref: () => {} };
    },
    shutdown: () => {
      calls.shutdown += 1;
    },
  });

  assert.equal(result.success, false);
  assert.equal(result.stdout, "oops");
  assert.equal(result.stderr, "boom");
  assert.equal(calls.spawn, 0);
  assert.equal(calls.shutdown, 0);
});

test("performUpdate restarts pi after successful install", async () => {
  const calls = {
    spawn: [],
    shutdown: 0,
    unref: 0,
  };

  const result = await performUpdate({
    argv: ["node", "/usr/local/bin/pi", "--resume"],
    cwd: "/work",
    env: { PATH: "/bin" },
    exec: async () => ({ code: 0, stdout: "", stderr: "" }),
    spawn: (command, args, options) => {
      calls.spawn.push({ command, args, options });
      return {
        unref: () => {
          calls.unref += 1;
        },
      };
    },
    shutdown: () => {
      calls.shutdown += 1;
    },
  });

  assert.equal(result.success, true);
  assert.equal(calls.spawn.length, 1);
  assert.deepEqual(calls.spawn[0], {
    command: "node",
    args: ["/usr/local/bin/pi", "--resume"],
    options: {
      cwd: "/work",
      env: { PATH: "/bin" },
      stdio: "inherit",
      detached: true,
    },
  });
  assert.equal(calls.unref, 1);
  assert.equal(calls.shutdown, 1);
});

test("createUpdateHandler reports failure in UI", async () => {
  const calls = {
    notify: [],
    status: [],
    spawn: 0,
    shutdown: 0,
  };

  const handler = createUpdateHandler({
    argv: ["node", "/usr/local/bin/pi"],
    env: { PATH: "/bin" },
    exec: async () => ({ code: 1, stdout: "", stderr: "boom" }),
    spawn: () => {
      calls.spawn += 1;
      return { unref: () => {} };
    },
  });

  const ctx = {
    hasUI: true,
    cwd: "/tmp",
    ui: {
      notify: (message, level) => {
        calls.notify.push({ message, level });
      },
      setStatus: (key, value) => {
        calls.status.push({ key, value });
      },
    },
    shutdown: () => {
      calls.shutdown += 1;
    },
  };

  await handler("", ctx);

  assert.deepEqual(calls.notify, [
    { message: "Updating pi...", level: "info" },
    { message: "Update failed: boom", level: "error" },
  ]);
  assert.deepEqual(calls.status, [
    { key: "pi-update", value: "Updating pi..." },
    { key: "pi-update", value: undefined },
  ]);
  assert.equal(calls.spawn, 0);
  assert.equal(calls.shutdown, 0);
});

test("createUpdateHandler skips UI helpers when UI is unavailable", async () => {
  const calls = {
    spawn: 0,
    shutdown: 0,
  };

  const handler = createUpdateHandler({
    argv: ["node", "/usr/local/bin/pi"],
    env: { PATH: "/bin" },
    exec: async () => ({ code: 0, stdout: "", stderr: "" }),
    spawn: () => {
      calls.spawn += 1;
      return { unref: () => {} };
    },
  });

  const ctx = {
    hasUI: false,
    cwd: "/tmp",
    ui: {
      notify: () => {
        throw new Error("notify should not be called");
      },
      setStatus: () => {
        throw new Error("setStatus should not be called");
      },
    },
    shutdown: () => {
      calls.shutdown += 1;
    },
  };

  await handler("", ctx);

  assert.equal(calls.spawn, 1);
  assert.equal(calls.shutdown, 1);
});
