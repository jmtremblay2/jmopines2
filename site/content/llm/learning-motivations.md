+++
date = '2026-04-03T23:43:34Z'
draft = false
title = "Why I'm Learning LLMs"
tags = ['llm', 'learning', 'motivation', 'AI-reviewed']
+++

## Motivation

Part **curiosity** — I like gardening, math, geology, history, psychology, and now this. Part **continued employment**. I don't shine at working faster or adopting the coolest tools. I am, however, capable of thinking critically and **asking why**, even when it bothers everyone else.

AI will disrupt the technology landscape. It's also opening opportunities. We have to figure out what they are.

Software engineers don't work the way they did five years ago. Five years ago I was reprojecting maps in tile servers. Today I develop data pipelines for robotic applications. I want to be ready for whatever comes next.

## What I Want to Learn

My objective is to understand how LLMs work. Specifically:

### When they work, when they don't

- When they tend to fail — and what I can do about it
- Why they sometimes cycle between telling you something and the complete opposite
- See the example applications below for the kind of tasks I have in mind

### Getting predictable results

- Improve **consistency**: different outputs should not contradict each other on similar input
- Improve **quality**: more relevant, more insightful output
- Reduce instances of the model flat-out ignoring instructions ("For the 4th time: use UV when running Python. DO NOT set a virtual environment yourself.")
- Learn to manage context windows effectively

### Diagnosing problems

- Tell apart: me failing at using the model vs picking the wrong model vs feeding bad information
- Identify when the model is capable but outdated — doesn't "know" about breaking changes in a library, for example

### Comparing models

- Evaluate paid vs local models
- Evaluate free public models (and paid ones too, since that's what I use professionally)
- Measure consistency and quality: does Claude give a more complete answer than Llama for task X, and does it do so reliably on the same input?

### The math

I used to be a legit statistician. I want to understand LLMs at the mathematical level:

- Embeddings: what they mean, how they're computed
- Transformer steps: be able to trace 1–2 iterations on paper and understand what I'm achieving
- Encoders only vs decoders only, model heads
- Enough depth to build real intuition, not just hand-waving

### Prompt engineering

Get good at getting the model to do what I want, as cheaply and quickly as possible.

### Dealing with scale

Large contexts — very large code bases, very large documents. "Large" meaning tasks that exceed current model capacity. At the time of writing, models I use stretch to 100K–200K tokens. What about a codebase with 2M lines? What about parsing GBs of logs for trends? (AI may not be the first tool for that last one.)

### Privacy

- From my ISP, my employer, my family, hackers, the government, Google, my job
- Example: suppose I'm setting up a VPN to keep my government from knowing that _Facebook_ (or _The Onion_ — same thing really) is my main news source. Neither my government nor my wife should know about this.
- I want to supply an API key to the AI when asking it to configure something, with confidence it's handled properly. With public models I don't expect this. On my LAN, I should be able to achieve it.

## What I Want to Build

My interest in LLMs centers on technical work, technical writing, and professional development. Concrete examples:

- **Router configuration** — advanced setups: separate networks with firewall rules, VPN gateways, site-to-site VPNs
- **Home lab** — media servers, VPN endpoints, related projects
- **Home automation** — Z-Wave thermostat with Home Assistant, rules, power bill monitoring
- **Technical writing** — have the AI document finished projects, identify gaps in my documentation trail, make updating this website easier when I have interesting results
- **Finish stalled projects** — ones resembling the above
- **Vibe code** — example: a small app to track HSA receipts. Go to `myapp.mydomain.com`, scan a receipt, parse it, attach metadata, store results and images in a database for claims. Achievable but not trivial. We'll see where it takes me.

## Hardware

I have two Nvidia GPUs on hand:

| GPU | VRAM |
|-----|------|
| RTX 3090 | 24 GB |
| A30 | 24 GB |

Plus 96 GB of DDR5 RAM for spillover. Consumer-grade GPU limitations prevent pooling the GPU memory, but I can run a sizable collection of models with this setup.

My plan: accept the speed penalty of memory swapping to run larger, allegedly better models and see what they're actually capable of. I don't mind waiting 5–10 minutes on a big model as a test — especially for **reproducible and valid** answers on complex queries.

Examples of complex queries:

- *Multi-step with information retrieval*: "Set up a separate network on my router with a VPN gateway. Figure out the WireGuard interface config. Make sure traffic never spills to other gateways. Make sure I can test it. Handle a DNS entry for the remote endpoint instead of a static IP — if the router doesn't support it, find a workaround."
- *Messy real-world context*: "Read this massive email chain. Help me gauge the client's mood and decide the next step. Pull context from my codebase, git history, or some other system if it helps."

I also have access to an RTX 5070 (12 GB VRAM) through my work at Forterra. I don't do much after-hours development, but sometimes it's the only machine available and I can test an idea during lunch. (Yes — I got approval from our cybersecurity team.)

What I really want is to play with the software and the hardware. Run models locally as much as possible. I don't object to commercial models either.

## Evaluating Output

I want a better mental picture of how to evaluate LLM output — and how to manage the volume of text these models produce without losing my mind.

I'm not trying to understand everything. If the AI writes a parser for a crappy file format and I understand the spec, I'm not going to micromanage it. But I want to stay on top of things so I can keep iterating **and stay confident** the output is good. In my experience, this is hard in general — and not easier with AI.

- This is open-ended by definition. The AI outputs tons of text. Am I supposed to save it? Save what I fed it? How do I keep track? What's worth keeping and what's not?

## What I'm NOT Doing

- Not pursuing heavy agent integration yet. I'm fine talking to a Python script for now.
- Not starting a company or creating anything novel.
- Not focused on scaling — my objective is mastery of the tool, not productizing my learning.

I do want to use what I build reliably in my home lab. Maybe my wife can tap into the resources too.

---

## Potential Leads Going Forward

> *The ideas below were suggested by AI (Claude) based on the goals above. They're not commitments — just threads worth pulling on.*

- **RAG (retrieval-augmented generation)** — I'm already building this with vyosindex/ChromaDB, but it's not listed as an explicit learning objective. Chunking strategies, embedding models, vector similarity, and retrieval quality are worth studying deliberately.
- **Fine-tuning vs RAG vs in-context learning** — when to use each, and the tradeoffs. Directly relevant to the "outdated model" question.
- **Quantization and model formats** — running big models on consumer hardware means understanding quantization levels and their impact on quality, speed, and memory.
- **Reproducibility** — seeds, temperature settings, and the fundamental non-determinism of GPU floating point. Even `temperature=0` doesn't guarantee identical outputs across runs.
- **Hallucination detection and grounding** — goes beyond "when they fail." Specific strategies: verifying outputs, forcing citations, grounding responses in source material.
- **Cost analysis** — token pricing for API models, electricity and time cost for local inference, and when local vs cloud makes economic sense.
- **Security and prompt injection** — what "private" really means locally vs through an API, and how prompt injection attacks work.
- **The math curriculum** — subtopics worth scoping: attention mechanism, transformer architecture, tokenization, loss functions, backpropagation, softmax, positional encoding. That's a curriculum in itself.
- **Evaluation frameworks** — formal benchmarks and task-specific eval approaches, even if not used directly.
- **Multi-modal models** — vision, audio, code. The hardware supports it. Worth deciding if this is in or out of scope.
- **Model selection heuristics** — how to quickly pick the right model for a task without trial and error every time.
