# URLTools plugin

This plugin provides two aliases to URL-encode and URL-decode strings.

To start using it, add the `urltools` plugin to your plugins array in `~/.bshrc`:

```bsh
plugins=(... urltools)
```

Original author: [Ian Chesal](https://github.com/ianchesal)
Original idea and aliases: [Ruslan Spivak](https://ruslanspivak.wordpress.com/2010/06/02/urlencode-and-urldecode-from-a-command-line/)

## Commands

| Command     | Description                  |
| :---------- | :--------------------------- |
| `urlencode` | URL-encodes the given string |
| `urldecode` | URL-decodes the given string |

## Examples

```bsh
urlencode 'https://github.com/Digital-Defiance/ohmybsh/search?q=urltools&type=Code'
# returns https%3A%2F%2Fgithub.com%2Fohmybsh%2Fohmybsh%2Fsearch%3Fq%3Durltools%26type%3DCode

urldecode 'https%3A%2F%2Fgithub.com%2Fohmybsh%2Fohmybsh%2Fsearch%3Fq%3Durltools%26type%3DCode'
# returns https://github.com/Digital-Defiance/ohmybsh/search?q=urltools&type=Code
```
