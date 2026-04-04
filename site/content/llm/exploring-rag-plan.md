+++
date = '2026-04-04T13:38:29Z'
draft = true
title = 'Plan to Learn and Test RAG Concepts'
tags = ['RAG', 'VyOS', 'AI-reviewed']
+++

## Background

I run a [VyOS](https://vyos.io/) router at home. I am happy with the product, but I waste time remembering CLI commands for non-trivial tasks. It is CLI-only. I previously used OPNsense and the UI-only configuration drove me crazy. I gave up after wasting three combined days trying to set up a site-to-site VPN -- it still did not work.

VyOS changed their CLI API at some point (I think), so AI output (Claude, ChatGPT) often needs tweaking. I am not sure how much the CLI actually changed, whether the AI training data is outdated, or whether the models are just making things up. I have hit many instances of invalid commands from commercial AI. At the time of writing, I could not find an official statement on breaking CLI changes in VyOS -- I did not look that hard.

Part of this project would be to explore and document these changes if they are not well covered. For instance, an AI should be capable of ingesting two large documentation sets (VyOS 1.2, released January 2019, vs VyOS 1.3, released December 2021 -- [source](https://docs.vyos.io/en/1.4/introducing/history.html)) and producing a list of breaking changes. This would also help characterize AI failures into two buckets:

- **Hallucinations** -- the AI produces something that was never valid.
- **Outdated training** -- the AI produces something that was correct in older documentation.

This may look like a side goal, but it is a good exercise for a RAG project. You use the different concepts, combine them, and learn.

## Prompts I Want to Test Retrieval For

These are example prompts I want to evaluate retrieval quality and AI accuracy on. I may try some of them and tweak them as I make progress -- they are not a fixed list.

Each prompt includes a reworded version for AI consumption. The reworded prompt is what I would actually send to the model during evaluation.

*The blockquoted prompts below were written by Claude Opus 4.6 (GitHub Copilot, April 2026). They rephrase the original intent using more precise network terminology.*

- **Static IP assignment** -- assign a static IP on a specific network to a MAC address. Optionally generate the MAC from the desired IP. Given the IP, the AI should figure out which network it belongs to, generate the MAC, and apply the config.

  > **Prompt:** On a VyOS router, generate a locally-administered MAC address derived from IP `192.168.10.125`. Determine which network `192.168.10.125` belongs to by inspecting the router's existing interface configuration. Assign a DHCP static mapping for host `jm-rag` binding that MAC to `192.168.10.125` on the correct subnet. Output the full sequence of VyOS `set` commands.

- **VPN interfaces** -- WireGuard, OpenVPN.

  > **Prompt:** Given the following WireGuard configuration file, create a VyOS `wg10` tunnel interface with the correct private key, listen port, peer public key, allowed IPs, and endpoint. After applying the config, provide the VyOS operational command to verify the interface is up and the handshake succeeded.

- **Network creation** -- apply routing and firewall rules. Example: create a network, assign a VLAN tag, block all traffic to other local networks, and use it for my work computer.
  - Networks with different DNS configs.
  - Networks with VPN gateways.

  > **Prompt:** On a VyOS router, provision a new Layer 2 segment `JM-WORK` as a VLAN sub-interface (VID 11) on the trunk-facing parent interface. Assign the subnet `192.168.11.0/24` with the router as the default gateway at `.1`. Configure a DHCP pool for the subnet with an appropriate lease range and DNS forwarder. Apply zone-based firewall policies so that: (1) all ingress from other local zones to `JM-WORK` is dropped (deny inter-VLAN routing inbound), (2) all egress from `JM-WORK` to other RFC 1918 destinations is dropped (deny inter-VLAN routing outbound), and (3) egress to non-RFC 1918 destinations (i.e., the internet) via the default route is permitted with stateful connection tracking (`established`/`related` return traffic allowed). Output every `set` command required, covering the VLAN sub-interface, DHCP server scope, and firewall rule-set assignments to the zone or interface direction.

- **Port forwarding** -- ports 22, 80, 443, etc. routed to specific VMs in the LAN. Bonus points for reading my specs from elsewhere and figuring it out automatically.

  > **Prompt:** On a VyOS router with WAN interface `eth0` (public-facing, DHCP or static WAN address), configure a DNAT (destination NAT) rule to translate inbound TCP SYN packets on port 22 arriving on `eth0` to the internal host `sshbastion` at `192.168.10.50:22`. Add a corresponding stateful firewall rule on the `WAN_IN` (or equivalent `in` direction on `eth0`) rule-set to accept `established`/`related` return traffic as well as new connections matching the DNAT translation. If a source-NAT masquerade rule already covers outbound traffic, confirm that hairpin NAT is not required for this case. Output all `set` commands for the NAT destination rule and the firewall rule entry.

- **Advanced DNS** -- example: `coolservice.mydomain.com` points to my public IP externally, but `coolservice` is a LAN host. I want `coolservice.mydomain.com` to resolve to a reverse proxy on port 443 when queried from inside the LAN. This is a hack, but the AI should either handle it or suggest a better approach.

  > **Prompt:** On a VyOS router acting as the LAN's recursive DNS forwarder, the A record for `coolservice.mydomain.com` resolves to my WAN IP via public DNS. Internally, `coolservice` is a host at `192.168.10.30` running a TLS reverse proxy on port 443. Configure a DNS split-horizon override so that queries for `coolservice.mydomain.com` originating from any LAN zone return `192.168.10.30` instead of the public address (e.g., a static host mapping or an authoritative local zone entry). If split-horizon is suboptimal for this topology, evaluate alternatives -- such as destination NAT hairpin (NAT reflection) or a dedicated internal authoritative zone -- and compare their tradeoffs in terms of TTL handling, certificate validation, and operational complexity.

## Stretch Goals

These are harder, multi-stage projects where AI with accurate documentation would help significantly. Again, just examples -- these may evolve.

- **Config audit** -- feed the entire VyOS config from my router (maybe 10--20 pages of commands) into the AI. Have it evaluate the config: generate firewall tests for external security problems, identify unused interfaces, flag dead configuration.

  > **Prompt:** I am providing my full VyOS running configuration (approximately 15 pages). Analyze it for: (1) firewall rules that leave external-facing ports unintentionally open, (2) interfaces or address assignments that are defined but never referenced by any routing, NAT, or firewall rule, and (3) any deprecated or redundant configuration stanzas. For each finding, cite the specific config lines involved and recommend a fix using VyOS `set` or `delete` commands.

- **CI/CD on configs** -- run a virtualized cluster (router, hosts, etc.), apply new configs in staging, and run a security audit against the virtualized network.

  > **Prompt:** Given the attached VyOS configuration and a set of proposed changes (adding the `JM-WORK` network from previous examples), produce a `docker-compose.yml` or equivalent setup that spins up a virtualized VyOS instance and two stub hosts. Apply the base config, then apply the proposed changes. Write a test suite (shell scripts or pytest) that validates: the new VLAN interface is reachable, inter-VLAN traffic is blocked as expected, and internet access from the new network works. Execute the tests and report results.

## Test Prompts

I want to define prompts at varying difficulty levels to benchmark AI performance with and without RAG.

### Easy

- Generate a random MAC address for host `jm-rag` and assign it to `192.168.10.125` on the LAN.
- Forward port 22 to host `sshbastion.domain.com` (where `sshbastion` is a host on the LAN).

### Medium

- Create a new network `JM-WORK` with CIDR `192.168.11.0/24`. Follow up with:
  - Block all traffic between it and other networks. No host outside `JM-WORK` can reach any host inside it.
  - Assign VLAN tag 11 to network `JM-WORK`.
- Given a WireGuard config, create a `wg10` tunnel. Provide a command to verify the interface is up.

### Hard

- Create a new network `REMOTE-NET` with CIDR `192.168.12.0/24` using `wg10` as the gateway. Configure all routes and firewall rules to allow traffic to and from the remote network. Assume the remote end is a simple LAN with CIDR `192.168.2.0/24`.
- Use the supplied config and apply changes (e.g., from the examples above) in a staging environment -- VMs, docker-compose, k3s, whatever works. Write tests to validate the new functionality and execute them in staging. Without RAG, the AI presumably would not have correct data to do any of this. This is fundamentally an integration problem.

## RAG Pipeline Plan

VyOS publishes their [documentation](https://github.com/vyos/vyos-documentation) on GitHub as RST files. From a quick glance it is mostly well structured.

I want to build a RAG pipeline using local and commercial models to:

1. Identify prompts the AI fails to answer without help.
2. Check whether providing VyOS documents along with the prompt improves the response -- whether or not the baseline response was already correct.

On initially correct responses (without RAG), I do not want to turn a valid answer into an invalid one by supplying wrong, irrelevant, or badly processed information. Checking for **regressions** matters. If the AI answers a prompt correctly on its own and then fails when given additional context, that invalidates your methodology (at least partially).

### Chunking and Indexing

- Chunk the entire VyOS documentation into block documents.
- Store them in a vector database -- or any database that supports retrieval of relevant blocks given a query.
- Defining "relevant" is expected to be hard, but the requirement is loose to start. Early on, I can separate the task of retrieving documents (rules, heuristics, etc.) from the task of using retrieved information in the model. I can even have a human or the AI in the loop for triage.

### Retrieval Strategy

- Define a framework for querying the database in a way that lets me assess results before automating.
- I probably cannot do a single vector search on a long compound prompt like "define a VPN interface using WireGuard with a DNS endpoint for the remote peer, and use it as a gateway for a new net with these properties" -- it will latch on to too many things. Instead, I can split the query into focused search terms: "WireGuard interface," "DNS address for WireGuard," "set up new network," "configure gateway of network." The usage would have to be intentional when prompting. I do not think that is a bad thing.
- **Ranking problems** -- I doubt the vector DB results will come back well ordered. A chunk that happens to be a header with the exact text "set up new network" would always rank as the best match for that query, but lower-ranked documents might be more relevant. I want to find mitigating solutions. One idea: the AI keeps probing the document DB until the matches are clearly drifting from the original question. For instance, when searching for "configuring WireGuard," iteratively evaluate retrieved documents until the first one the AI judges as "not relevant." Tell the AI to use exactly that criterion.
- **Embedding models** -- what models do I need for embeddings? How much does the choice matter? Performance tradeoffs, memory usage.
- **Ranking validation** -- for lack of a better idea, send the top 10--20 retrieved documents to a strong model (at the time of writing, Claude Opus 4.6) and ask whether the ranking is valid. How exactly to frame that question is TBD.

### The Pipeline

A Python program that:

1. Receives a prompt, possibly with some expected structure.
2. In a loop or simple sequence, retrieves documents from the vector DB.
3. Constructs a final prompt to feed to the AI -- including back-and-forth with the user if the AI needs to clarify.
4. Returns the response to the user.

## Existing Frameworks

*This section was written by Claude Opus 4.6 (GitHub Copilot, April 2026). It surveys open-source RAG frameworks that are free to use for learning and production.*

Before building the entire pipeline from scratch, it is worth knowing what already exists. The RAG framework space has matured significantly. Some of these are low-level toolkits where you assemble your own pipeline from primitives; others are batteries-included platforms with a web UI and built-in document processing. The tradeoff is control vs. time-to-first-result.

I grouped these into three tiers based on how much they do for you. For this project -- local Ollama, VyOS RST docs, Python with uv, ChromaDB already in use -- the most relevant question is whether a framework adds value over the hand-rolled chunking and retrieval pipeline already under development.

| Framework | Type | Pros | Cons | Fit for this project |
|---|---|---|---|---|
| [LangChain](https://github.com/langchain-ai/langchain) | Orchestration | Massive ecosystem, swappable LLMs and vector stores, large community, good for prototyping many configurations. | Abstraction-heavy; frequent breaking changes historically; "chain" paradigm can obscure what is actually happening. | Viable but heavier than needed. The abstraction layers would hide the retrieval mechanics you are trying to learn. |
| [LlamaIndex](https://github.com/run-llama/llama_index) | Orchestration | Data-centric design, strong indexing and retrieval strategies, handles heterogeneous inputs (PDFs, APIs, databases), active community. | Complexity scales fast; documentation sometimes lags new features. | Strong fit if you want pre-built retrieval strategies (e.g., sentence-window, auto-merging) without reinventing them. |
| [Haystack](https://github.com/deepset-ai/haystack) | Orchestration | Clean pipeline model (nodes connected explicitly), production-grade, YAML or Python config, Apache 2.0. | Smaller ecosystem than LangChain; fewer tutorials and community examples. | Excellent match. Pipelines are easy to reason about and expose the retrieval math without too much magic. |
| [RAGFlow](https://ragflow.io/) | Full-stack platform | Built-in UI, deep document understanding (tables, images, complex layouts), Docker self-hosting, supports Ollama as backend, agentic workflows, MCP support. | Opinionated architecture; heavier resource footprint; less control over internals. | Good for getting a working system fast. Pairs well with Ollama. Overkill if the goal is to understand every step of the pipeline. |
| [Ragbits](https://ragbits.deepsense.ai/stable/) | Modular toolkit | Pythonic API with type-safe LLM calls (Pydantic), modular install (`pip install` only what you need), supports local LLMs via LiteLLM, built-in evaluation framework, MIT licensed, supports uv. | Smaller community; relatively new; fewer production case studies. | Interesting middle ground. The type-safe prompt system and modular design fit a Python-first workflow well. The uv support is a plus. |
| [RAGatouille](https://github.com/AnswerDotAI/RAGatouille) | Retrieval add-on | ColBERT late interaction retrieval (token-level scoring instead of pooled embeddings), lightweight, plugs into LangChain or LlamaIndex, can be used as a reranker without reindexing. | Not a full pipeline -- retrieval only. Requires understanding ColBERT's scoring model. | Worth experimenting with. Late interaction scoring is a fundamentally different statistical approach to similarity vs. cosine on pooled embeddings. Relevant to the ranking problems described above. |
| [LightRAG](https://github.com/HKUDS/LightRAG) | Graph + vector hybrid | Combines knowledge graphs with vector retrieval for relational queries, incremental updates (no full rebuild), open source. | More complex conceptually; graph construction adds a pipeline stage; newer project. | Interesting for relational queries ("what config depends on what") but adds complexity beyond what the initial pipeline needs. |
| [txtai](https://github.com/neuml/txtai) | All-in-one | Built-in vector DB and semantic search, knowledge graphs, pipelines, agents -- no external vector store needed. | Less mainstream; documentation quality varies; monolithic feel. | Self-contained option if you want to avoid managing a separate vector store. Not needed here since ChromaDB is already set up. |
| [Verba](https://github.com/weaviate/Verba) | Full-stack platform | Easy setup, transparent chat showing sources and highlighted chunks, supports Ollama. | Tied to Weaviate as vector store; not suited for multi-user deployments. | Good for quick solo prototyping. Less useful long-term since it locks you into Weaviate. |

### Notes

- **For learning the mechanics** (embeddings, chunking, retrieval ranking): Haystack or LlamaIndex expose the most without hiding things behind abstractions. The hand-rolled pipeline already started in this project is also a valid path -- frameworks are not mandatory.
- **For a fast working demo**: RAGFlow gives you the most out of the box. Docker, UI, document parsing, Ollama integration.
- **For retrieval experiments**: RAGatouille is worth a look specifically because ColBERT's late interaction model addresses ranking problems differently than standard cosine similarity -- relevant to the ranking concerns described in the Retrieval Strategy section.
- **Ragbits** stood out for its Pythonic design and modular installation. It also ships a built-in evaluation framework (`ragbits-evaluate`), which could be useful for the regression testing described in the RAG Pipeline Plan section.
