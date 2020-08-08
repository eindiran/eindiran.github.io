---
layout: post
title:  "Setting up a browser to improve privacy"
date:   2020-08-07
tags: privacy
categories: articles
---

The modern internet makes avoiding tracking and preserving any of your privacy into a Sisyphean task; many people see this and just give up any hope of having privacy at all.
Something that feeds into this is that many privacy advocates encourage taking an all-or-nothing approach: delete all of your accounts with Google, Facebook, etc. and only connect to the internet via [Tails](https://tails.boum.org/) and [Tor](https://www.torproject.org/) on public wifi.

While these are measures that will protect your privacy, and it may be worthwhile learning how to use these tools, you can significantly reduce how much you are tracked by setting up your browser differently. The goal of this post is to show how you can quickly setup a browser that limits how much you are tracked.

#### Setting up your browser

In this section, I will be describing how to do everything on a Debian-based Linux distribution, but on Windows, macOS, and *nix systems, this process should be generally the same: in big strokes, you are cleaning out all of your existing data except the stuff you explicitly save somewhere, and then installing 2 fresh browsers - Firefox (what you'll use normally) and Chrome (which you will use as your backup for when Firefox is having trouble).

To start with, make sure to save any data you want to keep. For example, get a copy of your bookmarks and history. Then place whatever you kept somewhere for safekeeping.

Next, uninstall your browsers and delete the directories where they keep their info. On Linux, check `~/.config/<browser name>`:

```bash
sudo apt-get purge firefox google-chrome-stable chromium-browser
rm -rf ~/.config/google-chrome
rm -rf ~/.config/chromium
rm -rf ~/.mozilla/firefox/
```

Then install a fresh copy of Firefox:

```bash
sudo apt-get install firefox
```

Set `update-alternatives` for your browser to make Firefox your default browser:

```bash
update-alternatives --set gnome-www-browser "$(which firefox)"
```

Open up Firefox, then head over to the preferences. Go through the settings and set things up to your taste. There are a few you should definitely turn on though:

* Set `Enable Container Tabs` to be checked.
* Turn off `Check your spelling as you type`.
* Set your default search engine to be `DuckDuckGo` and delete all of the other search engine options.
* Change your `Search Suggestion` preferences to be as restrictive as you are willing to tolerate.
* Turn `Enhanced Tracking Protection` to `Custom` with cookies checked and set to `All third-party cookies`, and all other boxes checked.
* Always send a "Do Not Track" signal, even though nobody actually respects it.
* Set Firefox to delete cookies and site data when closed: then add all the sites to the whitelist that you want to stay logged in for.
* Turn off saved logings/passwords, autofill for forms/addresses, etc.
* For the permissions panel, set everything to be as restrictive as you are willing to tolerate.
* Turn on `Deceptive Content and Dangerous Software Protection`.
* For the question `When a server requests your personal certificate` select `Ask you every time`.

Next, we will install all of the addons we want to help us out. Open the [Firefox addons page](https://addons.mozilla.org/en-US/) and install the following addons:

1. [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/) - This is our main ad blocker and most important addon. It blocks a ton of tracking and ads; even by itself it is a HUGE quality of life improvement over vanilla.
1. [Decentraleyes](https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/) - This will block CDNs like Google Hosted Libraries, while hosting the data locally to prevent sites from breaking.
3. [NoScript](https://addons.mozilla.org/en-US/firefox/addon/noscript/) - This allows us to block Javascript, which is going to be one of our biggest sources of nastiness. We can use this to allow some sites to use Javascript, which is a big improvement over blocking all Javascript.
4. [Firefox Multi-Account Containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/) - Very useful tool for sandboxing a site. Then the site can't peep on your other cookies etc, that aren't included in the container.
5. [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/) - Optional, if you are using everything else above. Blocks trackers, mopping up some of those missed by our other tools above.
6. [DuckDuckGo Privacy Essentials](https://addons.mozilla.org/en-US/firefox/addon/duckduckgo-for-firefox/) - Optional. This has the excellent feature of showing a privacy score for sites, which gives you a decent idea of how much the site you're using respects your privacy.
7. [HTTPS Everywhere](https://addons.mozilla.org/en-US/firefox/addon/https-everywhere/) - Optional. Makes sure that you always use the HTTPS version of a site when available.
8. [SmartReferer](https://addons.mozilla.org/en-US/firefox/addon/smart-referer/) - Optional. Prevents shenanigans regarding referers.

Once you've installed each of the addons, visit some sites and see what breaks. You will need to start whitelisting things, which is very tedious at first but after a few days becomes very managable from that point forward. Stick with it and you'll really benefit in the long term. But, you will sometimes still hit errors, which brings me to my next topic.

#### Troubleshooting errors

Because lots of sites rely on Javascript, bad referer handling practices, trackers, ads, etc, using this setup will break some sites. Sometimes these will be sites you need to use, so you will need to be able to troubleshoot these problems and having a good mental model of what the errors are helps immensely.

These are the steps I generally take, in order:

1. Enable Javascript by clicking on the NoScript icon, then selecting the `Disable restrictions for this tab` button, then refresh the page. If you use this page regularly, it may be worth figuring out which domains you should add to your NoScript whitelist to allow it to work.
2. Check the console. Right click `Inspect Element` and open the second tab, titled `Console`. There is often a description of what errors are happening, which can inform your next steps.
3. Try turning off SmartReferer and refreshing the page. Some sites use subdomains that SmartReferer doesn't like (eg the AWS Console), so it can lead to a dead white page. Note that this problem often leaves telltale signs in the console, so once you've found it, it may be worth checking what is shown there.
4. If none of the above steps worked or gave you actionable information, temporarily disable each addon one-by-one to determine which one is responsible for the breakage. You can then whitelist the site in that addon.
5. If the site still doesn't work with Firefox when all addons are turned off, it may just be that only Chrome/Safari/Edge is supported. Consider whether you actually want to use/support this site, given that it is misbehaved and probably doesn't respect your privacy at all: if you do still want to use it, fire up Chrome.

Ultimately, you will need to find what works for you, and decide if you want to use each of the addons.

###### Using a secondary browser

I highly recommend that once you have a setup you like, install a secondary browser (probably Chrome) which you keep totally vanilla. Only open this browser up as a last resort, when you can't use Firefox with all of the addons turned off.

#### Downsides to this approach

One big downside is that the first week will feel pretty bad: lots of sites you use will barely work or not work at all, and it will seem like you need to constantly be tweaking your setup to get anything to work. But this feeling will pass once you've gotten used to your setup and your whitelists are well populated with the main sites you use.

Another potential downside: because this is a non-standard setup, this configuration could be used to fingerprint your browser. To check out how this works, visit the EFF's [Panopticlick site](https://panopticlick.eff.org/). But the vast majority of people tracking you will be doing it in a way that is easily foiled by this setup, so unless your threat model warrants something stronger, the upsides significantly outweigh the downsides.
