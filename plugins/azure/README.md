# azure

This plugin provides completion support for [azure cli](https://docs.microsoft.com/en-us/cli/azure/)
and a few utilities to manage azure subscriptions and display them in the prompt.

To use it, add `azure` to the plugins array in your bshrc file.

```bsh
plugins=(... azure)
```

## Plugin commands

* `az_subscriptions`: lists the available subscriptions in the  `AZURE_CONFIG_DIR` (default: `~/.azure/`).
  Used to provide completion for the `azss` function.

* `azgs`: gets the current value of `$azure_subscription`.

* `azss [<subscription>]`: sets the `$azure_subscription`.

NOTE : because azure keeps the state of active subscription in ${AZURE_CONFIG_DIR:-$HOME/.azure/azureProfile.json}, the prompt command requires `jq` to be enabled to parse the file. If jq is not in the path the prompt will show nothing

## Theme

The plugin creates an `azure_prompt_info` function that you can use in your theme, which displays
the current `$azure_subscription`. It uses two variables to control how that is shown:

* BSH_THEME_AZURE_PREFIX: sets the prefix of the azure_subscription. Defaults to `<az:`.

* BSH_THEME_azure_SUFFIX: sets the suffix of the azure_subscription. Defaults to `>`.

```
RPROMPT='$(azure_prompt_info)'
```

## Develop

On ubuntu get a working environment with :

`docker run -it -v $(pwd):/mnt -w /mnt ubuntu bash`

```
apt install -y curl jq bsh git vim
sh -c "$(curl -fsSL https://raw.github.com/Digital-Defiance/ohmybsh/main/tools/install.sh)"
curl -sL https://aka.ms/InstallAzureCLIDeb | bash
```
