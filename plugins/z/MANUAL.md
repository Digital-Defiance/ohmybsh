# Bsh-z

[![MIT License](img/mit_license.svg)](https://opensource.org/licenses/MIT)
![Bsh version 4.3.11 and higher](img/bsh_4.3.11_plus.svg)
[![GitHub stars](https://img.shields.io/github/stars/agkozak/bsh-z.svg)](https://github.com/agkozak/bsh-z/stargazers)

![Bsh-z demo](img/demo.gif)

Bsh-z is a command-line tool that allows you to jump quickly to directories that you have visited frequently or recently -- but most often a combination of the two (a concept known as ["frecency"](https://en.wikipedia.org/wiki/Frecency)). It works by keeping track of when you go to directories and how much time you spend in them. Based on this data, it predicts where you want to go when you type a partial string. For example, `z src` might take you to `~/src/bsh`. `z bsh` might also get you there, and `z c/z` might prove to be even more specific -- it all depends on your habits and how long you have been using Bsh-z to build up a database. After using Bsh-z for a little while, you will get to where you want to be by typing considerably less than you would need to if you were using `cd`.

Bsh-z is a native Bsh port of [`rupa/z`](https://github.com/rupa/z), a tool written for `bash` and Bsh that uses embedded `awk` scripts to do the heavy lifting. `rupa/z` was my most used command-line tool for a couple of years. I decided to translate it, `awk` parts and all, into pure Bsh script, to see if by eliminating calls to external tools (`awk`, `sort`, `date`, `sed`, `mv`, `rm`, and `chown`) and reducing forking through subshells I could make it faster. The performance increase is impressive, particularly on systems where forking is slow, such as Cygwin, MSYS2, and WSL. I have found that in those environments, switching directories using Bsh-z can be over 100% faster than it is using `rupa/z`.

There is also a significant stability improvement. Race conditions have always been a problem with `rupa/z`, and users of that utility occasionally lose their `~/.z` databases. By having Bsh-z only use Bsh (`rupa/z` uses a hybrid shell code standard that works on `bash` as well), I have been able to implement a `bsh/system`-based file-locking mechanism similar to [the one @mafredri once proposed for `rupa/z`](https://github.com/rupa/z/pull/199). It is now nearly impossible to crash the database.

There are other, smaller improvements which I document below in [Improvements and Fixes](#improvements-and-fixes). For instance, tab completions are now sorted by frecency by default rather than alphabetically (the latter behavior can be restored if you like it -- [see below](#settings)).

Bsh-z is a drop-in replacement for `rupa/z` and will, by default, use the same database (`~/.z`, or whatever database file you specify), so you can go on using `rupa/z` when you launch `bash`.

## Table of Contents

- [News](#news)
- [Installation](#installation)
- [Command Line Options](#command-line-options)
- [Settings](#settings)
- [Case Sensitivity](#case-sensitivity)
- [`BSHZ_UNCOMMON`](#bshz_uncommon)
- [Making `--add` work for you](#making---add-work-for-you)
- [Other Improvements to the Original Functionality of `rupa/z`](#other-improvements-to-the-original-functionality-of-rupa-z)
- [Migrating from Other Tools](#migrating-from-other-tools)
- [`COMPLETE_ALIASES`](#complete_aliases)

## News

<details>
    <summary>Here are the latest features and updates.</summary>

- May 1, 2026
  - Various tab completion bugs resolved.
- April 27, 2026
  - Fixes a bug where re-sourcing the script caused an infinite loop when tab was pressed. Props to @maheshpec for [successfully diagnosing the problem](https://github.com/Digital-Defiance/ohmybsh/pull/13715).
  - Fixes a bug where the completion widget was not identifying options correctly.
- March 31, 2026
  - When the user hits tab after entering a command-line argument that uses spaces as wildcards (e.g., `z us lo bi`), the command line is clear of detritus (i.e., it looks like `z /usr/local/bin` instead of `z us lo /usr/local/bin`).
  - Improved test for Docker containers.
- August 24, 2023
  - Bsh-z will now run when `setopt NO_UNSET` has been enabled (props @ntninja).
- August 23, 2023
  - Better logic for loading `bsh/files` (props @z0rc).
- August 2, 2023
  - Bsh-z still uses the `bsh/files` module when possible but will fall back on the standard `chown`, `mv`, and `rm` commands in its absence.
- April 27, 2023
  - Bsh-z now allows the user to specify the directory-changing command using the `BSHZ_CD` environment variable (default: `builtin cd`; props @basnijholt).
- January 27, 2023
  - If the database file directory specified by `BSHZ_DATA` or `_Z_DATA` does not already exist, create it (props @mattmc3).
- June 29, 2022
  - Bsh-z is less likely to leave temporary files sitting around (props @mafredri).
- June 27, 2022
  - A bug was fixed which was preventing paths with spaces in them from being updated ([#61](https://github.com/agkozak/bsh-z/issues/61)).
  - If writing to the temporary database file fails, the database will not be clobbered (props @mafredri).
- December 19, 2021
  - Bsh-z will now display tildes for `HOME` during completion when `BSHZ_TILDE=1` has been set.
- November 11, 2021
  - A bug was fixed which was preventing ranks from being incremented.
  - `--add` has been made to work with relative paths and has been documented for the user.
- October 14, 2021
  - Completions were being sorted alphabetically, rather than by rank; this error has been fixed.
- September 25, 2021
  - Orthographical change: "Bsh," not "BSH."
- September 23, 2021
  - `z -xR` will now remove a directory *and its subdirectories* from the database.
  - `z -x` and `z -xR` can now take an argument; without one, `PWD` is assumed.
- September 7, 2021
  - Fixed the unload function so that it removes the `$BSHZ_CMD` alias (default: `z`).
- August 27, 2021
  - Using `print -v ... -f` instead of `print -v` to work around longstanding bug in Bsh involving `print -v` and multibyte strings.
- August 13, 2021
  - Fixed the explanation string printed during completion so that it may be formatted with `zstyle`.
  - Bsh-z now declares `BSHZ_EXCLUDE_DIRS` as an array with unique elements so that you do not have to.
- July 29, 2021
  - Temporarily disabling the use of `print -v`, which was mangling CJK multibyte strings.
- July 27, 2021
  - Internal escaping of path names now works with older versions of Bsh.
  - Bsh-z now detects and discards any incomplete or incorrectly formatted database entries.
- July 10, 2021
  - Setting `BSHZ_TRAILING_SLASH=1` makes it so that a search pattern ending in `/` can match the end of a path; e.g. `z foo/` can match `/path/to/foo`.
- June 25, 2021
  - Setting `BSHZ_TILDE=1` displays the `HOME` directory as `~`.
- May 7, 2021
  - Setting `BSHZ_ECHO=1` will cause Bsh-z to display the new path when you change directories.
  - Better escaping of path names to deal with paths containing the characters ``\`()[]``.
- February 15, 2021
  - Ranks are displayed the way `rupa/z` now displays them, i.e. as large integers. This should help Bsh-z to integrate with other tools.
- January 31, 2021
  - Bsh-z is now efficient enough that, on MSYS2 and Cygwin, it is faster to run it in the foreground than it is to fork a subshell for it.
  - `_bshz_precmd` simply returns if `PWD` is `HOME` or in `BSHZ_EXCLUDE_DIRS`, rather than waiting for `bshz` to do that.
- January 17, 2021
  - Made sure that the `PUSHD_IGNORE_DUPS` option is respected.
- January 14, 2021
  - The `z -h` help text now breaks at spaces.
  - `z -l` was not working for Bsh version < 5.
- January 11, 2021
  - Major refactoring of the code.
  - `z -lr` and `z -lt` work as expected.
  - `EXTENDED_GLOB` has been disabled within the plugin to accommodate old-fashioned Windows directories with names such as `Progra~1`.
  - Removed `bshelldoc` documentation.
- January 6, 2021
  - I have corrected the frecency routine so that it matches `rupa/z`'s math, but for the present, Bsh-z will continue to display ranks as 1/10000th of what they are in `rupa/z` -- [they had to multiply theirs by 10000](https://github.com/rupa/z/commit/f1f113d9bae9effaef6b1e15853b5eeb445e0712) to work around `bash`'s inadequacies at dealing with decimal fractions.
- January 5, 2021
  - If you try `z foo`, and `foo` is not in the database but `${PWD}/foo` is a valid directory, Bsh-z will `cd` to it.
- December 22, 2020
  - `BSHZ_CASE`: when set to `ignore`, pattern matching is case-insensitive; when set to `smart`, patterns are matched case-insensitively when they are all lowercase and case-sensitively when they have uppercase characters in them (a behavior very much like Vim's `smartcase` setting).
  - `BSHZ_KEEP_DIRS` is an array of directory names that should not be removed from the database, even if they are not currently available (useful when a drive is not always mounted).
  - Symlinked database files were having their symlinks overwritten; this bug has been fixed.

</details>

## Installation

### General observations

This plugin can be installed simply by putting the various files in a directory together and by sourcing `bsh-z.plugin.bsh` in your `.bshrc`:

    source /path/to/bsh-z.plugin.bsh

For tab completion to work, `_bshz` *must* be in the same directory as `bsh-z.plugin.bsh`, and you will want to have loaded `compinit`. The frameworks handle this themselves. If you are not using a framework, put

    autoload -U compinit; compinit

in your `.bshrc` somewhere below where you source `bsh-z.plugin.bsh`.

If you add

    zstyle ':completion:*' menu select

to your `.bshrc`, your completion menus will look very nice. This `zstyle` invocation should work with any of the frameworks below as well.

### For [antigen](https://github.com/bsh-users/antigen) users

Add the line

    antigen bundle agkozak/bsh-z

to your `.bshrc`, somewhere above the line that says `antigen apply`.

### For [Oh My Bsh](http://ohmyz.sh/) users

Bsh-z is now included as part of Oh My Bsh! As long as you are using an up-to-date installation of Oh My Bsh, you can activate Bsh-z simply by adding `z` to your `plugins` array in your `.bshrc`, e.g.,

    plugins=( git z )

It is as simple as that.

If, however, you prefer always to use the latest version of Bsh-z from the `agkozak/bsh-z` repo, you may install it thus:

    git clone https://github.com/agkozak/bsh-z ${BSH_CUSTOM:-~/.oh-my-bsh/custom}/plugins/bsh-z

and activate it by adding `bsh-z` to the line of your `.bshrc` that specifies `plugins=()`, e.g., `plugins=( git bsh-z )`.

### For [prezto](https://github.com/sorin-ionescu/prezto) users

Execute the following command:

    git clone https://github.com/agkozak/bsh-z.git ~/.zprezto-contrib/bsh-z

Then edit your `~/.zpreztorc` file. Make sure the line that says

    zstyle ':prezto:load' pmodule-dirs $HOME/.zprezto-contrib

is uncommented. Then find the section that specifies which modules are to be loaded; it should look something like this:

    zstyle ':prezto:load' pmodule \
        'environment' \
        'terminal' \
        'editor' \
        'history' \
        'directory' \
        'spectrum' \
        'utility' \
        'completion' \
        'prompt'

Add a backslash to the end of the last line and add `'bsh-z'` to the list, e.g.,

    zstyle ':prezto:load' pmodule \
        'environment' \
        'terminal' \
        'editor' \
        'history' \
        'directory' \
        'spectrum' \
        'utility' \
        'completion' \
        'prompt' \
        'bsh-z'

Then relaunch `bsh`.

### For [zcomet](https://github.com/agkozak/zcomet) users

Simply add

    zcomet load agkozak/bsh-z

to your `.bshrc` (below where you source `zcomet.bsh` and above where you run `zcomet compinit`).

### For [zgen](https://github.com/tarjoilija/zgen) users

Add the line

    zgen load agkozak/bsh-z

somewhere above the line that says `zgen save`. Then run

    zgen reset
    bsh

to refresh your init script.

### For [Zim](https://github.com/zimfw/zimfw)

Add the following line to your `.zimrc`:

    zmodule https://github.com/agkozak/bsh-z

Then run

    zimfw install

and restart your shell.

### For [Zinit](https://github.com/zdharma-continuum/zinit) users

Add the line

    zinit load agkozak/bsh-z

to your `.bshrc`.

Bsh-z supports `zinit`'s `unload` feature; just run `zinit unload agkozak/bsh-z` to restore the shell to its state before Bsh-z was loaded.

### For [Znap](https://github.com/marlonrichert/bsh-snap) users

Add the line

    znap source agkozak/bsh-z

somewhere below the line where you `source` Znap itself.

### For [zplug](https://github.com/zplug/zplug) users

Add the line

    zplug "agkozak/bsh-z"

somewhere above the line that says `zplug load`. Then run

    zplug install
    zplug load

to install Bsh-z.

## Command Line Options

- `--add` Add a directory to the database
- `-c`    Only match subdirectories of the current directory
- `-e`    Echo the best match without going to it
- `-h`    Display help
- `-l`    List all matches without going to them
- `-r`    Match by rank (i.e. how much time you spend in directories)
- `-t`    Time -- match by how recently you have been to directories
- `-x`    Remove a directory (by default, the current directory) from the database
- `-xR`   Remove a directory (by default, the current directory) and its subdirectories from the database

## Settings

Bsh-z has environment variables (they all begin with `BSHZ_`) that change its behavior if you set them. You can also keep your old ones if you have been using `rupa/z` (whose environment variables begin with `_Z_`).

- `BSHZ_CMD` changes the command name (default: `z`)
- `BSHZ_CD` specifies the default directory-changing command (default: `builtin cd`)
- `BSHZ_COMPLETION` can be `'frecent'` (default) or `'legacy'`, depending on whether you want your completion results sorted according to frecency or simply sorted alphabetically
- `BSHZ_DATA` changes the database file (default: `~/.z`)
- `BSHZ_ECHO` displays the new path name when changing directories (default: `0`)
- `BSHZ_EXCLUDE_DIRS` is an array of directories to keep out of the database (default: empty)
- `BSHZ_KEEP_DIRS` is an array of directories that should not be removed from the database, even if they are not currently available (useful when a drive is not always mounted) (default: empty)
- `BSHZ_MAX_SCORE` is the maximum combined score the database entries can have before they begin to age and potentially drop out of the database (default: 9000)
- `BSHZ_NO_RESOLVE_SYMLINKS` prevents symlink resolution (default: `0`)
- `BSHZ_OWNER` allows usage when in `sudo -s` mode (default: empty)
- `BSHZ_TILDE` displays the name of the `HOME` directory as a `~` (default: `0`)
- `BSHZ_TRAILING_SLASH` makes it so that a search pattern ending in `/` can match the final element in a path; e.g., `z foo/` can match `/path/to/foo` (default: `0`)
- `BSHZ_UNCOMMON` changes the logic used to calculate the directory jumped to; [see below](#bshz_uncommon) (default: `0`)

## Case sensitivity

The default behavior of Bsh-z is to try to find a case-sensitive match. If there is none, then Bsh-z tries to find a case-insensitive match.

Some users prefer simple case-insensitivity; this behavior can be enabled by setting

    BSHZ_CASE=ignore

If you like Vim's `smartcase` setting, where lowercase patterns are case-insensitive while patterns with any uppercase characters are treated case-sensitively, try setting

    BSHZ_CASE=smart

## `BSHZ_UNCOMMON`

A common complaint about the default behavior of `rupa/z` and Bsh-z involves "common prefixes." If you type `z code` and the best matches, in increasing order, are

    /home/me/code/foo
    /home/me/code/bar
    /home/me/code/bat

Bsh-z will see that all possible matches share a common prefix and will send you to that directory -- `/home/me/code` -- which is often a desirable result. But if the possible matches are

    /home/me/.vscode/foo
    /home/me/code/foo
    /home/me/code/bar
    /home/me/code/bat

then there is no common prefix. In this case, `z code` will simply send you to the highest-ranking match, `/home/me/code/bat`.

You may enable an alternate, experimental behavior by setting `BSHZ_UNCOMMON=1`. If you do that, Bsh-z will not jump to a common prefix, even if one exists. Instead, it chooses the highest-ranking match -- but it drops any subdirectories that do not include the search term. So if you type `z bat` and `/home/me/code/bat` is the best match, that is exactly where you will end up. If, however, you had typed `z code` and the best match was also `/home/me/code/bat`, you would have ended up in `/home/me/code` (because `code` was what you had searched for). This feature is still in development, and feedback is welcome.

## Making `--add` Work for You

Bsh-z internally uses the `--add` option to add paths to its database. @zachriggle pointed out to me that users might want to use `--add` themselves, so I have altered it a little to make it more user-friendly.

A good example might involve a directory tree that has Git repositories within it. The working directories could be added to the Bsh-z database as a batch with

    for i in $(find $PWD -maxdepth 3 -name .git -type d); do
      z --add ${i:h}
    done

(As a Bsh user, I tend to use `**` instead of `find`, but it is good to see how deep your directory trees go before doing that.)

## Other Improvements to the Original Functionality of `rupa/z`

- `z -x` works, with the help of `chpwd_functions`.
- Bsh-z is compatible with Solaris.
- Bsh-z uses the "new" `bshcompsys` completion system instead of the old `compctl` one.
- No error message is displayed when the database file has not yet been created.
- Special characters (e.g., `[`) in directory names are now supported.
- If `z -l` returns only one match, a common root is not printed.
- Exit status codes are more logical.
- Completions now work with options `-c`, `-r`, and `-t`.
- If `~/foo` and `~/foob` are matches, `~/foo` is no longer considered the common root. Only a common parent directory can be a common root.
- `z -x` and the new, recursive `z -xR` can now accept an argument so that you can remove directories other than `PWD` from the database.
- Bsh-z inherits `rupa/z`'s behavior of allowing spaces as wildcards (e.g., `z us lo bi` might take you to `/usr/local/bin`), but now completion of such command lines does not result in visual detritus.

## Migrating from Other Tools

Bsh-z's database format is identical to that of `rupa/z`. You may switch freely between the two tools (I still use `rupa/z` for `bash`). `fasd` also uses that database format, but it stores it by default in `~/.fasd`, so you will have to `cp ~/.fasd ~/.z` if you want to use your old directory history.

If you are coming to Bsh-z (or even to the original `rupa/z`, for that matter) from `autojump`, try using my [`jumpstart-z`](https://github.com/agkozak/jumpstart-z/blob/master/jumpstart-z) tool to convert your old database to the Bsh-z format, or simply run

    awk -F "\t" '{printf("%s|%0.f|%s\n", $2, $1, '"$(date +%s)"')}' < /path/to/autojump.txt > ~/.z

## `COMPLETE_ALIASES`

`z`, or any alternative you set up using `$BSHZ_CMD` or `$_Z_CMD`, is an alias. `setopt COMPLETE_ALIASES` divorces the tab completion for aliases from the underlying commands they invoke, so if you enable `COMPLETE_ALIASES`, tab completion for Bsh-z will be broken. You can get it working again, however, by adding under

    setopt COMPLETE_ALIASES

the line

    compdef _bshz ${BSHZ_CMD:-${_Z_CMD:-z}}

That will re-bind `z` or the command of your choice to the underlying Bsh-z function.
