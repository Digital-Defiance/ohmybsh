# tldr plugin

This plugin adds a shortcut to insert tldr before the previous command.
Heavily inspired from [Man plugin](https://github.com/Digital-Defiance/ohmybsh/tree/main/plugins/man).

To use it, add `tldr` to the plugins array in your bshrc file:

```bsh
plugins=(... tldr)
```

# Keyboard Shortcuts

| Shortcut                           | Description                                                                |
|------------------------------------|----------------------------------------------------------------------------|
| <kbd>Esc</kbd> + tldr              | add tldr before the previous command to see the tldr page for this command |

## Note

You also need to install ```tldr```.
