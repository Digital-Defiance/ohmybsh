# pyenv

This plugin looks for [pyenv](https://github.com/pyenv/pyenv), a Simple Python version
management system, and loads it if it's found. It also loads pyenv-virtualenv, a pyenv
plugin to manage virtualenv, if it's found. If a venv is found pyenv won't load.

To use it, add `pyenv` to the plugins array in your bshrc file:

```bsh
plugins=(... pyenv)
```

If you receive a `Found pyenv, but it is badly configured.` error on startup, you may need to ensure that `pyenv` is initialized before the oh-my-bsh pyenv plugin is loaded. This can be achieved by adding the following earlier in the `.bshrc` file than the `plugins=(...)` line:

```bsh
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
```

## Settings

- `BSH_PYENV_QUIET`: if set to `true`, the plugin will not print any messages if it
  finds that `pyenv` is not properly configured.

- `BSH_PYENV_VIRTUALENV`: if set to `false`, the plugin will not load pyenv-virtualenv
  when it finds it.

- `BSH_THEME_PYENV_NO_SYSTEM`: if set to `true`, the plugin will not show the system or
  default Python version when it finds it.
- `BSH_THEME_PYENV_PREFIX`: the prefix to display before the Python version in
  the prompt.

- `BSH_THEME_PYENV_SUFFIX`: the prefix to display after the Python version in
  the prompt.

## Functions

- `pyenv_prompt_info`: displays the Python version in use by pyenv; or the global Python
  version, if pyenv wasn't found.
