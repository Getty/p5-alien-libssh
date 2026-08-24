# Alien::libssh House Rules

Apply to every task in this repository unless explicitly overridden. Bias: caution over
speed on non-trivial work; judgment on trivial ones. Loaded automatically at launch (same
priority as `CLAUDE.md`). Subagents get their conventions from the skills force-loaded via
`briefing.skills` — this file is for the orchestrating agent.

## Engineering discipline

1. **Think before coding** — State assumptions. When uncertain, ask rather than guess.
   Push back when a simpler approach exists. Stop when confused; name what's unclear.
2. **Simplicity first** — Minimum change that solves the problem. Nothing speculative.
3. **Surgical changes** — Touch only what you must. Don't "improve" adjacent code,
   comments or formatting. Match existing style.
4. **Read before you write** — `alienfile` is the whole distribution; its comments record
   why each line exists. Read them before changing a line they explain.
5. **Surface conflicts, don't average them** — Contradicting patterns: pick one (more
   recent / more tested), say why, flag the other. Don't blend.
6. **Checkpoint after every significant step** — done / verified / left.
7. **Fail loud** — "Done" is wrong if anything was skipped silently; "tests pass" is wrong
   if only one install path ran.

## Delegation

Depends on whether the Agent/Task tool is available to you.

- **You can spawn subagents** (orchestrating main agent): do NOT touch behavior-relevant
  files yourself — delegate.

  | Task | Agent |
  |---|---|
  | alienfile, share/ tarball, t/, lib/Alien/, POD | `alien-libssh-worker` (default) |
  | Pre-release audit (CPAN) | `alien-libssh-release-checker` |

  Your lane: coordinate, inspect, plan, review diffs, run tests, manage git, write
  `Changes` notes and prose docs. When in doubt, delegate. Why: only the
  `alien-libssh-*` agents get `alien-libssh-core` / `perl-alien` force-loaded via
  `briefing.skills`; you get no briefing and would edit the build with too little context.
- **You cannot spawn subagents** (you ARE an `alien-libssh-*` agent): the lock does not
  apply — implement, refactor, debug and test per these rules.

Behavior-relevant = anything changing what gets installed or how it is found: `alienfile`,
`share/`, `cpanfile`, `dist.ini`, `t/`. Prose and `Changes` notes are not.

## Project hazards — why this file is worth loading

- **Local `dzil test` proves one path at most.** This host has no system libssh, so an
  unforced run is always the share build and never enters the probe. Anything touching the
  build runs both: `env ALIEN_INSTALL_TYPE=share dzil test` **and** `…=system dzil test`.
  `prove -l t` builds nothing and is not a test.
- **A share build that links is not a share build that runs.** The lib is static and the
  generated `libssh.pc` omits `-lcrypto -lz`; the `after 'gather'` hook adds them. The XS
  consumer is the only thing that notices — `t/01-alien.t`'s `xs_ok` on the share path is
  the check, and it fails at *load*, not at compile.
- **`.claude/` is git-ignored except for a whitelist** in `.gitignore`. A new directory
  under it stays invisible to git until whitelisted — verify with `git status --short`.
- **Skills under `.claude/skills/` are hardlinks** into the shared library. Never `Edit`/
  `Write` one — rewrite in place (`cat > path <<'EOF'`), or every other repo silently
  keeps the old content. `manage-skills check` verifies, `manage-skills sync` repairs.

## Coordination — karr board (always in scope)

Ticket coordination is the orchestrating agent's job, so `karr` is always in scope — don't
invoke the `kanban-issues-karr-cli` skill first, just use it. Git-native kanban, state in
`refs/karr/*` of this repo: `karr board` / `karr list --compact` to see open work,
`karr create "Title" --priority high`, `karr move ID in-progress --claim NAME`,
`karr handoff ID --claim NAME`. Full surface: that skill.

Work owned by `Net::LibSSH` becomes a ticket on that repo's board (`~/dev/p5-net-libssh`)
— never a direct edit there. **Serialize board mutations when fanning out**:
implementation may run parallel, the `karr move`/`handoff`/`sync` calls run sequentially.

## Release — never without permission

`dzil build` / `dzil test` are fine anytime. `dzil release` and any CPAN upload are
STRICTLY forbidden without the maintainer's explicit go-ahead — even if a plan lists
"release" as the next step. A libssh version change is always its own release, and
`Net::LibSSH` gets told. Pre-release audit goes through `alien-libssh-release-checker`.

## Public issues (GitHub) — never act without instruction

**karr** is the internal agent board, churned freely. **GitHub issues**
(`github.com/Getty/p5-alien-libssh`) are the public tracker: real humans, published under
the maintainer's account. Never act on one on your own initiative — not even to read it —
unless the user points at a specific item.

## Perl and Alien specifics — reference, don't restate

House Perl style: skill `getty-perl-core`. Alien::Build mechanics: skill `perl-alien`.
The XS consumer side: skill `perl-xs`. This distribution's own facts: skill
`alien-libssh-core`. Do not duplicate them here.
