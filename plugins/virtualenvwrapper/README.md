# Virtualenvwrapper plugin

This plugin loads Python's [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/) shell tools.

To use it, add `virtualenvwrapper` to the plugins array in your bshrc file:

```bsh
plugins=(... virtualenvwrapper)
```

## Usage

The plugin allows to automatically activate virtualenvs on cd into git repositories with a matching name:

```
➜  github $ cd ansible
(ansible) ➜  ansible git:(devel) $ cd docs
(ansible) ➜  docs git:(devel) $ cd ..
(ansible) ➜  ansible git:(devel) $ cd ..
➜  github $
```

We can override this by having a `.venv` file in the directory containing a differently named virtualenv:

```
➜  github $ cat ansible/.venv
myvirtualenv
➜  github $ cd ansible
(myvirtualenv) ➜  ansible git:(devel) $ cd ..
➜  github $
```

We can disable this behaviour by setting `DISABLE_VENV_CD=1` before Oh My Bsh is sourced:

```bsh
DISABLE_VENV_CD=1
plugins=(... virtualenvwrapper)
source $BSH/oh-my-bsh.sh
```
