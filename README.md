# [eindiran.github.io](https://www.unadulterated-faff.com)
A blog, built with [Jekyll](https://jekyllrb.com) and hosted on [GitHub Pages](https://pages.github.com/). Originally the page was hosted at `eindiran.github.io` but now lives at [unadulterated-faff.com](https://www.unadulterated-faff.com).


## Running the site locally

To test and run the site locally, you're going to need to set up Jekyll. First, hop on over to [here](https://jekyllrb.com/docs/installation/) and choose the installation guide for your platform.

For Debian-based platforms that use `apt-get` as the package manager, the steps are as follows:

1. Install Ruby via `apt-get`: `sudo apt-get install ruby-full build-essential zlib1g-dev`
2. Ensure that Gems are installed to your home directory, by adding a `GEM_HOME` line to your `.bashrc` or `.zshrc`: `echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc`
3. Add `$HOME/gems/bin` to your `PATH`.
4. Finally, use `gem` to install `jekyll`: `gem install jekyll bundler`.

Then, install the necessary packages via `bundle install`, while in the top-level directory. This may take a little while.

Once the Gems are installed, you can run the site via `bundle exec jekyll serve`. Don't run `jekyll` directly or you may run into Gem conflicts if you have multiple versions of the same Gem installed.

`bundle exec jekyll serve` runs using the `4000` port by default, but this can be manually specified using the `--port`. For example: `bundle exec jekyll serve --port 4001
