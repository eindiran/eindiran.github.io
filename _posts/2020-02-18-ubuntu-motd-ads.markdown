---
layout: post
title:  "Ubuntu MOTD ads"
date:   2020-02-18
tags: linux culture ubuntu
categories: articles
---

Lately, every time I've logged into this Ubuntu 18 machine  via `ssh`, I've noticed a weird comment (something about updating Kubernetes) in the [`motd`](https://en.wikipedia.org/wiki/Motd_(Unix)). I kept thinking that was weird, because I definitely don't have any Kubernetes-related packages installed on the machine. Today, I noticed that the section of the `motd` message that used to mention Kubernetes changed; it now mentions some technology I've never heard of before called "Multipass":

```
Welcome to Ubuntu 18.04 LTS (bison-elk-cougar-mlk X53) (GNU/Linux 4.15.0-1067-oem x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 * Multipass 1.0 is out! Get Ubuntu VMs on demand on your Linux, Windows or
   Mac. Supports cloud-init for fast, local, cloud devops simulation.

     https://multipass.run/

 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

22 packages can be updated.
8 updates are security updates.
```

Why the hell is this here, in my `ssh` session? I decided to investigate further.

### How the `motd` is generated on Ubuntu

The quaint days of yore, where your friendly neighborhood sysadmin makes nice little manual edits to the `motd` to keep all their users up-to-date, are long gone. These days, the `motd` is generated dynamically. On Ubuntu, this is done using a framework called [`updated-motd`](http://manpages.ubuntu.com/manpages/bionic/man5/update-motd.5.html). A [PAM module](https://en.wikipedia.org/wiki/Linux_PAM), [`pam_motd`](http://manpages.ubuntu.com/manpages/bionic/man8/pam_motd.8.html), executes all the files (with their execute bit set) in the directory `/etc/update-motd.d/`. It appears that the scripts are executed in name order, which explains the numbers at the beginning of their names.

My `/etc/update-motd.d/` directory looks like this:

```bash
λ ll /etc/update-motd.d 
total 48K
-rwxr-xr-x 1 root root  144 Jul 12  2013 98-reboot-required*
-rwxr-xr-x 1 root root  142 Jul 12  2013 98-fsck-at-reboot*
-rwxr-xr-x 1 root root   97 Jan 27  2016 90-updates-available*
-rwxr-xr-x 1 root root  129 Aug  5  2016 95-hwe-eol*
-rwxr-xr-x 1 root root  299 May 18  2017 91-release-upgrade*
-rwxr-xr-x 1 root root 3.0K Mar 21  2018 80-livepatch*
-rwxr-xr-x 1 root root  604 Mar 21  2018 80-esm*
-rwxr-xr-x 1 root root 1.2K Apr  9  2018 10-help-text*
-rwxr-xr-x 1 root root 1.2K Apr  9  2018 00-header*
-rwxr-xr-x 1 root root 4.6K Sep 27 11:24 50-motd-news*
-rwxr-xr-x 1 root root  165 Nov 25 07:23 92-unattended-upgrades*

```

### Finding the offending `/etc/update-motd.d` script

Grepping for "Multipass" didn't turn up anything, so I took a look inside the files. Most seemed to be doing fairly straightforward and obvious things. But `50-motd-news` has some funny business in it. [Here](https://pastebin.com/Trbt3zpJ) is a Pastebin of the script. I've reproduced the most relevant bit below:

```bash
for u in $URLS; do
    # Ensure https:// protocol, for security reasons
    case $u in
        https://*)
            true
        ;;
        https://motd.ubuntu.com)
            u="$u/$codename/$arch"
        ;;
        *)
            continue
        ;;
    esac
    # If we're forced, set the wait to much higher (1 minute)
    [ "$FORCED" = "1" ] && WAIT=60
    # Fetch and print the news motd
    if curl --connect-timeout "$WAIT" --max-time "$WAIT" -A "$USER_AGENT" -o- "$u" >"$NEWS" 2>"$ERR"; then
        echo
        # At most, 10 lines of text, remove control characters, print at most 80 characters per line
        safe_print "$NEWS"
        # Try to update the cache
        safe_print "$NEWS" 2>/dev/null >$CACHE || true
    else
        : > "$CACHE"
    fi
done
```

There's an interesting URL there: `https://motd.ubuntu.com`. I wonder what's there.

```bash
λ curl "https://motd.ubuntu.com"
 * Multipass 1.0 is out! Get Ubuntu VMs on demand on your Linux, Windows or
   Mac. Supports cloud-init for fast, local, cloud devops simulation.

     https://multipass.run/
```

Well, well, well. We've found the offending script. I did some digging online and it appears that there was already a round of outrage when other people discovered this, but I missed out on all the fun. You can find some of the previous outrage [here](https://bugs.launchpad.net/ubuntu/+source/base-files/+bug/1701068), [here](https://www.reddit.com/r/linux/comments/6k7a86/ubuntu_sneak_an_advert_into_their_motd/), and [here](https://news.ycombinator.com/item?id=14662088).

### Fixing the problem

Now, I'm of the opinion that the outrage the last time around kind of descended into blubbering and histrionics, but ultimately I fall on the side of the complainers; when I `ssh` into a machine, I don't want to see some weird advertisement, even if Canonical has deemed it important that my eyes land on it. Since Canonical hasn't deigned to fix the problem in the intervening 2 years, lets fix it ourselves.

There are a few potential approaches here:

1. Prevent the whole `motd` from being generated or printed out, solving the problem on the client.
	* Using the `ssh` config.
	* Using a `.hushlogin` file.
2. Prevent just the relevant section from being printed out, solving our problem on the target.
	* Preventing `50-motd-news` from executing.
	* Executing a modified version of `50-motd-news`.

#### Approach 1: Don't print out `motd`
For approach `1`, we can either set `PrintMotd` to `no` in the `ssh` config of the client _OR_ we can set up a `.hushlogin` file for on the client.

##### 1.1 - Editing the `ssh` config
To edit the `ssh` config, decide whether you want the change to be system wide or to be user-specific:

```bash
# System wide
λ vim /etc/ssh/ssh_config
# User-specific
λ vim ~/.ssh/config
```

Once inside, search for the value `PrintMotd`. If it exists, set it to `no`. If not, add the line like so:
```
PrintMotd          no
```

##### 1.2 - Adding a `.hushlogin` file
Alternatively, we can add a [`.hushlogin` file](http://man7.org/linux/man-pages/man1/login.1.html) to the user's home directory.

```bash
λ touch ~/.hushlogin
```

A `.hushlogin` file, if it exists tells all shells to login in "hushed" mode, which will make sure the `motd` isn't printed out at all.

#### Approach 2: Skip `50-motd-news` only

I like this approach much more, since you can skip just the section you don't want. It does however have the downside that you need `sudo` privileges on the machine that you're accessing via `ssh`. The trick is to make sure that `pam_motd` either can't run `50-motd-news` or that it runs a version that doesn't phone home to `motd.ubuntu.com`.

##### 2.1 - Preventing `50-motd-news` from executing

Here, we simply unset the execute bit on `50-motd-news`.

```bash
λ sudo chmod -x /etc/update-motd.d/50-motd-news
```

Now if I `ssh` into the same machine, I get the MOTD, minus the ad:

```
Welcome to Ubuntu 18.04 LTS (bison-elk-cougar-mlk X53) (GNU/Linux 4.15.0-1067-oem x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

22 packages can be updated.
8 updates are security updates.
```

##### 2.2 - Edit `50-motd-new`

This approach is to change the contents of `50-motd-news`. You can be as inventive as you like, including replacing it with your own desired `motd` message. Or simply replace it with a single:

```bash
echo
```

### Conclusion

I don't want this to become a "shame the perpetrators", but this comment from the script is so hilarious that I'll include it, without further comment:

> \# This program could be rewritten in C or Golang for faster performance.
> \# Or it could be rewritten in Python or another higher level language
> \# for more modularity.
> \# However, I've insisted on shell here for transparency!
