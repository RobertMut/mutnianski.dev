---
title: Multiple smaller models or large one?
description: Selected arxiv preprints comparing specialized LLMs and single agent systems vs. multi agent systems
reading_time: 4 min read
---

*This article was written in October 2026, and can become outdated*

# Multiple smaller models or large one?

Top AI companies participate in a race to create the most intelligent and best-performing model. This competition forces businesses to showcase the capabilities of their frontier models, [costing thousands of dollars (Anthropic, 2026)[1]]. Not everyone can afford such a showcase because of high prices or strict budgets.
When champions with massive budgets clash with each other, is there a place for something smaller? Even top players release cheaper (and smaller) versions of their models. There are also hundreds of other LLMs, and many of them can even run on a personal computer. A smaller model costs only a fraction of a frontier one.
With this in mind, it's worth checking whether anyone has achieved this, and if it is really useful. Otherwise, we risk wasting time and money and missing deadlines.

# David vs Goliath
[Christou and Tsoumakas (2026)][2], categorized multiple small language models (SLMs) by scale to: sub-billion, small (3B). Three model families were selected: SmolLM, Qwen and Llama. Each prompt was in natural language, and models were evaluated in zero-shot and few-shot format (for SLM), checking how they perform under different amount of context. Each model was fine-tuned under three regimes: GenTune (general domain datasets), LitTune (literary domain dataset), MixTune (mixed dataset). In total 5 SLMs were tested in 30 fine-tuned configurations, for the following task: a sentence-level relation classification given marked entity mentions. Results showed that SmolLM3-3B scored best (0.833) with LitTune for literary benchmark (0-shot prompt), and Llama-3.2-3B-Instruct (0.844) for general benchmark with GenTune (2-shot prompt). These results exceeded GPT-5.4 (0-shot, 0.693 - general, 0.578 - literary) and Claude Sonnet 4.6 (0-shot, 0.662 - general, 0.530 - literary). In this study, sub-billion models gained more from 2-shot prompting. MixTune remains a practical choice when both domains must be covered (literary and general).

# Multiple Davids vs Goliath
One specialized SLM for a task can beat a multi-purpose frontier LLM. But what about several smaller models versus one larger model? [Żywot et al. (2026)][3] checked Qwen3 models (8B, 32B parameters), by allowing an orchestrator to give tasks to specialized sub-agents that could write to a structured shared memory. The orchestrator, however, can read and write to the memory. This configuration was compared with a single LLM without sub-agents or shared memory. The framework used for this conference paper consists of an orchestrator (delegating work), a web-search agent, a coder and a file inspector. All agents share the same structured memory. The evaluation used four thinking configurations: None, Sub-agent only (thinking only for sub-agents), Orchestrator (thinking only for orchestrator), All (thinking enabled for both).

|                         ![Żywot et al. Table 1. Section 5.1]({{ site.url }}{{ site.baseurl }}/assets/img/20261027smallermodels/zywot_table.png)                         |
| :----------------------------------------------------------------------------------: |
| *[Table 1. Sec. 5.1: SMALL MULTI-AGENT SYSTEMS VS. LARGE SINGLE-AGENT MODELS][2]* |
The multi-agent system with thinking enabled for both (`All`) beat the larger 32B model on two benchmarks: GAIA (end-to-end tool use) and AIME (mathematical problem-solving), and achieved comparable or the same results for MuSiQue (multi-hop retrieval) and GPQA (graduate-level science Q&A). The biggest win for the large model comes from HLE (domain expert question benchmarks). Adding sub-agent thinking on top (`All` thinking) brings marginal accuracy gains, whereas enabling thinking only for sub-agents provides nearly no benefit. Furthermore, sub-agent size becomes negligible, when the orchestrator is allowed to think: 1.7B, 8B, and 32B workers scored 23%, 23% and 23.6%, so the orchestrator provides only moderate gains where more benefit comes from enabling thinking. This suggests that the bottleneck is the planner, not the executor.

# Single agent better than multi-agent system?
Even if multi-agent system (MAS) collaborating with external tools rivalled a larger model, there is still a place where SAS can come into play, by comparing architectures.
[Tran and Kiela (2026)][4] evaluated different MAS architectures, SAS and SAS with longer thinking (SAS-L) on FRAMES (Factuality, Retrieval, And reasoning MEasurement Set) and MuSiQue (4-hop). The different MAS include sequential multi-agent (Seq), subtask parallel (Sub), parallel roles (Roles), debate (Deb) and ensemble (Ens).

