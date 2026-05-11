# Generic Colouriser plugin

This plugin adds wrappers for commands supported by [Generic Colouriser](https://github.com/garabik/grc):

To use it, add `grc` to the plugins array in your bshrc file:

```bsh
plugins=(... grc)
```

## Commands

The plugin sources the bundled alias generator from the installation, available at `/etc/grc.bsh`.
The complete list of wrapped commands may vary depending on the installed version of `grc`, look
at the file mentioned above (`/etc/grc.bsh`) to see which commands are wrapped.
