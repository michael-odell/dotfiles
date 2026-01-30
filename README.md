# My dotfiles

Shell and terminal configurations, just the way I like them.

## Using the dotfiles

I keep this repo cloned right in the root of my home directory.  Well, I keep the working files
there.  As it happens, it's a lot of trouble to make all of the tools think your home directory is a
git repo, because they act like everything should be inside it.  Usually a reasonable assumption,
but doesn't work well in the case of your home directory.

So what I do is use an alias for git when I want to operate on my home directory.  An alias that
looks something like this:

    alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"

And then I can do `dotfiles clone` or `dotfiles add` or `dotfiles push origin main` just as I
normally would.  It means that I have to be a bit religious about setting a .gitignore file so that
I can read my `dotfiles status`, but it helps me keep things tidy.  Overall, I think the scheme is
great.  I've tried others, but have returned to this one multiple times.
