# Artifacts

Use these exact names; map synonyms ("follow-up", "deferred item", "deviation", "plan amendment") to the defined term, never a new concept.

- **Spec** (`docs/specs/`). The requirements contract, in markdown. Permanent, kept-current; code conforms to spec, never the reverse. Pins the _what_.
- **Plan** (`docs/plans/`). The active roadmap for one feature, derived from its spec, broken into numbered commit-sized **chunks**. WIP = 1. A plan holds chunk checkboxes ONLY — no status field, no prose log, no close-out records (the per-chunk record is the commit message). Deleted at close-out; git holds history.
- **Chunk.** A commit-sized slice — coherent end-to-end, tests green, no half-wired state. Runs the adversarial loop independently, lands as one commit. **Sub-chunk `N.x`**: `N.1` = triage gate, the final = close-out gate; only those two anchors are fixed.
- **Change set.** One round of work inside a chunk — the work and its diff. The adversarial loop runs per change set; a chunk closes when the loop converges.
- **Issue doc** (`docs/issues/<slug>.md`, indexed in `docs/issues/README.md`). A parked deferral carrying a `Lands:` trigger — a chunk number of the active plan or a self-contained condition.
- **Project invariant.** A property required of all reachable in-spec states, encoded at the strongest artifact the stage affords. No separate register — it rides the spec (design stage) or its enforcement artifact (code stage).

# Artifact homes — the anti-pollution contract

Every durable artifact must stand alone for a reader with no planning history. Process exhaust leaking into durable artifacts is a defect. Where each content class lives:

| Content                                                                                                                   | Home                                                      | Never in                    |
| ------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- | --------------------------- |
| Contract: what must hold, observable behavior, persisted/wire formats, invariants, failure modes                          | Spec                                                      | —                           |
| Mechanism rationale: why this shape, alternatives rejected                                                                | package/module doc comment (lives and dies with the code) | Spec                        |
| Code shapes: structs, signatures, function/file homes                                                                     | the code itself                                           | Spec                        |
| Local constraint: why this line/ordering/guard                                                                            | self-contained code comment                               | —                           |
| Process record: gate lines, diagnoses, review dispositions, chunk decomposition, close-out records, landed/reversed dates | commit message ONLY                                       | Spec, plan, comments, names |
| Deferral                                                                                                                  | issue doc                                                 | in-code TODOs               |
| Progress                                                                                                                  | plan checkboxes                                           | Spec                        |

- **Encodings are contract.** Anything observable across a restart or the wire (key layouts, discriminator bytes, formats) belongs in the spec even though it looks like "how". Language-level shapes do not.
- **`INV-*` IDs + enforcement pointers** ("INV-X: enforced by `<test>`") are the one sanctioned spec↔code cross-reference scheme. Stable IDs; kill everything else.
- **Planning codenames die at the commit boundary.** Chunk/step numbers, gate names, review finding IDs, phase labels, plan-local abbreviations never appear in specs, code, comments, identifiers, or test names. Specs use descriptive names; tests are named for the behavior they pin.
- **Gate lines are conversation output, durably recorded in the commit message** — `Spec-first:`, `Diagnosis:`, `Rationale:`, `Invariant:`, `Structural-check:`, `Triage:`, dispositions. Never written into specs, plans, comments, or docs.
- **Specs carry no implementation-status narrative** ("landed <date>", "pending review", per-step logs). A spec states the current contract; not-yet-built is expressed by a spec-tier invariant's `Lands:` line; history is git's; status is the roadmap's.
- **No-cite invariant.** Kept-current artifacts (specs, production code, README-class docs) cite only kept-current artifacts or a `git log --all -- <path>` recovery line — never a tracking artifact (issue doc, plan, ADR-class delete-on-close doc). Tracking artifacts may cite anything.
- **`Lands:` outlives plans.** Naming a chunk of the _active_ plan is fine while it lives; the plan's close-out retargets every surviving reference to a self-contained condition.

# Workflow

Follow: explore/ask → plan → develop → test → docs → commit. Skip steps already covered in context.

- Commits: small, atomic, conventional (feat:/fix:/docs:/chore: — consult `.semrel.yaml`). Commit only when the user asks; otherwise leave the change set ready but uncommitted. Tests and build pass locally before committing.
- Adjacent issues: fix now if small (with regression tests), file an issue doc if not, never ignore.
- At the plan step run the Project-invariants trigger; at explore/plan run the Spec-first trigger — before designing any mechanism.

