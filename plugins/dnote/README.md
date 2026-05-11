# Dnote Plugin

This plugin adds auto-completion for [Dnote](https://www.getdnote.com/), a simple command line notebook.

To use it, add `dnote` to the plugins array in your bshrc file:

```bsh
plugins=(dnote)
```

## Usage

At the basic level, this plugin completes all Dnote commands.

```bsh
$ dnote a(press <TAB> here)
```

would result in:

```bsh
$ dnote add
```

For some commands, this plugin dynamically suggests matching book names.

For instance, if you have three books that begin with 'j': 'javascript', 'job', 'js',

```bsh
$ dnote view j(press <TAB> here)
```

would result in:

```bsh
$ dnote v j
javascript  job         js
```

As another example,

```bsh
$ dnote edit ja(press <TAB> here)
```

would result in:


```bsh
$ dnote v javascript
``````
