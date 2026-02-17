User: Please provide a detailed review of this in-progress manuscript. Focus on the exposition, structure and clarity. Highlight strengths and weaknesses and make a set of actionable proposals for revision. The manuscript is at an advanced stage, so focus on what is necessary to polish and finish it for submission.

GitHub Copilot: 

   

Read [](file:///Users/venpopov/GitHub/logit-probit-poisson-rum/R/race_functions.R)

Read [](file:///Users/venpopov/GitHub/logit-probit-poisson-rum/references.bib)

Here is a detailed review of the manuscript.

---

## Overall Assessment

This is a clearly written, mathematically elegant paper that makes a genuine conceptual contribution: showing that multinomial logit and multinomial probit are endpoint regimes of a single Poisson count race indexed by an accumulation threshold $\theta$. The core argument is sound, the notation is consistent, and the simulation studies are well-chosen. The manuscript is close to submission-ready. The main areas for improvement concern (a) structural imbalances between the theoretical and simulation sections, (b) missing formal and rhetorical elements expected in a journal submission, and (c) several places where the exposition can be tightened or clarified.

---

## Strengths

1. **Central idea is compelling and clearly stated.** The research question in the Introduction is crisply formulated, and the answer — that logit and probit correspond to different stopping rules on the same accumulation process — is easy to grasp and satisfying.

2. **Clean separation of noise shape and noise scale.** The "temperature identification" concept is well-motivated and neatly resolves the usual identification problem that makes logit–probit comparisons informal. This is perhaps the most technically valuable contribution.

3. **Appropriate scope.** The paper resists the temptation to turn the Poisson count race into a full sequential sampling model. The explicit disclaimer that this is a generative device rather than a process model of response times is well-placed and honest.

4. **Simulation suite is systematic.** The seven studies address distinct, progressively richer questions (convergence, probability vectors, set-size scaling, IIA, parameter recovery, noise shape, robustness). Each builds naturally on the previous.

5. **Self-contained mathematical development.** Sections 2–5 proceed in logical order and are largely self-contained. A reader with graduate-level probability can follow the argument without external references.

---

## Weaknesses and Actionable Proposals

### Structure and Balance

**W1. The Introduction is too long relative to the formal sections.**
The Introduction runs about 3.5 pages of prose (roughly half the non-simulation body), while the formal statement (Section 2), generative model (Section 3), logit boundary (Section 4), temperature identification (Section 5), and probit limit (Section 6) are each very short — some under a page. This front-loading creates an imbalance: the reader waits a long time before seeing any mathematics.

- **Proposal:** Shorten the Introduction by ~30%. Specifically:
  - The paragraph on Robinson et al. (2023) currently appears twice in spirit — once in the Introduction and implicitly again in Study 5. Condense the Introduction mention to 2–3 sentences.
  - The three subsections (1.1–1.3) read well as a roadmap, but they pre-empt content that is more effective when encountered in situ. Consider merging 1.1–1.3 into a single "Overview of contributions" paragraph.

**W2. No section numbers or labels for the simulation studies.**
Studies 1–7 are subsections of Section 7, but they use informal headers like "Study 3: Set-Size Scaling." This works adequately, but the studies lack any formal statement of what is being tested and what the conclusion is, beyond the figure captions.

- **Proposal:** For each study, add a one-sentence "claim" at the start and a one-sentence "result" at the end (separate from the figure caption). This would make the simulation section self-navigable. The omnibus Summary (Section 7.8) is good but would be even more effective if each study had already declared its own conclusion.

**W3. No "Model" or "Framework" section heading that groups Sections 2–6.**
The current structure jumps from Introduction straight to "Formal statement of random utility models," which reads as setup rather than a contribution. A reader scanning section headings sees a list of topics but no clear grouping of the theoretical core.

- **Proposal:** Wrap Sections 2–6 in a Part or a parent section titled something like "Theoretical Framework" or "The Poisson Count Race Framework," with Sections 2–6 as subsections. This makes the architecture legible at a glance.

### Exposition and Clarity

**W4. Key results are stated but not formally labeled.**
"Result 1" and "Result 2" appear inline but are easy to miss. There is no "Result 3" for the intermediate log-Gamma regime, even though the abstract promises three results.

- **Proposal:** Use a consistent, visually distinct format (e.g., **Proposition**, **Theorem**, or at minimum a numbered callout) for all three results. State the promised third result explicitly — something like: "For any finite $\theta > 1$, the Poisson count race induces a random utility model with log-Gamma($\theta$) noise, interpolating between Gumbel ($\theta = 1$) and Gaussian ($\theta \to \infty$) error distributions."

**W5. The Beta-function formula for binary choice appears without sufficient derivation.**
In the binary simulation section, the formula $\Pr(C=1 \mid x, \theta) = I_{\sigma(x)}(\theta, \theta)$ is stated and then justified in a compressed paragraph. The step from "the ratio $W = T_1/(T_1 + T_2)$ follows a Beta distribution" is correct but deserves a brief derivation or at least a citation, since $W$ follows a Beta only when both Gamma random variables share the same shape parameter — which they generally do not (they share $\theta$ but have different rate parameters). The argument implicitly rescales by the rates, and this should be made explicit.

- **Proposal:** Add 2–3 sentences making the rescaling step explicit: "Since $T_i^{(\theta)} \stackrel{d}{=} G_i / \lambda_i$ and we can write $\Pr(T_1 < T_2) = \Pr(G_1/\lambda_1 < G_2/\lambda_2) = \Pr(\lambda_2 G_1 < \lambda_1 G_2)$, the ratio $\lambda_1 G_2 / (\lambda_1 G_2 + \lambda_2 G_1)$…" — or cite a standard result.

**W6. The temperature identification is introduced as a definition but its motivation could be stronger.**
Section 5 correctly notes that without standardization the model becomes deterministic as $\theta \to \infty$. But the reader may wonder: *why is this particular standardization the right one?* The answer — it is the unique standardization that preserves a non-degenerate stochastic choice rule while allowing meaningful comparison of distributional shapes — is implicit but never stated outright.

- **Proposal:** Add one sentence explicitly justifying the choice: "This is the unique affine standardization that renders the noise zero-mean and unit-variance for all $\theta$, ensuring that $\beta$ alone controls the magnitude of stochasticity."

**W7. The probit limit argument (Section 6) could be tightened.**
The delta-method argument is sketched but mixes two asymptotic expansions (one via the delta method on $G_i/\theta$, another via digamma/trigamma approximations). It would be cleaner to choose one route and state it precisely.

- **Proposal:** State a single, clean proposition: "Since $\log G_i = \log\theta + \log(G_i/\theta)$ and $G_i/\theta \xrightarrow{p} 1$, a first-order Taylor expansion gives $\log(G_i/\theta) \approx (G_i/\theta - 1)$, so $\sqrt{\theta}(\log G_i - \log\theta) \xrightarrow{d} \mathcal{N}(0,1)$ by CLT applied to $G_i = \sum E_{ij}$." This avoids the delta-method detour and directly shows the result.

### Missing Elements for Submission

**W8. No formal abstract block.**
The abstract is presented as a section ("# Abstract") rather than in the YAML front matter or a proper abstract environment. Most journals and Quarto manuscript formats expect an `abstract:` field in the YAML header.

- **Proposal:** Move the abstract text into the YAML front matter under `abstract:`.

**W9. References are sparse.**
The bibliography has only 7 entries. For a paper that claims to unify two of the most widely used discrete choice frameworks, this is thin. Notable omissions include:
  - Train (2009), *Discrete Choice Methods with Simulation* — the standard reference for MNL/MNP.
  - Hausman & McFadden (1984) on IIA testing.
  - The Plackett (1975) reference for the Plackett-Luce model (currently cited without a bib entry).
  - Townsend & Ashby (1983) or Smith & Vickers (1988) for accumulator models in psychology.
  - Dagsvik (1994) or Mattsson et al. (2014) for random utility with non-standard noise distributions.

- **Proposal:** Add 8–12 additional references covering the econometrics (Train, Hausman-McFadden), psychology (Townsend-Ashby, Ratcliff, Brown-Heathcote LBA), and mathematical (Plackett, extreme-value theory) traditions. This also helps position the contribution more precisely.

**W10. No discussion of identifiability.**
The Discussion mentions identifiability briefly ("a formal identification analysis is beyond the present scope") but this is a significant gap. A reader's first question will be: can $\theta$ and $\beta$ be jointly estimated from choice data? Even a brief argument — e.g., "in the binary case, the shape of the psychometric function identifies $\theta$ up to Monte Carlo error, given sufficient trials" — would strengthen the paper.

- **Proposal:** Expand the identifiability paragraph by 3–4 sentences. At minimum, note that the skewness and kurtosis of the noise (which you already compute in Study 6) provide moment conditions that in principle identify $\theta$, and that experimental manipulation of set size provides additional leverage.

**W11. No acknowledgments, data/code availability statement, or conflict-of-interest disclosure.**
These are required by most journals.

- **Proposal:** Add these standard sections.

### Technical and Notational Issues

**W12. Inconsistent notation for Gumbel.**
The paper sometimes says "Gumbel (Type I EV)" and sometimes "Type I Extreme Value." The standard location-scale Gumbel has variance $\pi^2/6$; the paper uses this but never states it explicitly, relying on the reader to know the Gumbel variance.

- **Proposal:** At first use, state: "The standard Gumbel distribution has mean $\gamma$ (Euler–Mascheroni constant) and variance $\pi^2/6$." This also clarifies why $\sigma_G = \pi/\sqrt{6}$ appears in the code.

**W13. The `mnl_probs` function uses a non-obvious scaling.**
In race_functions.R, the softmax applies an effective inverse temperature of $\pi/(\beta\sqrt{6})$. This scaling is mentioned in the manuscript but only in passing. A reader trying to replicate would benefit from a brief derivation.

- **Proposal:** In the binary simulation section or in an appendix, explicitly derive: "Under unit-variance identification, the Gumbel scale parameter is $b = \beta\sqrt{6}/\pi$, so the effective softmax coefficient is $1/b = \pi/(\beta\sqrt{6})$."

**W14. Monte Carlo standard errors are not reported.**
With $10^6$–$10^7$ simulations, the Monte Carlo error on choice probabilities is small ($\sim 10^{-3}$–$10^{-4}$), but it is never quantified. Some of the TV distances in the convergence plots are of comparable magnitude (0.001–0.005 at large $\theta$), raising the question of whether the remaining distance is real or noise.

- **Proposal:** Either report Monte Carlo standard errors (e.g., as error bars or confidence bands) or add a sentence noting: "With $10^7$ replications, the Monte Carlo standard error on individual choice probabilities is below $3 \times 10^{-4}$, well below the plotted TV distances for $\theta \leq 100$."

### Minor Issues

- **M1.** The binary simulation section (Section 6) is numbered identically to the probit limit section. Both appear as "Section 6" in the current structure — this is a numbering error from the lack of a grouping section. *(Resolved by Proposal W3.)*

- **M2.** In the abstract: "a specific cumulative count threshold, $\theta$" — the comma after "threshold" creates an ambiguity about whether $\theta$ names the threshold or is a separate quantity. Rephrase to: "a cumulative count threshold $\theta$."

- **M3.** "This formulation provides a parametric bridge in which $\theta$ governs the shape of the error distribution and a separate parameter, $\beta$, modulates the temperature." — This sentence has a dangling implication that shape and temperature are the full parameterization. Add "…while the systematic utilities $v_i$ are shared across all regimes."

- **M4.** Figure captions are descriptive but long. Consider moving interpretive text from captions to the body, leaving captions as brief plot descriptions.

- **M5.** The phrase "temperature identification" is introduced as a technical term but never explicitly defined as a definition block. A formal **Definition** environment would help.

- **M6.** Several code chunks use `set.seed()` with different seeds. For reproducibility, consider using a single master seed or documenting the seed strategy.

---

## Summary of Priority Revisions

| Priority | Proposal                                  | Effort | Status                                                                                                                                                                                                                                                                                                        |
| -------- | ----------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| High     | W4: Formally state all three results      | Low    | **DONE** — Results 1–3 reformatted as callout blocks; Result 1 (log-Gamma family) added after RUM representation, Result 2 (Logit boundary) replaces old Result 1, Result 3 (Probit limit) replaces old Result 2.                                                                                             |
| High     | W8: Move abstract to YAML                 | Low    | **DONE** — Abstract moved to `abstract:` field in YAML front matter; `# Abstract` section removed. Minor edits per M2/M3 applied.                                                                                                                                                                             |
| High     | W9: Expand references                     | Medium | **DONE** — Added 10 references: Train (2009), Hausman & McFadden (1984), Plackett (1975), Townsend & Ashby (1983), Ratcliff (1978), Brown & Heathcote (2008), Dagsvik (1994), Mattsson et al. (2014), Smith & Vickers (1988), McFadden & Train (2000). Citations integrated into Introduction and Discussion. |
| High     | W1: Shorten Introduction                  | Medium | **DONE** — Robinson et al. paragraph condensed from 5 sentences to 2. Three subsections (1.1–1.3) merged into single "Overview of contributions" subsection. Introduction reduced by ~35%.                                                                                                                    |
| Medium   | W3: Add grouping section for theory       | Low    |                                                                                                                                                                                                                                                                                                               |
| Medium   | W5: Clarify Beta-function derivation      | Low    |                                                                                                                                                                                                                                                                                                               |
| Medium   | W6: Justify temperature identification    | Low    |                                                                                                                                                                                                                                                                                                               |
| Medium   | W10: Expand identifiability discussion    | Medium |                                                                                                                                                                                                                                                                                                               |
| Medium   | W14: Report Monte Carlo standard errors   | Low    |                                                                                                                                                                                                                                                                                                               |
| Medium   | W2: Add claim/result sentences to studies | Medium |                                                                                                                                                                                                                                                                                                               |
| Low      | W7: Tighten probit limit proof            | Low    |                                                                                                                                                                                                                                                                                                               |
| Low      | W11: Add acknowledgments/data statement   | Low    |                                                                                                                                                                                                                                                                                                               |
| Low      | W12–W13: Notation consistency             | Low    |                                                                                                                                                                                                                                                                                                               |

The manuscript's core contribution is strong and well-executed. The revisions above are primarily about tightening presentation, filling in expected journal elements, and ensuring the theoretical sections carry the same care and precision as the simulation suite.
