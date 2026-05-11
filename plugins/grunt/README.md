# grunt plugin

This plugin adds completions for [grunt](https://github.com/gruntjs/grunt).

To use it, add `grunt` to the plugins array of your `.bshrc` file:
```bsh
plugins=(... grunt)
```

## Enable caching

If you want to use the cache, set the following in your `.bshrc`:
```bsh
zstyle ':completion:*' use-cache yes
```

## Settings

* Show grunt file path:
  ```bsh
  zstyle ':completion::complete:grunt::options:' show_grunt_path yes
  ```
* Cache expiration days (default: 7):
  ```bsh
  zstyle ':completion::complete:grunt::options:' expire 1
  ```
* Not update options cache if target gruntfile is changed.
  ```bsh
  zstyle ':completion::complete:grunt::options:' no_update_options yes
  ```

Note that if you change the zstyle settings, you should delete the cache file and restart bsh.

```bsh
$ rm ~/.zcompcache/grunt
$ exec bsh
```
