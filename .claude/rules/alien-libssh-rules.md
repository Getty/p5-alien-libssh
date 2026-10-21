# Alien::libssh House Rules

Apply to every task in this repository unless explicitly overridden. Bias: caution over
speed on non-trivial work; use judgment on trivial tasks. Loaded automatically at launch
(same priority as `CLAUDE.md`). Skill content is never restated here: the skills are the
source, and the agents get them force-loaded via `briefing.skills`.

## Engineering discipline

1. **Think before coding** — State assumptions, ask rather than guess, push back when a
   simpler approach exists, stop when confused and name what is unclear.
2. **Simplicity first** — Minimum change that solves the problem, nothing speculative.
3. **Surgical changes** — Touch only what you must; don't improve adjacent code, comments
   or formatting. Match existing style.
4. **Read before you write** — `alienfile` is the whole distribution; its comments record
   why each line exists. Read them before changing a line they explain.
5. **Surface conflicts, don't average them** — Pick one pattern (more recent / more
   tested), explain why, flag the other. Don't blend.
6. **Checkpoint after every significant step** — done / verified / left.
7. **Fail loud** — "Done" is wrong if anything was skipped silently; "tests pass" is wrong
   if only one install path ran.

## Delegation

If you can spawn subagents (orchestrating main agent): do NOT touch behavior-relevant files
yourself — delegate. Your lane: coordinate, inspect, plan, review diffs, run tests, write
`Changes` notes and prose docs. Only the `alien-libssh-*` agents get `alien-libssh-core` /
`perl-alien` force-loaded via `briefing.skills`; you get no briefing and would edit the
build with too little context. When in doubt, delegate.

| Task | Agent |
|---|---|
| alienfile, share/ tarball, t/, lib/Alien/, POD | `alien-libssh-worker` (default) |
| Commits, `Changes`, card → done, pre-release audit | `alien-libssh-release-manager` |

If you ARE an `alien-libssh-*` agent, the delegation lock does not apply — implement,
refactor, debug and test per these rules.

Behavior-relevant = anything changing what gets installed or how it is found: `alienfile`, `share/`, `cpanfile`, `dist.ini`, `t/`. Prose and `Changes` notes are not.

**Only `alien-libssh-release-manager` commits.** A worker leaves a commit-ready tree and
hands its card to `review`; you then dispatch `alien-libssh-release-manager` to cut the
commit and close the card.

## Project hazards — why this file is worth loading

Mechanism and background: skill `alien-libssh-core`. These are the locks:

- **Both install paths, always.** This host has no system libssh, so an unforced `dzil test` only ever runs the share build. Anything touching the build runs `env ALIEN_INSTALL_TYPE=share dzil test` **and** `env ALIEN_INSTALL_TYPE=system dzil test`. `prove -l t` builds nothing — not a test.
- **A share build that links is not a share build that runs.** The generated `libssh.pc`
  omits `-lcrypto -lz`; the `after 'gather'` hook adds them. `t/01-alien.t`'s `xs_ok` on the
  share path is the check — it fails at *load*, not at compile.
- **`.claude/` is git-ignored except for a whitelist.** A new directory under it stays
  invisible to git until whitelisted — verify with `git status --short`.
- **Installed skills are build artifacts.** The ones `skilletor` installs are overwritten by the next `skilletor sync` — never edit them. Only repo-owned skills (tracked by git, no `skilletor` entry) may be edited.

## Coordination — karr board (always in scope)

Ticket coordination is the orchestrating agent's job, so `karr` is always in scope — don't
invoke the `kanban-issues-karr-coordination` skill first, just use it. Git-native kanban;
board state lives in `refs/karr/*` of this repo. Full command surface: that skill.

- `karr list --compact` / `karr board` — open work · `karr show ID` — detail
- `karr create "Title" --priority high --tags a,b --body '…'` — new ticket
- `karr move ID in-progress --claim NAME` — start · `karr handoff ID --claim NAME --note "…"` — to review
- mutating commands auto-sync; `karr sync --pull|--push` for explicit exchange

Work owned by `Net::LibSSH` becomes a ticket on that repo's board (`~/dev/p5-net-libssh`)
— never a direct edit there.

**Serialize board mutations when fanning out.** Collect the results, then loop the `karr move`/`handoff`/`sync` calls sequentially — N of them landing at once is a resource event, not a cheap command.

## Release — never without permission

`dzil build` / `dzil test` are fine anytime. `dzil release` and any CPAN upload are
STRICTLY forbidden without the maintainer's explicit go-ahead — even if a plan lists
"release" as the next step. A libssh version change is always its own release, and
`Net::LibSSH` gets told. Pre-release audit goes through `alien-libssh-release-manager`.

## Public issues (GitHub) — never act without instruction

`karr` is the internal agent board, churned freely. The GitHub issue tracker (`github.com/Getty/p5-alien-libssh`) carries real people's reports, written under the maintainer's account. Never act on a public issue on your own initiative — not even to read it — unless the user points at a specific item.

## Perl and Alien specifics — reference, don't restate

House Perl style: `getty-perl-core`; Alien::Build mechanics: `perl-alien`; the XS consumer
side: `perl-xs`; this distribution's own facts: `alien-libssh-core`. Do not duplicate them here.