# Quality bar

- **Correct-by-design over throughput.** No "for now" shortcuts — if the right fix takes a week, take the week.
- Defer only via an issue doc. No in-code TODOs, no hidden shortcuts.
- **No silent downscoping.** Satisfy every spec requirement or file an issue doc per gap and surface it — the _unfiled_ gap is the violation. Harder-than-spec discovered mid-implementation → stop and surface; never shrink the spec to fit the code.
- **Analyze, don't rationalize.** Present findings objectively; never argue something "isn't worth it." Stating a correctness/safety/security defect factually — with a concrete failure mode (input/state → wrong or unsafe result) — is not editorializing; a preference dressed as one is.
- **No editorializing the user's call.** Scope, priority, and effort are the user's. No scope labels ("v1", "later", "out of scope"), no priority ranking of work, no effort framing as a tradeoff. (The H/M/L/nit ordering of review findings is an audit artifact, not a recommendation — it stands.)

# Gates

Four proactive gates share one shape: a trigger, a required one-line statement (to the user + commit message, per Artifact homes), and bounds. The shared principle: unrepresentable > enforced > named; chosen > inherited.

## Spec-first (before designing a mechanism)

- **Trigger:** about to propose or implement a mechanism — concurrency/lock model, ordering/atomicity rule, protocol, schema, persistence/serialization format, consistency/trust rule, any cross-cutting design — in a domain that has a Spec. Exempt: pure mechanical edits, or a mechanism fully grounded in a Spec read _this session_ ("I recall the gist" is not).
- **Action:** read the _canonical_ Spec first — the top-level contract, not the section nearest the code; follow its pointers. For layered designs (top-tier contract, lower tiers as proven collapses), read the top tier first; the mechanism must be its faithful collapse — never _finer_ (more concurrency/capability than the top tier affords), never _coarser_, never _foreclosing_ (a shape the top-tier form couldn't be built on, forcing a throwaway retrofit).
- **State:** `Spec-first: canonical=<§ read>; contract=<governing form>; mechanism=<proposed>; collapse-check=<faithful | finer | coarser | FORECLOSURE | n/a: single-tier>.`
- **Hard stop:** a missing or weaker-than-settled top-tier contract is not filled with a lower-tier-local choice _called_ a collapse — settle it first, or flag the specific foreclosure for the user's call. A Spec found wrong, or two tiers contradicting, routes through the spec-amend channel — surface, never unilaterally edit; spec wins by default.

## Project invariants (before building a triggered concept)

- **Trigger:** a change set introducing or modifying a domain concept, cross-cutting state/resource, concurrency/ownership model, persistence/serialization boundary, or trust boundary.
- **Action:** derive invariants of two kinds — **clause-explicit** (a spec clause states it) and **entailed** (the spec assumes but never writes it: conservation, idempotence, monotonicity, referential integrity, ordering — "what must hold that no clause states, such that violating it makes the spec incoherent?").
- **State:** `Invariant: kind=<clause-explicit|entailed>; property=<…>; from=<clause | "entailed: …">; violation=<reachable in-spec input/state → wrong/unsafe result>.` The `violation=` is the strongest reachable counterexample — prefer one where every clause-explicit invariant still holds yet the system is wrong. No statable `violation=` ⇒ it's a preference — don't record it. Record the fewest invariants that pin the spec; a speculative catalogue is over-encoding.
- **Encoding ladder:** unrepresentable type/encoding > property test (for for-all claims; example pins only as named anchor cases) > example/regression test > asserted check > spec-tier (recorded, not enforced — pure-design stage only, carrying `Lands: when code able to violate it is first written`). Never weaker when stronger is available.
- Invariants are subordinate to the spec exactly as plans are; a wrong invariant or a spec gap routes through the spec-amend channel. A violated _enforced_ invariant is a demonstrated fault and enters Diagnosis unchanged.

## Structural enforcement (before adding a runtime check)

- **Trigger:** about to enforce an _internal_ illegal state (one the system itself constructs) with a runtime check/validation/assertion. Exempt: pure value-domain validation of external input.
- **Ask:** is the state representable only because one fact is stored in ≥2 places that must agree, or is derivable from a single source? Can I collapse to one source of truth so the divergent state cannot be expressed?
- **State:** `Structural-check: invariant=<…>; illegal-state=<…>; representable-because=<redundant/derivable | "irreducible">; decision=<collapse to <source> | runtime check (why collapse unavailable/disproportionate)>.` "Runtime check" is a sound answer — many invariants are irreducible or the redundancy is deliberate denormalization.
- **Bounds:** the collapse must itself pass Spec-first (not finer/coarser/foreclosing) and be cost-proportionate; redesigning to make an already-unreachable fault unrepresentable is over-engineering.

## Root cause (before fixing a defect)

- **Trigger:** a defect, or wrong/surprising/unexplained behavior. Exempt: typos, mechanical renames, behavior-free refactors. "Small" scales the diagnosis to one line each; it does not skip it.
- **Anchor:** a demonstrated fault — a failing test; a reachable in-spec input → wrong result; or a latent fault whose mechanism is shown over a cited reachable path (state the entry point, interleaving/lock order, and why the guard doesn't hold — at diagnosis time; the reviewer audits the cite like any claim). Not a fault: a hypothetical with no reachable path, or a named invariant with no mechanism. No demonstrable fault ⇒ treat as intended behavior (`Rationale:`) or ask — never manufacture one.
- **State:** `Diagnosis: fault=<…>; proximate=<wrong line/call>; root=<narrowest invariant violated>; fixing at=<level>; wider scope justified by=<escalation rule | "n/a — narrowest sufficient">.` Intended new behavior states `Rationale: change=<…>; invariant preserved=<…>; why this shape=<…>` (both, if fix+feature).
- **Escalation rule (canonical):** default to the narrowest fix on the causal chain from the root (the _narrowest_ invariant explaining the fault — never a broader one chosen to enlarge the chain). Widening requires a second demonstrated fault, on the same reported fault, reachable and in-spec, that the narrower fix demonstrably leaves failing. A named invariant, sibling-path failure, or hypothetical is not grounds. A structurally-larger-but-simpler fix needs no second fault.
- A deliberate partial/symptom patch is a deferral: issue doc with `Lands: when <invariant> is restored`.

# Adversarial review loop

Run on every change set; iterate until convergence. Fresh eyes are the point — no exceptions for "small" or "obvious."

1. **Land + checkpoint + mutation-test.** Apply the change, tests green — do not commit. Main agent stages the whole set with `git add -A`: the staging is both the change-set boundary (reviewers read `git diff HEAD`) and the safety checkpoint (`git restore <path>` reverts a botched mutation to the staged copy, never to HEAD; re-`git add` after intentional edits). Then mutation-test the delta: break each load-bearing invariant the change introduces (flip a comparison, drop a guard, neuter a branch), confirm a _specific_ test fails, restore. A surviving mutation = a vacuous or missing test — strengthen the test, never keep the mutation. **Reviewers only read; they run no tree-mutating git (no add/restore/checkout/reset/stash/clean).**
2. **Pre-flight + spawn.** Walk plan against spec yourself; state `Spec: <path>; Plan: <path>; divergences: <list|none>`. Spawn a fresh-eyes reviewer (sub-agent, separate session, or different model) with: the diff commands verbatim, scoped to the delta; spec and plan in separate labeled blocks (spec authoritative); what changed this round; what's deferred and why; specific adversarial questions (ownership/refcount lifecycles, ordering/atomicity, panic paths, happens-before/lock order/races, tests-passing-for-wrong-reasons, docs contradicting code); an **anchor & scope audit** (verify each `Diagnosis:` cite's reachability — an unreachable cite is a finding — and that no fix widened scope without the escalation rule's second fault: that's H/M, never graded down because the wider code "looks clean"); **spec coverage** (walk the spec, not the plan — per requirement: implemented file:line / tested / filed; label rows `(spec)` or `(plan)`; missing spec = H/M, plan-only = L); a **spec-amend candidates** section (implemented shape better than spec, or a recorded invariant wrong — relayed to the user verbatim, user decides, spec wins by default). Demand severity-ordered H/M/L/nit findings with file:line + minimum reproducer; word-cap 1000–1500.
3. **Disposition every finding:** **fixed**, **filed** (issue path), or **disputed** (one-line reasoning the user accepts), plus `class=<introduced|adjacent>`. No silent drops; no "fix if cheap"; nit is not a skip signal.
4. **Repeat**, each round's prompt opening with the prior round's dispositions so the reviewer focuses on the new delta.
5. **Ship gate, scoped to this change set.** Introduced vs adjacent is decided by the diff, not judgment: introduced iff the cause-line is in this diff or the diff creates the first reachable in-spec path (reproduces on HEAD, not on base). A pre-existing adjacent H/M is addressed by filing (never blocks; the loop reviews the delta). An introduced H/M is addressed iff fixed, or filed/disputed _with explicit user acceptance_. Ship when no introduced H/M is unaddressed and every L/nit has a disposition.
6. **Circuit breaker:** an introduced H/M still unaddressed after 3 rounds → stop, surface the open set with options. Autonomous runtimes fix what they introduced, file adjacents and proceed, never self-grant acceptance, never silently ship a regression they caused. More H than last round: distinguish regression (pause, investigate) from newly-exposed pre-existing (record; not a process failure). The breaker is a cost cap, not a verdict.

# Issue & plan triage

`Lands:` triggers don't pull work forward — gates do. State each gate run: `Triage at N.1: <count> match; folding <…>, redeferring <…>, closing <…>.`

1. **Chunk-start gate (N.1).** Scan the issues README for entries whose `Lands:` resolves to this chunk (exact match — `Lands: 3` is not `13`). Disposition each: **fold** into the chunk, **redefer** with new `Lands:` + reason, or **close** as obsolete. Also scan recorded spec-tier invariants whose `Lands:` this chunk meets: **promote** to enforcement or redefer tracked. Condition-triggered entries never fire passively — walk those plausibly related to this chunk and disposition any the landed work demonstrably meets.
2. **Close-out gate** (chunk close-out, and plan close-out for the plan's own residue). For each resolving issue: (a) **find every cite, wrap-aware** — a `docs/issues/<file>.md` reference hyphen-wraps across comment-continuation lines; grep with continuations rejoined or on a non-wrapping stem (single-line grep has leaked dangling pointers); (b) **promote then retarget** — move the load-bearing rationale inline into the citing spec section / code comment, point the reference at a kept-current artifact; (c) **delete** the issue file + README entry — git holds history. Promote-then-delete makes every resolved issue unconditionally deletable; a "kept as record" file is a skipped promote. **Plan close-out** additionally: extract every undone/deferred item as an issue doc, retarget every chunk-numbered `Lands:` to a condition, then delete the plan.

# Testing

- Never modify/skip/disable existing tests to make them pass — fix the implementation.
- New functionality requires tests. Rigor (-race, fuzzing, table-driven) proportional to the change's risk.
- **Opportunistic test-surface extension.** On any chunk, extend the test surface adjacent to what the chunk touched: property/fuzz coverage, generator grammar, regression nets. Standing legitimate work — smallest-correct-change governs production code, never tests (stronger enforcement of a stated claim is never over-encoding; a speculative invariant catalogue still is). Bound by adjacency; land sizeable extensions as their own commits.
- **Generator grammar keeps pace with the input surface.** A chunk extending an input surface extends the corresponding generator/fuzzer grammar in the same chunk, where one exists. A silently lagging grammar is a silent coverage cap — flag it like any downscoping.
- If a workflow/test harness bounds coverage (top-N, sampling, no-retry), say what was dropped — no silent caps.

# Documentation

- Document new behavior; state which docs you touched or "no docs needed" + reason. Keep repo docs in sync.
- Comment exported APIs in the host language, examples where useful — comments per Artifact homes: self-contained, no process archaeology.

# Dependencies _(project-conditional)_

- Prefer the platform's standard library (for Go incl. `golang.org/x/...`). Ask before adding third-party deps.

# Breaking changes

- Always flag and ask; check `.semrel.yaml` (`development: true` = breaking may be acceptable). Define "breaking" by the project's public surface; unsure → ask.
- **Clean break is the default pre-v1 with no installed base** — replace the old shape outright. Backcompat scaffolding (dual-read, format discriminators, migrations, shims) for a non-existent installed base is over-engineering. Before adding any, name the concrete persisted/external state that would break; none ⇒ clean break. Distinguish format backcompat (usually unnecessary pre-v1) from runtime feature semantics (always real). Real persisted/wire state with no regeneration path earns a migration — still flagged, not assumed.

# Development _(project-conditional)_

- Use the project's task runner (Taskfile if present); add missing critical commands. Don't introduce one the project doesn't use without asking.

# gRPC / proto _(project-conditional)_

- `edition = "2023"`, opaque API in Go; `buf generate` over direct protoc; regenerate on proto changes. Proto comments are public API surface — same standalone rule.

# CI / automation _(project-conditional)_

- Use semrel (github.com/greatliontech/semrel) where adopted. Author's local checkout: `~/repos/github.com/greatliontech/semrel` (environment-specific).
