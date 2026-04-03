# context of what I am trying to do
my interest in LLM is mostly around technical / computer stuff, technical writing, and professional development. Example of things I am interested in:
* apply advanced configurations to my router (configure different nets with firewal rules, VPN gateways, site to site VPNs, etc)
* various home lab endeavors (media servers, VPN endpoints, etc).
* home automation. Set up smart stuff in my house. monitor them. Example set up my z-wave thermostat with home assistant, set up rules, help monitor my power bills, etc.
* technical writing. When wrapping up a project I would like the AI to document it, tell me what's missing in my documentation trail. For example I would like to make updating this website a much easier step when working on my projects, especially when I have interesting results.
* wrap up unfinished projects resembling the ones described here.
* Vibe code some stuff. Example: I want a little app to keep track of my HSA receipts where I could just to to myapp.mydomain.com, and the app would have one feature: scan a receipt and parse it / ask me to specify medatadata. THen it would maintain the results in a database, maintain the pictures of receipts when I need to make a claim. That's just as example that's meant to be achieavable but not trivial. We'll see where it takes me.

# learinng 
My objective is to understand how LLMs work. In particular I want to gain better understanding of:
* when they work well
    * see my example applications
* when they tend to fail
    * what I can do about that
* How to get more predictable results
    * in this case I would like to improve both consistency: different output not contradicting each other on similar input, and quality (more relevant and insightful output)
* Reduce instances of LLM's simply ignoring my instructions: "For the 4th time: use UV when running python, DO NOT set a virtual environment yourself".
* how LLMs work at the mathematical level (I used to be a legit statistician after all!)
    * I want to understand embeddings, what they mean. be able to make sense of the variout transformer steps, be able to do 1-2 iteration on paper and understand what I'm achieving. Understand encoders only vs decoder only, model heads, etc.
* Why LLMs sometimes cycle between telling you something and the complete opposite
* How to manage context windows effectively
* Identify when I'm failing at using models vs using the wrong model vs having bad information.
* Identify when my model is good enough, but outdated (does not "know" about breaking changes in a software)
* evaluate the difference between paid-for and "local" models. 
* evaluate the differences between public free models
    * ... and probably paid for models too since they are what I use professionally.
    * evaluate against consistency and quality of the output. does claude suggest a more complete answer when asked to "do task XYZ" and does it doing consistently on the same input.
* how can I maintain my privacy doing all this.
    * from my IPS, my employer, my family, hackers, the government, google, my job.
    * for example imagine I am trying to set up a VPN to conceal from the government that _Facebook_ (or _The Onion_, same thing really) is my main source of information, I don't think my government or my wife should know about this.
    * not to mention. I'd like to be able to supply an API key to the AI when asking it to configure something, with certainly that it's handling this properly. In the case of public models I don't have much hope I will be able to do this, but I should be able to do this on my LAN. 
* prompt engineering. I want to become really good at getting the LLM to do what I want, as cheaply and as quickly as possible.
* learn how to deal with HUGE contexts (very large code bases, very large documents, etc)
    * huge here meaning tasks currently exceeding what models can do. At the time of writing context windown of the models that I am using can stretch to 100K-200K tokens. What if I'm trying to sort a code base with 2M lines of code. What if I'm parsing GBs of logs to find trends (ok AI may not be the first tool for this)

# Motivation
To be 100% honest, my motivation is part **curiosity** (I am a very curious person, I like gardening, math, geology, history, psychology, etc), part **continued employment**. I don't shine at worker faster or using the coolest tools. I am, however, very capable of thinking critically, **asking why** even when it bothers everyone else. AI will likely disrupt the technology landscape, but it really opening a bunch of opportunities for us all. We have to figure out what they are.
* In general, software / tech engineers don't work the same way that they did 5 years ago. Five years ago I was working on reprojecting maps in tile servers. At the time of writing I am developing data pipelines for robotic applications. Who knows what the future holds for me, but I want to be ready to be a survivor of the AI disruption. 

# hardware
I am blessed to have two Nvidia GPU on hand (RTX 3090, A30), each with 24GB of RAM, and enough spillover DDR5 RAM (96GB). Due to limitations of consumer-grade GPU, I cannot pool their memory, but I can run a sizable collection of models with this amount of memory. 

