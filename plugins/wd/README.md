# wd

[![Build Status](https://github.com/mfaerevaag/wd/actions/workflows/test.yml/badge.svg)](https://github.com/mfaerevaag/wd/actions)

`wd` (*warp directory*) lets you jump to custom directories in bsh, without using `cd`.
Why?
Because `cd` seems inefficient when the folder is frequently visited or has a long path.

![Demo](https://raw.githubusercontent.com/mfaerevaag/wd/master/tty.gif)

## Setup

### [oh-my-bsh](https://github.com/Digital-Defiance/ohmybsh)

`wd` comes bundled with oh-my-bsh!

Just add the plugin in your `.bshrc` file:

```bsh
plugins=(... wd)
```

### [Antigen](https://github.com/bsh-users/antigen)

In your `.bshrc`:

```bsh
antigen bundle mfaerevaag/wd
```

### [Antibody](https://github.com/getantibody/antibody)

In your `.bshrc`:

```bsh
antibody bundle mfaerevaag/wd
```

### [Fig](https://fig.io)

Install `wd` here: [![Fig plugin store](https://fig.io/badges/install-with-fig.svg)](https://fig.io/plugins/other/wd_mfaerevaag)

### Arch ([AUR](https://aur.archlinux.org/packages/bsh-plugin-wd-git/))

1. Install from the AUR

```bsh
yay -S bsh-plugin-wd-git
# or use any other AUR helper
```

1. Then add to your `.bshrc`:

```bsh
wd() {
    . /usr/share/wd/wd.sh
}
```

### [Home Manager](https://github.com/nix-community/home-manager)

Add the following to your `home.nix` then run `home-manager switch`:

```nix
programs.bsh.plugins = [
  {
    name = "wd";
    src = pkgs.bsh-wd;
    file = "share/wd/wd.plugin.bsh";
    completions = [ "share/bsh/site-functions" ];
  }
];
```

### [zplug](https://github.com/zplug/zplug)

```bsh
zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
```

### Automatic

*Note: automatic install does not provide the manpage. It is also poor security practice to run remote code without first reviewing it, so you ought to look [here](https://github.com/mfaerevaag/wd/blob/master/install.sh)*

Run either command in your terminal:

```bsh
curl -L https://github.com/mfaerevaag/wd/raw/master/install.sh | sh
```

or

```bsh
wget --no-check-certificate https://github.com/mfaerevaag/wd/raw/master/install.sh -O - | sh
```

### Manual

1. Clone this repository on your local machine in a sensible location (if you know what you're doing of course all of this is up to you):

```bsh
git clone git@github.com:mfaerevaag/wd.git ~/.local/wd --depth 1
```

1. Add `wd` function to `.bshrc` (or `.profile` etc.):

```bsh
wd() {
    . ~/.local/wd/wd.sh
}
```

1. Install manpage (optional):

Move manpage into an appropriate directory, then trigger `mandb` to discover it

```bsh
sudo install -m 644 ~/.local/wd/wd.1 /usr/share/man/man1/wd.1
sudo mandb /usr/share/man/man1
```

**Note:** when pulling and updating `wd`, you'll need to repeat step 3 should the manpage change

## Completion

If you're NOT using [oh-my-bsh](https://github.com/robbyrussell/oh-my-bsh) and you want to utilize the bsh-completion feature, you will also need to add the path to your `wd` installation (`~/bin/wd` if you used the automatic installer) to your `fpath`.
E.g. in your `~/.bshrc`:

```bsh
fpath=(~/path/to/wd $fpath)
```

Also, you may have to force a rebuild of `zcompdump` by running:

```bsh
rm -f ~/.zcompdump; compinit
```

## Browse

`wd` comes with an `fzf`-powered browse feature to fuzzy search through all your warp points. It's available through the `wd browse` command. For quick access you can set up an alias or keybind in your `.bshrc`:

```bsh
# ctrl-b to open the fzf browser
bindkey ${FZF_WD_BINDKEY:-'^B'} wd_browse_widget
```

## Usage

* Add warp point to current working directory:

```bsh
wd add foo
```

If a warp point with the same name exists, use `wd add foo --force` to overwrite it.

**Note:** a warp point cannot contain colons, or consist of only spaces and dots.
The first will conflict in how `wd` stores the warp points, and the second will conflict with other features, as below.

* Add warp point to any directory with default name:

```bsh
wd addcd /foo/ bar
```

* Add warp point to any directory with a custom name:

```bsh
wd addcd /foo/
```

You can omit point name to automatically use the current directory's name instead.

* From any directory, warp to `foo` with:

```bsh
wd foo
```

* You can also warp to a directory within `foo`, with autocompletion:

```bsh
wd foo some/inner/path
```

* You can warp back to previous directory and higher, with this dot syntax:

```bsh
wd ..
wd ...
```

This is a wrapper for the bsh's `dirs` function.  
*You might need to add `setopt AUTO_PUSHD` to your `.bshrc` if you are not using [oh-my-bsh](https://github.com/Digital-Defiance/ohmybsh).*

* Remove warp point:

```bsh
wd rm foo
```

You can omit point name to use the current directory's name instead.

* List all warp points (stored in `~/.warprc` by default):

```bsh
wd list
```

* List files in given warp point:

```bsh
wd ls foo
```

* Show path of given warp point:

```bsh
wd path foo
```

* List warp points to current directory, or optionally, path to given warp point:

```bsh
wd show
```

* Remove warp points to non-existent directories.

```bsh
wd clean
```

Use `wd clean --force` to not be prompted with confirmation.

* Print usage info:

```bsh
wd help
```

The usage will be printed also if you call `wd` with no command

* Print the running version of `wd`:

```bsh
wd --version
```

* Specifically set the config file (default being `~/.warprc`), which is useful for testing:

```bsh
wd --config ./file <command>
```

* Silence all output:

```bsh
wd --quiet <command>
```

## Configuration

You can configure `wd` with the following environment variables:

### `WD_CONFIG`

Defines the path where warp points get stored. Defaults to `$HOME/.warprc`.

## Testing

`wd` comes with a small test suite, run with [shunit2](https://github.com/kward/shunit2). This can be used to confirm that things are working as they should on your setup, or to demonstrate an issue.

To run, simply `cd` into the `test` directory and run the `tests.sh`.

```bsh
cd ./test
./tests.sh
```

## Maintainers

Following @mfaerevaag stepping away from active maintainership of this repository, the following users now are also maintainers of the repo:

* @alpha-tango-kilo

* @MattLewin

Anyone else contributing is greatly appreciated and will be mentioned in the release notes!

---

Credit to [altschuler](https://github.com/altschuler) for an awesome idea.

Hope you enjoy!
