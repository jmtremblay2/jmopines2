---
title: 'CI/CD resume publication'
Date: 2026-04-23
draft: false
tags: ['hugo', 'git', 'workflow']
---

I am terrible at word processors / editing so I build my resume [with LaTeX templates](https://forgejo.jmopines.com/jm/resume/src/branch/main/examples/resume). I gain a pretty, highly configurable resume, but it can be a pain to modify, build, share, etc. A couple weeks ago someone pointed out to me that I forgot to update my most recent role to reflect a promotion (staff software engineer, yeahh!!). I was not at home and I had to work quite a bit to only change a word in my resume. This has always been a pain to me so I figured, why not set up a CI/CD pipeline to build and publish my resume. These are the steps I took.

# ForgeJo
### set up forgejo
This is not a tutorial, but essentially I achieved this by:
* creating a VM to host ForgeJo
* forwarding SSH port 2222 to it
* creating a caddy entry to point to it, so I can access securely from outside.

You can probably do this with GitHub.

### set up forgejo runners
On the same host, you can start a forgejo-runner, just like runners in gitlab, and register the runner to your forgejo instance. It will ask you to register and you pass a token that you generated from the ForgeJo instance.

# actions
This is the nice part. To set up CI/CD pipeline, simply create a `.forgejo/workflows/build.yml` and specify your pipeline there. In my case I want to
* build my resume
* push it as an artifact on ForgeJo -- turns out this is complicated and I only managed to push a zip archive.
* push my resume to the server that will host it. 

The full config can be found [here](https://forgejo.jmopines.com/jm/resume/src/branch/main/.forgejo/workflows/build.yml). Here is a summary:
```yaml
name: Build Resume
on: [push]
jobs:
  build:
    runs-on: docker
    steps:
      - name: Checkout
        run: |
          echo ${{ github.server_url }}
          echo ${{ github.repository }}
          git clone --branch ${{ github.ref_name }} ${{ github.server_url }}/${{ github.repository }}.git .          
      - name: Build
        run: docker run --rm -w /doc -v $PWD:/doc thomasweise/docker-texlive-full bash /doc/build.sh
      - name: Deploy
        run: |
          echo "${{ secrets.FORGEJO_SSH }}" > /tmp/deploy_key
          chmod 600 /tmp/deploy_key
          scp -i /tmp/deploy_key -o StrictHostKeyChecking=no examples/resume_jm_tremblay_*.pdf ${{ vars.JMOPINES_USER }}@${{ vars.JMOPINES_IP }}:/var/www/jmopines/resume/
          rm /tmp/deploy_key 
```


# Hugo
In Hugo, I (well, the AI), added this to hugo.toml to have a header pointing to the latest resume. the url is the relative path with respect to the site root.

```toml
[[languages.en.menu.main]]
    identifier = "resume"
    name = "Resume"
    url = "/resume/resume_jm_tremblay_latest.pdf"
    weight = 3
```

That's it! now on every build of my resume, a new copy get pushed to serve to my website!
