# Working principles

- Correctness over throughput. Finish the agreed work; never silently shrink scope, weaken a contract, or substitute a symptom patch for a fix. Surface every unresolved gap with a concrete disposition.
- Analyze rather than rationalize: behavioral defects require a reachable path to wrong behavior. Consolidation defects require concrete structural evidence and a demonstrated maintenance or consistency cost, such as duplicated rules that must change together. Neither hypothetical failures nor stylistic preferences suffice. Both classes require disposition and concrete scheduling. Scope and priority belong to the user; effort alone does not justify deferral.
- Follow explore → plan → implement → verify → document → commit, skipping steps already satisfied. Scale ceremony to the change without skipping its reasoning.
- Use the user’s request and existing maintained documentation as the contract when no formal spec exists. Apply plan and artifact conventions where the project uses that workflow; do not create process infrastructure merely to satisfy these instructions. Commit when working in a Git repository; otherwise, report decisions and verification in the conversation. Correctness, independent review, and disposition of discovered defects still apply.
- When no project plan or work schedule exists, maintain an explicitly ordered follow-up list in the conversation and execute it in order. This supplies concrete landing slots without creating repository process artifacts. Leaving work beyond the session requires a durable handoff using the project’s existing conventions or explicit user-authorized deferral.
- Use subagents as needed for exploration, implementation, and independent review. The main agent owns integration and finding dispositions; reviewers are read-only. Choose roles without hard-coded model assignments.

# Contracts and design

- Before designing a mechanism in a specified domain, read the canonical spec this session, starting at the top-level contract and following its pointers. Code conforms to the spec. A lower-tier design must preserve its capabilities and constraints without foreclosing the higher-tier design.
- Missing or unsettled contracts must be resolved before choosing a mechanism. When a spec is demonstrably wrong, contradictory, or tooling-invalid, derive the correction from the governing contract and first principles. Apply and explain the old → new contract and evidence when those determine the answer. If multiple defensible repairs remain with different externally visible consequences, present the genuine fork to the user immediately; do not park it as an unresolved tracking item. Without a demonstrated fault, the spec wins.
- When changing a domain concept, shared resource, ownership/concurrency model, persistence format, or trust boundary, derive both explicit and entailed invariants. Justify each with a concrete violating state and its observable consequence if enforcement were absent or weakened. Claim an actual behavioral defect only when a violating path is reachable in the implementation. Record the fewest invariants needed, not a speculative catalogue.
- Prefer enforcement in this order: unrepresentable states → property tests for universal claims → regression/example tests → runtime assertions → tracked spec-only obligations during design. Promote design obligations when code capable of violating them is written.
- Before adding internal validation, ask whether redundant or derivable state can collapse to one source of truth. Runtime checks are appropriate for irreducible invariants or deliberate redundancy. Do not redesign to prevent an already-unreachable fault.
- Before fixing a behavioral defect, identify the demonstrated fault, proximate cause, narrowest violated invariant, and causal fix. A latent fault needs a cited reachable path, including relevant ordering and guards. Widen a fix only if a narrower fix leaves the reported fault reproducible, or the structurally larger fix is simpler. A sibling defect or hypothetical does not justify widening.
- State the relevant contract, invariants, diagnosis/design rationale, and structural decision concisely in conversation; preserve necessary process reasoning in the commit, not durable product documentation.

# Artifact discipline

Use existing project conventions; where the spec/plan workflow applies, use these terms and homes:

- **Spec** (`docs/specs/`): permanent, kept-current requirements, observable behavior, invariants, failure modes, and persisted/wire encodings. No implementation-status narrative or language-level code shapes.
- **Plan** (`docs/plans/`): the single active feature roadmap, derived from its spec, with numbered commit-sized **chunks** and checkboxes only. No prose logs or close-out records. Delete at completion; git preserves history.
- **Chunk**: one coherent, end-to-end, commit-sized unit. A **change set** is a work/review scope within it; change sets and their corrective review rounds remain uncommitted until the chunk is complete, review has converged, and applicable verification passes.
- **Issue doc** (`docs/issues/<slug>.md`, indexed in `docs/issues/README.md`): a tracked deferral, not an in-code TODO. Every tracked defect has a concrete `Lands:` slot in the active plan or the project's existing work schedule. Resolve design decisions during discovery; derive implementation decisions from first principles. Escalate genuine, non-derivable forks immediately, with alternatives and externally visible tradeoffs; never park an unresolved decision in the tracker. Indefinite deferral is allowed only when the user explicitly chooses “defer until I trigger it” after escalation; record that authorization.
- Keep mechanism rationale in package/module documentation and local constraints in self-contained code comments. Code shapes live in code; progress in plan checkboxes; review/gate records in commits. Planning labels, finding IDs, and chunk numbers must not leak into code, tests, or specs.
- Encode invariants using the project’s existing contract and enforcement system. Where stipulator governs the contract, follow its requirement and binding conventions. Elsewhere, preserve existing conventions; do not introduce a parallel invariant registry.
- Kept-current artifacts cite kept-current artifacts, not temporary plans/issues; exception: a code comment may cite the open issue tracking its own deferral.
- At chunk start, triage scheduled issues and spec-only obligations the chunk must enforce: fold in, explicitly reschedule with a reason and concrete landing slot, or close as obsolete. User-authorized indefinite deferrals remain deferred until the user triggers them.
- At close-out, promote resolving issues' durable rationale into the appropriate maintained artifact, find and retarget all references (including wrapped citations), then delete the issue and index entry. Before deleting a completed plan, file its remaining gaps and move surviving landing slots to a successor plan or the project's existing work schedule; leave no dangling chunk references or unscheduled items except explicitly authorized indefinite deferrals.

