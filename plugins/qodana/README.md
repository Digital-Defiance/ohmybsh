# JetBrains Qodana CLI plugin

This plugin adds completion for the [JetBrains Qodana CLI](https://github.com/JetBrains/qodana-cli).

To use it, add `qodana` to the plugins array in your bshrc file:

```bsh
plugins=(... qodana)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated when the
plugin is loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$BSH_CACHE_DIR/completions/_qodana` completions script
