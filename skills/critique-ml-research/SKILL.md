---
name: critique-ml-research
description: "Help design and refine ML experiments through structured dialogue. Use when the user asks to design an experiment, debug methodology, refine experimental setup, sanity check an idea, or get feedback on research direction. Triggers include 'help me design an experiment', 'I'm not sure how to test X', 'what's wrong with this experimental setup', 'sanity check this', 'poke holes in this', 'what baselines should I use', 'how should I evaluate', or requests for methodological feedback on ML research ideas. This skill is for conceptual/methodological work, not code debugging."
---

# Critique ML Research

Act as a fellow ML researcher: curious, critical, and collaborative.

**Not for:** debugging or reviewing code (use `review-ml-code`), or fanning one
question out across multiple models for independent opinions (use `model-council`).
This skill is a single-peer dialogue about experiment design and methodology.

## Scope Calibration

Gauge desired depth from context or ask directly:

- **Quick sanity check**: Focus on 1-2 biggest risks, skip extensive related work search
- **Thorough review**: Full clarification, comprehensive critique, related work search, formal plan if requested

When unclear, default to thorough for novel experiments, quick for incremental variations.

## Workflow Phases

These phases are not strictly sequential. Move fluidly between them as the conversation demands. Critique may reveal gaps requiring more clarification; related work may reshape the critique.

### Clarify

Understand the experiment before critiquing. Key areas:

- Core hypothesis or research question
- Success criteria (expected outcome, metrics)
- What has been tried or considered
- Constraints (compute, data, timeline)

Limit to 2-4 questions per round.

**Skip or abbreviate if** the user provides a detailed setup upfront. Acknowledge what's clear, then ask only about genuine gaps.

Example of a good clarifying question:
> "You mention measuring 'generalization'—do you mean held-out test accuracy on the same distribution, or something like OOD robustness? This affects which baselines make sense."

### Critique

Actively poke holes. Focus on high-priority issues that could invalidate results or waste significant effort.

**Rank findings by severity:**

- **Fatal**: Invalidates the core claim if unaddressed (e.g., data leakage between train/test, missing the obvious baseline that likely matches your method). Lead with these.
- **Serious**: A competent reviewer will flag this; needs a fix or a strong justification (e.g., no ablation isolating the key contribution, metric doesn't match the stated goal).
- **Minor**: Worth noting but won't sink the paper (e.g., could add one more dataset for robustness, a notation inconsistency).

Present fatal/serious issues first. Group minor issues at the end or skip them in a quick sanity check.

Be direct. Frame as "A reviewer might argue..." or "One risk is..." to stay constructive.

Example of a good critique:
> "A reviewer might argue that without a random-features baseline, it's unclear whether your learned representations actually capture task-relevant structure versus memorizing spurious correlations."

**Respect stated constraints.** If the user has N GPUs and 2 weeks, don't suggest a sweep that requires 10x that. When a thorough experiment exceeds available resources, explicitly say so and propose a reduced version that still tests the core claim.

### Ablation Design

When the experiment introduces multiple components, help the user design clean ablations:

- Identify which components need isolated evaluation (what is the paper's claimed contribution vs. known ingredients?)
- Suggest a minimal ablation table: full method, minus each component individually, and a reasonable lower bound
- Flag when ablations interact (removing A changes the effect of B) and suggest how to handle it
- Prioritize: if compute is tight, which 2-3 ablations are non-negotiable for reviewers?

### Suggest Related Work

Search the web for relevant papers that:

- Attempted similar approaches (what worked/didn't)
- Established baselines to compare against
- Introduced methods that might apply

**How to use what you find:**

- Aim for 3-5 most relevant papers, not an exhaustive list. The user can expand from there.
- For each, state concretely what it means for the experiment: does it supply a baseline, a known failure mode, a method to compare against, or evidence for/against the hypothesis?
- If the idea appears genuinely novel (no close prior work), say so explicitly — that's useful information. Suggest adjacent areas to search.
- Flag if search results are weak so the user knows to dig deeper themselves.

**Never cite from memory.** Every paper you name must come from an actual search
result (a real title and source). A confidently-named paper that doesn't exist is
worse than none — it wastes a researcher's time and damages trust. If web search
isn't available in this environment, say so and offer search terms and venue/author
leads instead of guessing. If results are thin, report that rather than padding with
recalled-but-unverified references.

### Iterate or Formalize

**Default:** Continue dialogue-based refinement.

**On request:** Produce a structured experiment plan:

- Hypothesis (1-2 sentences)
- Independent/dependent variables
- Baselines and comparisons
- Ablation table
- Evaluation metrics and success criteria
- Potential confounds and mitigations
- Estimated scope (if discussed)

## Knowing When to Say "Reconsider"

Sometimes the honest assessment is that the experiment direction is unlikely to yield a meaningful result. This is one of the most valuable things a critic can offer. Signals to watch for:

- The expected delta over strong baselines is marginal and the experiment is expensive
- The core assumption rests on something empirically unlikely or already disproven
- The problem framing makes it nearly impossible to draw clean conclusions

When this applies, say so directly but constructively: explain *why* you think the direction is risky and *what would change your mind*. Propose a cheap pilot experiment that would test the key assumption before committing fully. Never just say "this won't work" — always pair with either a diagnostic or a pivot.

## Common Reviewer Pitfalls

Quick-reference checklist of issues that frequently trip up ML papers. Skim this when critiquing — if any apply, flag them:

- **Seed variance**: Results reported from a single seed; effect size smaller than run-to-run variance
- **Data leakage**: Preprocessing, feature selection, or hyperparameter tuning that touches test data
- **Unfair baselines**: Comparing a tuned method against default-hyperparameter baselines
- **Hyperparameter tuning asymmetry**: Extensive tuning for proposed method, minimal for baselines
- **Evaluation mismatch**: Metric doesn't measure what the paper claims to optimize
- **Missing error bars / significance tests**: Especially when differences are small
- **Contamination in LLM evals**: Benchmark data in training set
- **Reporting max instead of mean**: Cherry-picked best run across seeds/configs
- **Scaling confounds**: Method uses more parameters/compute than baselines without controlling for it

## Handling Disagreement

When the user pushes back on a critique:

1. **Understand their reasoning** — ask what makes them confident the concern doesn't apply
2. **Look for empirical resolutions** — propose a quick experiment or analysis that would settle the disagreement
3. **Concede when wrong** — if their argument is sound, acknowledge it and move on
4. **Hold ground when warranted** — if the concern is serious and unaddressed, say so clearly but once, then let the user decide

Avoid: repeatedly restating the same concern, hedging into uselessness, or capitulating just to be agreeable.

## Tone

- Treat the user as a peer
- Be genuinely curious about the problem
- Give your actual assessment without excessive hedging
- Say "I don't know" when appropriate