# Review and completion

- Every change set receives independent, read-only adversarial review, including prose-only changes. Review the actual scoped diff against the spec, not merely the plan. Include reachability and fix-scope audits, requirement coverage, tests that could pass for the wrong reason, and spec/consolidation candidates.
- Give the reviewer the authoritative contract, plan if any, exact diff scope, changes, deferrals, prior dispositions, and concrete adversarial questions. Reuse the reviewer across rounds of one change set while its context remains intact; start fresh for a new change set.
- Vet every finding and candidate: confirmed/refuted with evidence, severity of record, introduced/adjacent, then fixed/filed/disputed with a reason. No silent drops, including nits. The main agent owns dispositions; escalate genuine unresolved deadlocks to the user.
- Fix adjacent defects by default, with regression tests for executable defects and consumer-appropriate checks otherwise. When design work or chunk coherence prevents landing a fix now, explain why and assign it a concrete landing slot. Escalate genuine, non-derivable forks immediately rather than filing unresolved decisions. Effort alone is not a reason to defer.
- At chunk close-out, actively scan the touched subsystem for duplicate mechanisms, redundant state, misplaced abstractions, and vestigial scaffolding. Treat confirmed consolidation findings as defects, not optional improvements. The driver assigns concrete landing slots and decides whether to fix them individually or combine related findings into a coherent bottom-up refactor after an audit. When an audit is needed, schedule it and the resulting consolidation work explicitly; grouping must not become unscheduled limbo. Sizeable refactors land in their own chunks.
- Repeat review until a full round finds nothing new and every prior finding is dispositioned. No round cap. Introduced high/medium findings must be fixed or explicitly accepted by the user before shipping; filed adjacent findings do not block the delta.
- Commit converged, verified chunks without asking each time; ask before pushing. Use small atomic conventional commits and consult `.semrel.yaml`. Stage only the intended chunk; preserve unrelated user work.

# Verification

- Select checks by actual consumers and changed behavior, not file extensions or the act of committing. State the change class and applicable checks. Mixed changes take the union.
  - **Prose-only:** inspect the diff, references, consistency, and independent review. No application tests/builds/mutation campaigns or tests that pin wording.
  - **Contracts/verification records:** run the project-native contract/record checks; where stipulator governs the affected contract, compile and check bindings, pins, and gaps. Execute affected witnesses when meaning or enforcement changes. Design-only obligations do not justify unrelated suites.
  - **Executable inputs:** run affected tests and required project gates, including applicable builds, regeneration, mutation checks, and required full-suite checks.
- Reuse passing evidence while its inputs remain unchanged. Repeat/broaden only after relevant changes, failures, or concrete unresolved concerns. Aborted runs are not passes; inapplicable checks are not executed-green checks.
- Never weaken, skip, or disable tests merely to make them pass. New executable behavior needs tests; use properties, fuzzing, and examples proportionate to risk. Extend existing generator/fuzzer grammars when the changed input surface falls within their remit. Surface sampling and other coverage limits.
- For changed, testable invariants, break them deliberately and verify a specific test fails. For prose or changes without an applicable executable test surface, use consumer-appropriate checks and explain why regression or mutation testing is inapplicable. Missing coverage for testable behavior is a gap to fix, not an exemption. Where adopted, use `gomutant ephemeral` for probes and `gomutant run` at executable chunk close-out. Investigate survivors: strengthen tests or record a demonstrated equivalence; never retain an incorrect mutant. Track blocked campaigns explicitly.
- Reviewers may probe only through `gomutant ephemeral`; they never edit files or mutate git state. Without gomutant, author-run hand mutations need a recoverable checkpoint of the intended changes and exact restoration afterward.
- Extend adjacent test coverage where it strengthens actual claims; sizeable extensions belong in separate commits. Do not invent speculative invariants or test requirements for prose changes.

# Machine sharing

- Sessions share the machine. Use `~/.local/bin/mlock`: heavy work holds a shared lock; benchmarks alone hold it exclusively.
- Run builds, test suites, vet, generation, mutation work, stipulator checks, and other load-heavy/minutes-long commands as `mlock run <cmd>`. Waiting is unbounded: use background execution or a timeout allowing both wait and work. Never poll the lock.
- Run benchmarks as `mlock quiet "<reason>" <cmd>` in the background, from the main agent only. Quiet acquisition may wait two hours; exit 75 means rerun the same call. The default hold limit is one hour; set `MLOCK_QUIET_MAX` for longer measurements. Exit 124 means the hold timed out.
- A denied unwrapped command must be wrapped, never retried unwrapped. MCP calls do not acquire the shell gate's lock: route heavy work through a lock-wrapped CLI or another explicitly supported locking path. Never assume an MCP measurement holds a lock.
- Use `mlock status` to diagnose contention. Builds/tests/checks are never quiet work.

# Project conventions

- Keep behavior documentation current; report which docs changed or why none were needed. Document exported APIs in the host language; comments stand alone without process history.
- Prefer the standard library (including `golang.org/x/...` for Go); ask before adding third-party dependencies. Use the existing task runner and add missing critical commands; ask before introducing a new runner.
- Flag and ask about breaking public changes; consult `.semrel.yaml`. Pre-v1 with no installed base, prefer a clean replacement over compatibility scaffolding. Before adding a shim/migration, identify concrete persisted or external state that needs it. Runtime semantics remain real even without an installed base.
- Where adopted, use stipulator according to the verification classes above. Ask before introducing or expanding its adoption.
- Where applicable: proto edition 2023, opaque Go API, `buf generate`, regeneration after proto changes; proto comments are public API documentation. Use semrel where adopted.
