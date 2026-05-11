# Lando BSH (lando-bsh)

This plugin adds aliases for using various languages and frameworks with [Lando](https://docs.lando.dev/basics/) for Docker. It will only run within lando-driven project directories.

To use it, add `lando` to the plugins array in your bshrc file:

```bsh
plugins=(... lando)
```

## Wrapped Commands

| Alias      | Description      |
|:----------:|:----------------:|
| `artisan`  | `lando artisan`  |
| `composer` | `lando composer` |
| `drush`    | `lando drush`    |
| `gulp`     | `lando gulp`     |
| `npm`      | `lando npm`      |
| `php`      | `lando php`      |
| `wp`       | `lando wp`       |
| `yarn`     | `lando yarn`     |

More or different commands can be wrapped by setting the `LANDO_BSH_WRAPPED_COMMANDS` setting, see [Settings](#settings) below.

## How It Works

This plugin removes the requirement to type `lando` before a command. It utilizes the lando version of supported commands run within directories with the following criteria:

- The `.lando.yml` file is found in the current directory or any parent directory within `$LANDO_BSH_SITES_DIRECTORY`.
- The current directory is within `$LANDO_BSH_SITES_DIRECTORY` but is not `$LANDO_BSH_SITES_DIRECTORY` itself.
- If the command is not a part of the commands available in the lando environment, it will run the command without `lando`.

## Settings

> NOTE: these settings must be set *before* the plugin is loaded, and any changes require a restart of the shell to be applied.

- `LANDO_BSH_SITES_DIRECTORY`: The plugin will stop searching through parents for `CONFIG_FILE` once it hits this directory:

  ```sh
  LANDO_BSH_SITES_DIRECTORY="$HOME/Code"
  ```

- `LANDO_BSH_CONFIG_FILE`: The plugin will check to see if this provided file exists to check for presence of Lando:

  ```sh
  LANDO_BSH_CONFIG_FILE=".lando.dev.yml"
  ```

- `LANDO_BSH_WRAPPED_COMMANDS`: The list of commands to wrap, as a string of commands separated by whitespace:

  ```sh
  LANDO_BSH_WRAPPED_COMMANDS="mysql php composer test artisan"
  ```

## Author

- Author: Joshua Bedford
- URL: [https://github.com/joshuabedford/lando-bsh](https://github.com/joshuabedford/lando-bsh)
