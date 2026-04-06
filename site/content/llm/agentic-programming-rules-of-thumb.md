+++
date = '2026-04-06T13:15:06Z'
draft = true
title = 'Agentic Programming Rules of Thumb'
tags = ['ai', 'llm', 'agentic', 'programming', 'workflow', 'AI-reviewed']
+++

## How to work with AI

Like everybody else, I am trying to figure out how to use AI effectively in my software job and my computer hobbies.

## Rules of thumb

- **Keep emotions out of it.** Every irrelevant token in a prompt may reduce output quality. Don't insult, greet, or praise the AI.
- **Use repository-level instructions.** I currently use `AGENTS.md` for this. I've seen other naming suggestions. The industry hasn't settled on a standard like `~/.agentsrc` — that would be nice.
- **Think about the problem. A lot.** The better you partition a problem into well-defined steps, the better the output.
    - If you don't know the steps, the first step can be asking the AI to help break down your vague problem.
    - Err on the side of small steps.
- **Restart often.** Every bit of irrelevant context reduces output quality. Once you finish a task like "write a pytest `tests/test_some_feature.py::test_some_bug` asserting X and Y and verifying Z" — kill the session, start a new one for the next step.
- **Word your prompt as precisely as possible.**
    - The AI may understand "add support in the function for dictionaries in addition to lists." It will understand much better: "In function `foo(l: list)`, refactor `l` to accept either a list or a dictionary. If the user supplies a list, keep the current behavior. If the user supplies a dictionary: ignore the keys, extract the values into a list (or iterable), and process that collection the same way `foo` used to process the list."
    - Precise prompts reduce the chance of a fruitless back-and-forth.
    - If a session got polluted with arguing — the AI ignoring your new instructions — you likely now have a better understanding of the problem. Use that failure to write a sharper prompt and start over.
- **Use files for output.** Instruct the AI to write to `plan.md` or `tests/test_some_bug.py`. Easier to track and review.

## Patterns

### Work on the problem, then work on the solution

**Step 1: define the problem.**

Loop:

1. Write everything you know about the problem in a document (`problem.md`).
    - This is meant to be rapid. Don't focus on grammar or style. Focus on writing down everything relevant.
2. Ask the AI to review the document and flag anything unclear, imprecise, or redundant.
3. Ask the AI to list additional details it needs about your problem. Instruct it to ignore document structure and grammar unless they cause ambiguity.

When the AI starts being pedantic or irrelevant, address it in your instructions. For example: "There are no absolute benchmarks for query performance on this system. I will evaluate performance manually. We still state that evaluating performance is an objective."

**Step 2: ask the AI to edit your problem document.**

The objective: a plan you understand, written in a logical flow matching what you will try to accomplish. Prompt something like:

> Format document `plan.md` into an operational, chunked plan for my problem. Use simple steps. Include all details relevant to each step and nothing else. Keep language dry.

Best practices for this step are TBD and likely depend on the problem and the AI engine used.

**Step 3: solve each step independently.**

For each step, review the plan carefully. Modify the current step based on findings from previous steps if needed. Then instruct the AI to solve that step in a new session, with only the context relevant to it.

## Links

I haven't found many guides on "how to get good, long-term, at using AI in software projects" — small or large.

- [Simon Willison — Agentic Engineering Patterns](https://simonwillison.net/guides/agentic-engineering-patterns/) — closest to what I'm trying to build here.

TODO: I was probably just not wording my searches well. Maintain this list.