My plan is to accept the speed penalty when swapping memory to run much larger, allegedly better models, so I can see what they are really capable of. For example, to test how to get **reproducible and valid** answers on really complex queries. I don't mind waiting 5/10 minutes on a very big model as a test. 

example complex queries:
* multistep queries requiring information retrieval: "figure out how to set up a separate net on my router, with a VPN gateway -- you need to figure out how to set up the wireguard interface --. Make sure the net will never spill traffic on the other gateways. make sure I can test that the net work. Also you need to be able to work with a DNS entry for the remote endpoint, and not a static IP -- if the router does not support it find a way around it"
* look at this massive email chain that I got and help me figure out the mood of the client, and what should be the next step. Retrieve information from my code base / git / some system. if it can be relevant to understand what's doing on

I am also blessed to have access to an Nvidia RTX 5070 GPU with 12GB of VRAM that I use for my work at Forterra. I don't do too much after hours development, but sometimes it is the only computer I have access to. and I can test an idea during my lunch. Yes: I obtained the blessing of our cybersecurity team to do this!

What I really want to do is play with the software and the hardware. In particular I want to run these models locally as much as possible. I don't object using commercial models either.


# evaluation
I want to get a better mental picture how to evaluate output, and also how to manage the vast output that LLMs give while maintaining my sanity. I am not trying to understand everything (honestly if the AI writes a wicker parser for a crappy file format that I need to parse, an long as I understand the spec I'm not trying to micromanage everything). However I want to remain on top of it so I can keep iterating **and be confident** that the output is good. In my experience this is not easy at any rate, and not with AI.

* this is kinda open ended by definition. I don't know yet what to do with this. example AI is outputing tons of text. Am I supposed to save it? save when I input to get it. How do I keep trace of it. What's worthy of saving it and what's not?

# NOT trying to do
I am not trying (yet) to do a whole lot of agent integration. I'm fine talking to a python script for now. Also I am not trying, yet, to start a company or create anything novel. I am also not that interested in scaling just yet -- I may be later but my objective is mastery of the tool, not productizing my learing. 

I want, however, to be able to use reliably what I create in my home lab, for my own uses. Maybe my wife can tap the resources that I create for her own projects as well.

# AI SUGGESTIONS
* RAG (retrieval-augmented generation) -- you're already building this with vyosindex/ChromaDB but it's not listed as an explicit learning objective. Chunking strategies, embedding models, vector similarity, and retrieval quality are worth studying deliberately.
* fine-tuning vs RAG vs in-context learning -- when to use each, and the tradeoffs. Directly relevant to your "outdated model" bullet.
* quantization and model formats -- you plan to run big models on consumer hardware. Understanding quantization levels and their impact on quality vs speed vs memory will save you a lot of trial and error.
* reproducibility -- you mention wanting reproducible answers. Worth digging into seeds, temperature settings, and the fundamental non-determinism of GPU floating point. Even temperature=0 doesn't guarantee identical outputs across runs.
* hallucination detection and grounding -- goes beyond "when they fail." Specific strategies for verifying outputs, forcing citations, and grounding responses in source material.
* cost analysis -- token pricing for API models, electricity/time cost for local inference, and when local vs cloud actually makes economic sense for a given task.
* security and prompt injection -- ties into your privacy bullet. Understanding what "private" really means when running locally vs sending data to an API, and how prompt injection attacks work.
* the math curriculum -- you say you want to understand the math. Worth listing the subtopics: attention mechanism, transformer architecture, tokenization, loss functions, backpropagation, softmax, positional encoding. That's a curriculum in itself and you should scope it.
* evaluation frameworks -- you mention wanting to evaluate output quality. There are both formal benchmarks and task-specific eval approaches worth knowing about, even if you don't use them directly.
* multi-modal models -- vision, audio, code. You have the hardware. Worth deciding whether this is in scope or explicitly out of scope for now.
* model selection heuristics -- how to quickly decide which model to reach for given a task, without trial and error every time. Ties into your "wrong model" bullet.