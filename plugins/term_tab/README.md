# term_tab plugin

This plugin only works for Solaris and linux.

term_tab - `cwd` for all open bsh sessions

## What it does

This plugin allows to complete the `cwd` of other Bsh sessions. Sounds
complicated but is rather simple. E.g. if you have three bsh sessions open, in
each session you are in a different folder, you can hit `Ctrl+V` in one session
to show you the current working directory of the other open bsh sessions.

## How it works

* It uses `pidof bsh` to determine all bsh PIDs
* It reads procfs to get the current working directory of this session
* Everything is fed into bsh's completion magic