|                  ![Tran and Kiela Table 1. Section 5.1]({{ site.url }}{{ site.baseurl }}/assets/img/20261027smallermodels/trankiela_table.png)                   |
| :---------------------------------------------------------------------: |
| *[Table 1. Sec. 5.1: Single-agent (SAS) vs. multi-agent architectures][3]* |
Here are observations where SAS/SAS-L have higher or equal scores:
- Qwen3-30B-A3B: SAS between 500-1K tokens range in FRAMES benchmark and 500-10k in MuSiQue.
- DeepSeek-R1-Distill-70B: SAS-L in 500, SAS-L/SAS (same result) for 1K, 2k-5k range for SAS in FRAMES, and SAS 500-10k in MuSiQue (big difference favouring SAS).
- Gemini 2.5 Flash - SAS 1k in FRAMES, and SAS-L 500-10k in MuSiQue
- Gemini 2.5 Pro - SAS 1k-2k in FRAMES, SAS-L 2k in MuSiQue.
SAS achieved better or similar scores to MAS in most benchmarks, but MAS reasoning becomes competitive and can be better. In nearly all results MAS produces more thinking tokens in comparison to SAS. But, if we consider closed-source models for high-stakes prompts requiring more than 5K tokens, Debate or Ensemble/Parallel-Roles could be reasonable, as the accuracy gap for SAS with Gemini 2.5 Pro is significant.

# Who won?
There is no simple answer that settles this debate due to too many specialized tasks, constraints, and possibilities. On one hand supervised task-adapted small models achieved higher scores in comparison to the tested frontier models with zero-shot prompt, on the other hand orchestration of smaller general-usage models dedicated to narrow set of task could beat or provide comparable result to the bigger LLM. This problem is getting more complicated when number of tokens come into play, and different architectures of LLMs and even MAS. We have seen that SAS is still in play for smaller token budgets or an open-weight model, but debate MAS still performs better or similarly with longer context and a closed-weight model. More research and empirical studies are required to fully uncover the answer, as current results provide only initial insight into the topic.

# Links:

- ‘Building a C Compiler with Parallel Claudes’. 5 February 2026.[https://www.anthropic.com/research/building-c-compiler](https://www.anthropic.com/research/building-c-compiler).
- Christou, Despina, and Grigorios Tsoumakas. ‘Sub-Billion, Super-Frontier: Small Language Models Rival Zero-Shot Frontier LLMs on General and Literary Relation Extraction’. arXiv:2606.22606. Preprint, arXiv, 21 June 2026. [https://doi.org/10.48550/arXiv.2606.22606](https://doi.org/10.48550/arXiv.2606.22606).
- Żywot, Agata, Xinyi Chen, Yifei Yuan, Anders Søgaard, and Maarten de Rijke. ‘Can Small Agents Collaborate to Beat a Single Large Language Model?’ arXiv:2601.11327. Preprint, arXiv, 13 April 2026. [https://doi.org/10.48550/arXiv.2601.11327](https://doi.org/10.48550/arXiv.2601.11327).
- Tran, Dat, and Douwe Kiela. ‘Single-Agent LLMs Outperform Multi-Agent Systems on Multi-Hop Reasoning Under Equal Thinking Token Budgets’. arXiv:2604.02460. Preprint, arXiv, 11 April 2026. [https://doi.org/10.48550/arXiv.2604.02460](https://doi.org/10.48550/arXiv.2604.02460).

[1]: ‘Building a C Compiler with Parallel Claudes’. 5 February 2026.[https://www.anthropic.com/research/building-c-compiler](https://www.anthropic.com/research/building-c-compiler).
[2]: Christou, Despina, and Grigorios Tsoumakas. ‘Sub-Billion, Super-Frontier: Small Language Models Rival Zero-Shot Frontier LLMs on General and Literary Relation Extraction’. arXiv:2606.22606. Preprint, arXiv, 21 June 2026. [https://doi.org/10.48550/arXiv.2606.22606](https://doi.org/10.48550/arXiv.2606.22606).
[3]: Żywot, Agata, Xinyi Chen, Yifei Yuan, Anders Søgaard, and Maarten de Rijke. ‘Can Small Agents Collaborate to Beat a Single Large Language Model?’ arXiv:2601.11327. Preprint, arXiv, 13 April 2026. [https://doi.org/10.48550/arXiv.2601.11327](https://doi.org/10.48550/arXiv.2601.11327).
[4]: Tran, Dat, and Douwe Kiela. ‘Single-Agent LLMs Outperform Multi-Agent Systems on Multi-Hop Reasoning Under Equal Thinking Token Budgets’. arXiv:2604.02460. Preprint, arXiv, 11 April 2026. [https://doi.org/10.48550/arXiv.2604.02460](https://doi.org/10.48550/arXiv.2604.02460).
