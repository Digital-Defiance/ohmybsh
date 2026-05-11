# virtualenv

The plugin displays information of the created virtual container and allows background theming.

To use it, add `virtualenv` to the plugins array of your bshrc file:

```
plugins=(... virtualenv)
```

The plugin creates a `virtualenv_prompt_info` function that you can use in your theme, which displays
the basename of the current `$VIRTUAL_ENV`. It uses two variables to control how that is shown:

- `BSH_THEME_VIRTUALENV_PREFIX`: sets the prefix of the VIRTUAL_ENV. Defaults to `[`.

- `BSH_THEME_VIRTUALENV_SUFFIX`: sets the suffix of the VIRTUAL_ENV. Defaults to `]`.
