+++
date = '2026-04-06T13:15:06Z'
draft = true
title = 'Agentic Programming Rules of Thumb'
tags = ['ai', 'llm', 'agentic', 'programming', 'workflow']
+++

# How to work with AI
Like everybody else, I am trying to figure out how to use AI effectively in my software job and my computer hobbies. 


# My rules of thumb
* Keep emotions out of it. Each irrelevant token in my prompt may reduce the quality of the output. Don't insult, greet, or praise the AI.
* Use repository level instructions for the AI. Currently I call that `AGENTS.md`. I saw other suggestions. I don't think the industry has coalesced around a stardard `~/.agentsrc` -- that would be nice.
* Think about the problem. A lot. The more you can partition the problem in well defined steps, the better the output. 
    * If you don't know what the steps are, the first step totally can be to ask the AI to help you break down your vague problem.
    * Err on the side of small steps
* **Restart often**. This is probably a good rule of thumb anyways. Every. Bit. Of. Irrelevant. Context. will reduce the quality of your output. Once you're done with "write a pytest tests/test_some_feature.py::test_some_bug asserting X and Y and veriying such and such". Kill your session, start a new one for the next step.
* word your prompt as precisely as possible. 
    * the AI ... may understand what "add support in the function for dictionaries in addition to lists", but it will understand much better "in function foo(l: list), refactor the function for l to be either a list, or a dictionary. If the user supplies a list, maintain the current behavior. If the use supplies a dictionary: ignore the keys, extract the values into a list (or iterable) and treat tha collection the same way foo used to process the list when it was the only input allowed".
    * you are less likely to run a sterile back and forth session with the AI.
    * If your session got polluted with back and forth arguing with the AI, the AI seems to ignore your new instructions, you are likely to have better, more precise understanding of your problem. Use this failure as an opportunity to work your prompt better and start over.
* Use files for output. Instruct the AI to write its output in `plan.MD`, or in `tests/test_some_bug.py`. It is much easier to track and review.


# patterns

## Work on the problem, **then** work on the solution.
**Step 1: define the problem.**

in a loop.
    1) write everything you know about your problem in a document (problem.md)
        1.1) this is meant to be a rapid step. don't focus on grammar, style, etc. Focus on writing down everything relevant to the problem.
    2) ask the AI to review the AI and notify you of anything that's either unclear, imprecise, or redundant.
    3) ask the AI to tell to list you additional details it would like to know about your problem. Instruct the AI to ignore your document structure/grammar unless it renders it ambiguous.

when the AI is starting to be pedantic or irrelevant, consider the grievances in your instructions. for example you might have to tell it "there are so absolute benchmark for query performance on this system, I will need to evaluate performance manually. We nonetheless state that evaluating performance is an objective of the problem"

**Step 2: ask the AI to edit your problem**
the objective after this step is to have a plan that you understand, and that is written in a logical flow matching what you will try to accomplish. Provide instructions resembling:

> format document plan.md into an operational, chunked plan for my problem. Use simple steps. Focus on adding all the details relevant to each step and nothing else. Keep language dry.

Best practices to instruct the AI on this task are TBD and may depend on your problem, AI engine used, etc.

**Step 3: solve each step independently**
For each step, review the plan carefully. Modify the current step based on finding an the previous steps if required. Then instruct the AI to solve that step, in a new session, with only the context relevant to this step.


# Links
I did not find many "guides" like the one that I am attempting to write on "how to get good, long term, using robots in softmare projects, small or large".

Simon Willison built one that looks exactly like my vision: https://simonwillison.net/guides/agentic-engineering-patterns/

TODO: I was probably just not wording properly, let's maintain this list.