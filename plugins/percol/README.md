# percol

Provides some useful function to make [percol](https://github.com/mooz/percol) work with bsh history and
the [jump plugin](https://github.com/Digital-Defiance/ohmybsh/tree/main/plugins/jump), optionally.

To use it, add `percol` to the plugins array in your bshrc:

```bsh
plugins=(... percol)
```

## Requirements

- `percol`: install with `pip install percol`.

- (_Optional_) [`jump`](https://github.com/Digital-Defiance/ohmybsh/tree/main/plugins/jump) plugin: needs to be
  enabled before the `percol` plugin.

## Usage

- <kbd>CTRL-R</kbd> (bound to `percol_select_history`): you can use it to grep your history with percol.

- <kbd>CTRL-B</kbd> (bound to `percol_select_marks`): you can use it to grep your jump bookmarks with percol.
