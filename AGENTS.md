# AGENTS.md

<!--
  The single source of truth for how AI agents (and humans) work in this repo.
  Many tools read it — Claude Code, Cursor, GitHub Copilot, Aider, and more; the
  files in /adapters point them all here so you maintain ONE document.
-->

## What this project is
**agent-ready** is a dependency-free kit of drop-in conventions that make any
repository ready for AI collaboration: an `AGENTS.md`, a memory scaffold, and
thin per-tool adapters. `install.sh` copies the files under `templates/` into a
target repo. The kit itself is what you see here — this repo dogfoods it (the
`AGENTS.md`, `CLAUDE.md`, `memory/`, and adapters at the root were installed by
running `./install.sh .`).

## Build, run, test
- **Setup:** `brew install shellcheck bats-core` (macOS) · `apt-get install -y shellcheck bats` (Linux). The kit ships with **zero** runtime dependencies; these are dev-only, for lint + tests.
- **Build:** none — pure POSIX shell plus static `templates/` and `docs/`. Nothing to compile.
- **Test:** `bats tests/install.bats`  &larr; run this before calling any change "done"
- **Run:** `./install.sh [--force] [TARGET_DIR]` — installs the kit into `TARGET_DIR` (default `.`); never overwrites an existing file unless `--force`.
- **Lint / format:** `shellcheck install.sh`

> If a change is observable when the project runs, run it and confirm the
> behavior &mdash; not just that tests pass. For installer changes, run
> `./install.sh` against a scratch dir and inspect what landed.

## Conventions
- **Code:** POSIX `sh` only — `#!/usr/bin/env sh`, `set -eu`, no bashisms. Must pass `shellcheck` clean. Otherwise match the surrounding file.
- **Commits:** `scope: summary`, lowercase, imperative (e.g. `install.sh: …`, `tests: …`, `ci: …`, `docs: …`, `README: …`). Small, reversible, one idea each.
- **Branches / PRs:** work on a branch; PR into `main`. CI (shellcheck + bats) must be green.
- **Layout:** `install.sh` (the installer) · `templates/` (what gets installed: `AGENTS.md`, `adapters/`, `memory/`) · `docs/` (principles, scaling, + the rendered GitHub Pages site) · `tests/install.bats` · `.github/workflows/ci.yml`.

## The working agreement
These hold for every change, whoever &mdash; or whatever &mdash; makes it:

1. **Verify, don't assume.** "Tests pass" is not "it works." Exercise the real
   change; for a bug fix, first confirm the test *fails without the fix*. See
   `CHECKLIST.md` for the full definition of done.
2. **Silence is never consent.** Before anything irreversible or outward-facing
   &mdash; publish, delete, send, deploy, merge, change access &mdash; get an
   explicit yes. A missing objection is not approval.
3. **Green at your branch is not green at the merge.** Re-verify against the
   current tip of `main` before integrating.
4. **Say what actually happened.** Failed tests are reported with output; skipped
   steps are named; uncertainty is stated as uncertainty.
5. **No secrets or personal data** in the repo, logs, commits, or anything
   shared. Scan before publishing.
6. **Security-sensitive changes** (auth, tokens, crypto, sessions, access) get a
   review and tests that can actually fail on the bug class.

## Do not
- Don't hand-maintain the installer's copy list — it's derived from `templates/`
  at runtime (drop a file under `templates/` and it installs automatically).
  Keep that property; don't hard-code filenames in `install.sh`.
- Don't add runtime dependencies — "no dependencies" is a stated promise (and a
  README badge). Dev tooling (shellcheck, bats) is the only exception.
- Don't introduce bashisms or anything shellcheck flags.
- Don't work around required checks or branch protection.
- Don't automate an irreversible action (arming auto-merge *is* merging).

## Memory (optional)
Durable, non-obvious facts live in `/memory` (read `memory/MEMORY.md` at the
start of a session). See the kit's `docs/` if you adopt it.

## Scaling to many agents (optional)
Only if several agents work here at once do you need coordination rules; see
`docs/scaling.md`. Most projects don't &mdash; don't add ceremony you can't yet
justify.
