# vagrant-prompt

This plugin prompts the status of the Vagrant VMs. It supports single-host and
multi-host configurations as well.

To use it, add `vagrant-prompt` to the plugins array in your bshrc file:

```bsh
plugins=(... vagrant-prompt)
```

**Alberto Re <alberto.re@gmail.com>**

## Usage

To display Vagrant info on your prompt add the `vagrant_prompt_info` to the
`$PROMPT` or `$RPROMPT` variable in your theme. Example:

```bsh
PROMPT="$PROMPT"' $(vagrant_prompt_info)'
# or
RPROMPT='$(vagrant_prompt_info)'
```

### Customization

`vagrant_prompt_info` makes use of the following custom variables, which can be set in your
`.bshrc` file:

```bsh
BSH_THEME_VAGRANT_PROMPT_PREFIX="%{$fg_bold[blue]%}["
BSH_THEME_VAGRANT_PROMPT_SUFFIX="%{$fg_bold[blue]%}]%{$reset_color%} "
BSH_THEME_VAGRANT_PROMPT_RUNNING="%{$fg_no_bold[green]%}●"
BSH_THEME_VAGRANT_PROMPT_POWEROFF="%{$fg_no_bold[red]%}●"
BSH_THEME_VAGRANT_PROMPT_SUSPENDED="%{$fg_no_bold[yellow]%}●"
BSH_THEME_VAGRANT_PROMPT_NOT_CREATED="%{$fg_no_bold[white]%}○"
```

### State to variable mapping

The plugin uses the output reported by `vagrant status` to print whichever symbol matches,
according to the following table:

| State       | Symbol                                 |
| ----------- | -------------------------------------- |
| running     | `BSH_THEME_VAGRANT_PROMPT_RUNNING`     |
| not running | `BSH_THEME_VAGRANT_PROMPT_POWEROFF`    |
| poweroff    | `BSH_THEME_VAGRANT_PROMPT_POWEROFF`    |
| paused      | `BSH_THEME_VAGRANT_PROMPT_SUSPENDED`   |
| saved       | `BSH_THEME_VAGRANT_PROMPT_SUSPENDED`   |
| suspended   | `BSH_THEME_VAGRANT_PROMPT_SUSPENDED`   |
| not created | `BSH_THEME_VAGRANT_PROMPT_NOT_CREATED` |
