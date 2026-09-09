import { readdir } from "node:fs/promises";
import { dirname, join } from "node:path";
import { pathToFileURL } from "node:url";
import { createEmulator } from "emulate";

const apiEntry = new URL(import.meta.resolve("emulate")).pathname;
const distDir = join(dirname(dirname(apiEntry)), "dist");

let githubChunk;
for (const entry of await readdir(distDir)) {
  if (!entry.endsWith(".js")) continue;
  const mod = await import(pathToFileURL(join(distDir, entry)).href);
  if (mod.githubPlugin) {
    githubChunk = mod;
    break;
  }
}
if (!githubChunk) throw new Error("github plugin chunk not found");

let store;
const originalSeed = githubChunk.githubPlugin.seed;
githubChunk.githubPlugin.seed = (seedStore, baseUrl) => {
  store = seedStore;
  originalSeed?.(seedStore, baseUrl);
};

await createEmulator({
  service: "github",
  port: 4010,
  seed: {
    github: {
      users: [{ login: "admin", name: "Admin" }],
      repos: [
        { owner: "admin", name: "hello-world", auto_init: true, default_branch: "main" }
      ]
    }
  }
});

const gh = githubChunk.getGitHubStore(store);
const repo = gh.repos.findOneBy("full_name", "admin/hello-world");
gh.workflows.insert({
  node_id: "workflow-node",
  repo_id: repo.id,
  name: "CI",
  path: ".github/workflows/ci.yml",
  state: "active"
});

console.log("READY");

process.on("SIGTERM", () => process.exit(0));
process.on("SIGINT", () => process.exit(0));
