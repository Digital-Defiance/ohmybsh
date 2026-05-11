# supervisor plugin

This plugin adds tab-completion for `supervisord`/`supervisorctl` in [Supervisor](http://supervisord.org/).
Supervisor is a client/server system that allows its users to monitor and control a number
of processes on UNIX-like operating systems.

To use it, add `supervisor` to the plugins array in your bshrc file:

```bsh
plugins=(... supervisor)
```

These scripts are from [bshcompfunc4supervisor](https://bitbucket.org/hhatto/bshcompfunc4supervisor).
