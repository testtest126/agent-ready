# agent-ready

*Drop-in conventions that make any repository ready for AI collaboration.*
<sub>working name — rename freely: `house-rules`, `the-pact`, `ai-collab-kit`</sub>

<p>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT license"></a>
  <a href="https://testtest126.github.io/agent-ready/"><img src="https://img.shields.io/badge/docs-deep%20dives-6cb6ff.svg" alt="Documentation"></a>
  <img src="https://img.shields.io/badge/dependencies-none-brightgreen.svg" alt="No dependencies">
</p>

A small, **context-free** kit of the practices for working well with AI agents on
code — distilled from real projects and generalized so it plugs into anything:
any language, any stack, any tool. No framework, no lock-in. Just an `AGENTS.md`,
a memory scaffold, tool adapters, and the principles behind them.

## Why

AI agents are only as good as the working agreement around them, and the same few
things go wrong everywhere: unverified "done," irreversible actions taken without
a yes, stale-green merges, and ceremony that never catches anything. This kit
encodes the fixes once, so each new repo doesn't relearn them the hard way.

## Quickstart

From inside your project:

```sh
path/to/agent-ready/install.sh .
```

Then open `AGENTS.md`, fill in the `<ANGLE-BRACKET>` blanks (build / test / run,
conventions), and delete the tool adapters you don't use. Commit it. Done — your
repo is agent-ready.

> The installer never overwrites an existing file; pass `--force` to replace.

## What's inside

- **`templates/AGENTS.md`** — the single source of truth for how agents work in
  your repo. The one file that matters. Tool-agnostic.
- **`templates/adapters/`** — thin pointers so Claude Code (`CLAUDE.md`), GitHub
  Copilot (`.github/copilot-instructions.md`), and Cursor (`.cursor/rules/`) all
  read that same `AGENTS.md`. Write your rules once.
- **`templates/memory/`** — a persistent-memory scaffold for durable, non-obvious
  facts (a `MEMORY.md` index + a memory-file template with frontmatter).
- **`docs/principles.md`** — the ten universal principles, each with the *why*.
- **`docs/scaling.md`** — optional multi-agent coordination, for when one repo has
  many agents at once. Most projects never need it — and the kit says so.

## Deep dives

The reasoning underneath the kit, at maximum technical depth — for developers and
software architects standing up serious AI collaboration:

- **[The Coordination Model →](https://testtest126.github.io/agent-ready/coordination.html)**
  Multi-agent collaboration framed as a distributed-systems problem: identity
  under a shared credential, durable vs. volatile channels, why green-at-the-branch
  is not green-at-the-merge, the single-writer serialization point, at-least-once
  delivery, and the economics that decide whether you need any of it.
- **[Architecture →](https://testtest126.github.io/agent-ready/architecture.html)**
  Agent *context* as an interface: single-source-of-truth with thin per-tool
  adapters, layered composition and precedence, the durable memory tier, the
  testability pattern, and the design rationale that ties it together.

Both are rendered from [`docs/`](docs) and live at
**[testtest126.github.io/agent-ready](https://testtest126.github.io/agent-ready/)**
— with diagrams, dark/light, and no external assets.

## The meta-principle

Everything here is optional, and adding a rule you can't yet justify is a cost,
not a virtue (principle 9). Take what fits. Delete what stops paying rent. The
kit is meant to make your repo *smaller* to reason about, not larger.

## License

MIT — see [LICENSE](LICENSE). Use it, fork it, ship it.
