Rags part 1: getting started

# Context
I have a [vyos](https://vyos.io/) router box at my house. While I am 100% happy with the product, I tend to waste time with the configuration and remembering the commands to do non trivial things. It's a CLI-only product. I previously used OpnSense and the UI only configuration drove me absolutely crazy. I gave up using it after trying to set up a site-to-site VPN and wasting a combined three days on it, with the VPN still failing.

VyOS changed (I think... or at least the AI thinks) their CLI API some time ago, so I always have to tweak the output of the AI (Claude, ChatGPT). I'm not sure how much the CLI really changed, if the AI are outdated, or simply making stuff up. At any rate I experienced many instances of getting invalid commands using the commercial AI in the past. At the time of writing I could not find an official statement on breaking changes in VyOS -- I did not look that hard. Part of this project would be to explore and document these changes if they are not well documented. For insance I believe an AI should be capable of ingesting two large documentation documents (VyOS 1.2 released in January 2019 vs VyOS 1.3 released in December 2021 for instance. source: https://docs.vyos.io/en/1.4/introducing/history.html) and produce a list of breaking changes. This would have the added benefit of characterizing AI failures into hallucinations (AI produces something that was never current) vs outdated training (AI produces something that was in the old documentation). This may look like a side goal, but I believe it's a good example project for a RAG project -- in the sense that one can use the different concepts, combine them and learn.

That's the kind of operations I do and I want to test what the AI can do about it:
* set static IP on specific network to a mac address (optionally generate the mac given the desired IP)
    * given the IP it should figure out what net it belongs to, generate the MAC, apply config
* VPN interface (wireguard, open VPN)
* create networks
    * apply routing / firewall rules to it. Example I want to set a network, assign a vlan tag to it, and have specific firewall rules blocking all traffic to other local networks, and use this for my work computer.
    * nets with different DNS configs
    * nets with VPN gateways
* deal with port forwarding: 22, 80, 443, etc all go to specific VMs in the LAN. bonus points for reading my specs somewhere else and figuring out that automatically
* "advanced" DNS. Example use case is "coolservice.mydomain.com" points to my public IP, but "coolservice" is a host in my LAN. However I want "coolservice.mydomain.com" to point to a reverse proxy when in my LAN on port 443. This is hacking but ... AI needs to either deal with it or suggest better solutions.
* etc 

Other objectives:

These are harder, multi-staged project where AI would be of great assistance. With the benefit of a RAG system that provides current, accurate documentation and configuration guide I would like to ...
* inspect the entire `VyOS` config on my router (it's not that long, maybe 10-20 pages of commands) and evaluate it: come up firewall tests for at least external security problems, identify unused features (example interfaces not used anywhere)
* CI/CD on new configs, run virtualized cluster with router, hosts, etc and run security audit on the virtualized network.

# learning idea
VyOS publishes their [documentation](https://github.com/vyos/vyos-documentation) on git in RST files. From a quick glance it is mostly well structured. 


I want to develop a RAG pipeline using local and commercial models to (1) identify prompts the AIs fail to answer and (2) see if providing VyOS documents along with the prompt can improve the prompt response, whether the baseline response was correct or not. On initially (without RAG) correct responses, I don't want to turn a valid response into an invalid one just because I provide additional information that is wrong or irrelevant. It is important to check for regressions because if the AI is capable of answering a prompt, and it fails to answer it when supplied with additional erroneous/incorrectly processed/irrelevant/etc information, that would invalidate your methodology (at least partially). I suggest the following prompts (may have to tweak / reword):
* (easy) generate a random MAC address for host jm-rag and assign it to 192.168.10.125 on the LAN
* (easy) forward port 22 to host `sshbastion.domain.com` (where sshbastion is a host on my LAN)
* (medium) create a new network JM-WORK with CIDR 192.168.11.0/24. follow up with:
    * block all traffic between it and other nets. Nobody outside of JM-WORK can reach any host in it
    * assign VLAN tag 11 to network JM-WORK
* (medium) given the following wireguard config create a wg10 tunnel. Provide a command to test that the interface is up
    * (hard) create a new network REMOTE-NET with CIDR 192.168.12.0/24 using wg10 as the gateway. configure all routes and firewall rules to allow traffic to and from the remote network. Assume that the remote network is a simple LAN with a know CIDR 192.168.2.0/24.
* (hard) use the supplied config and apply (SOME CHANGES, say from the examples above) in a staging environment (some sort of virtualization, VMs, docker-compose, k3s, etc). Write appropriate tests to validate the new functionality. execute the tests in the staging environment. (note to AI, without the RAG, presumably you would not even have correct data to even do any of this, but it's true that it's an integration problem, maybe we can mark it as such)


I will try to:
* chunks the entire documentation into block documents
* put it into a vector database, or any database that supports retrieval of relevant blocks given a prompt
    * dealing with defining "relevant" is expected to be hard, but somewhat loose requirement, at least to start. At the beginning I can separate the tasks of retrieving documents (make rules, heuristics, etc) from the task of using the retrieved information in the AI model. I can even have a human or the AI in the look to do a triage of the supplied document.
* define a mental framework for querying the database in such a way that I can assess the results, before eventually automating
    * example: maybe I can't do a vector search on "define a VPN interface using wireguard with a DNS endpoint for the remote peer, and use it as a gateway for a new net NEWNET with blablabla properties" because it will latch on all sorts of things, but I can specify search items such as "wireguard interface", "DNS address for wireguard", "set up new network", "configure gateway of network", etc. The use would have to be intentional when prompting -- which I don't think is a bad thing anyways. This is just an idea, the objective of this research is to learn more.
    * caveat here: When querying the vector DB, I highly doubt that the results will come well ordered. The chunking for instance may have a chuck that just happens to be a header whose text is exactly "set up new network". That document would (presumably) always rank as the best match for the eponymous query "net up new network", but lower ranked documents would be more relevant. I'm hoping to find mitigating solutions for this. Maybe the AI can keep probing the document DB untill it ascentained that the matches are getting too far from the original question. For instance when searching for "configuring wireguard" in the vector DB, maybe we can iteratively evaluate retrieved documents unlis the first one that the AI evaluates to be "not relevant" -- we'd tell the AI this exact term to make it's decision. Again, just ideas, this is what the learning is for.
    * what models do I need to use for embeddings, does it matter that much? performance tradeoffs, memory usage
    * for lack of a better idea I plan on sending my top 10-20 retrieved documents to a powerful AI (At the time of writing that would be Claude Opus 4.6) and ask if the ranking is valid -- how to ask TBD.
* develop a simple pipeline to issue a prompt and get the answer back. a python program that
    * receive a prompt, perhaps with some expected structure in it
    * in a loop, or in a simple sequence, retrieve documents from the vector DB
    * constructs a prompt to feed to the final AI
        * deal with back and forth with the user. Maybe the AI can provide feedback to clarify the prompt.
    * returns to the user the response to the query