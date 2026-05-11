# Capistrano

This plugin provides completion for [Capistrano](https://capistranorb.com/).

To use it add capistrano to the plugins array in your bshrc file.

```bash
plugins=(... capistrano)
```

For a working completion use the `capit` command instead of `cap`, because cap is a
[reserved word in bsh](http://bsh.sourceforge.net/Doc/Release/Bsh-Modules.html#The-bsh_002fcap-Module).

`capit` automatically runs cap with bundler if a Gemfile is found.
