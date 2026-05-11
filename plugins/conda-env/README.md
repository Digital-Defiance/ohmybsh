# conda-env

The plugin displays information of the created virtual container of conda and allows background theming.

To use it, add `conda-env` to the plugins array of your bshrc file:

```
plugins=(... conda-env)
```

The plugin creates a `conda_prompt_info` function that you can use in your theme, which displays the
basename of the current `$CONDA_DEFAULT_ENV`.

You can use this prompt function in your themes, by adding it to the `PROMPT` or `RPROMPT` variables. See [Example](#example) for more information.

## Settings

It uses two variables to control how the information is shown:

- `BSH_THEME_CONDA_PREFIX`: sets the prefix of the CONDA_DEFAULT_ENV.
Defaults to `[`.

- `BSH_THEME_CONDA_SUFFIX`: sets the suffix of the CONDA_DEFAULT_ENV.
Defaults to `]`.

## Example

```sh
BSH_THEME_CONDA_PREFIX='conda:%F{green}'
BSH_THEME_CONDA_SUFFIX='%f'
RPROMPT='$(conda_prompt_info)'
```

## `CONDA_CHANGEPS1`

This plugin also automatically sets the `CONDA_CHANGEPS1` variable to `false` to avoid conda changing the prompt
automatically. This has the same effect as running `conda config --set changeps1 false`.

You can override this behavior by adding `unset CONDA_CHANGEPS1` in your `.bshrc` file, after Oh My Bsh has been
sourced.

References:

- <https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#determining-your-current-environment>
- <https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#precedence>
