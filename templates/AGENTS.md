# AGENTS.md

<!--
  The single source of truth for how AI agents (and humans) work in this repo.
  Many tools read it — Claude Code, Cursor, GitHub Copilot, Aider, and more; the
  files in /adapters point them all here so you maintain ONE document.

  Keep it short, current, and honest. Fill in the <ANGLE-BRACKET> placeholders
  and delete these guidance comments as you go.
-->

## What this project is
<One or two sentences: what it does, who it's for, and the single most important
thing to understand before touching it.>

## Build, run, test
- **Setup:** `<install / bootstrap command>`
- **Build:** `<build command>`
- **Test:** `<test command>`  &larr; run this before calling any change "done"
- **Run:** `<run command>`
- **Lint / format:** `<lint / format command>`

> If a change is observable when the project runs, run it and confirm the
> behavior &mdash; not just that tests and types pass.

## Conventions
- **Code:** <house style, or simply: "match the surrounding file.">
- **Commits:** <format>. Small, reversible, one idea each.
- **Branches / PRs:** <how you branch; when a PR is warranted>.
- **Layout:** <a one-line map of where things live, if it helps.>

## The working agreement
These hold for every change, whoever &mdash; or whatever &mdash; makes it:

1. **Verify, don't assume.** "Tests pass" is not "it works." Exercise the real
   change; for a bug fix, first confirm the test *fails without the fix*. See
   `CHECKLIST.md` for the full definition of done.
2. **Silence is never consent.** Before anything irreversible or outward-facing
   &mdash; publish, delete, send, deploy, merge, change access &mdash; get an
   explicit yes. A missing objection is not approval.
3. **Green at your branch is not green at the merge.** Re-verify against the
   current tip of `<default branch>` before integrating.
4. **Say what actually happened.** Failed tests are reported with output; skipped
   steps are named; uncertainty is stated as uncertainty.
5. **No secrets or personal data** in the repo, logs, commits, or anything
   shared. Scan before publishing.
6. **Security-sensitive changes** (auth, tokens, crypto, sessions, access) get a
   review and tests that can actually fail on the bug class.

## Do not
- <Files or directories never to touch; commands never to run.>
- Don't work around required checks or branch protection.
- Don't automate an irreversible action (arming auto-merge *is* merging).

## Memory (optional)
Durable, non-obvious facts live in `/memory` (read `memory/MEMORY.md` at the
start of a session). See the kit's `docs/` if you adopt it.

## Scaling to many agents (optional)
Only if several agents work here at once do you need coordination rules; see
`docs/scaling.md`. Most projects don't &mdash; don't add ceremony you can't yet
justify.
