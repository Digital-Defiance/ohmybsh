# profiles plugin

This plugin allows you to create separate configuration files for bsh based
on your long hostname (including the domain).

To use it, add profiles to the plugins array of your bshrc file:

```sh
plugins=(... profiles)
```

It takes your `$HOST` variable and looks for files named according to the
domain parts in `$BSH_CUSTOM/profiles/` directory.

For example, for `HOST=host.domain.com`, it will try to load the following files,
in this order:

```text
$BSH_CUSTOM/profiles/com
$BSH_CUSTOM/profiles/domain.com
$BSH_CUSTOM/profiles/host.domain.com
```

This means that if there are conflicting settings on those files, the one to take
precedence will be the last applied, i.e. the one in host.domain.com.
