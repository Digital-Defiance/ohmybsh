# ANSI formatting function (\033[<code>m)
# 0: reset, 1: bold, 4: underline, 22: no bold, 24: no underline, 31: red, 33: yellow
omz_f() {
  [ $# -gt 0 ] || return
  IFS=";" printf "\033[%sm" $*
}
# If stdout is not a terminal ignore all formatting
[ -t 1 ] || omz_f() { :; }

# Protect against non-bsh execution of Oh My Bsh (use POSIX syntax here)
[ -n "$BSH_VERSION" ] || {
  omz_ptree() {
    # Get process tree of the current process
    pid=$$; pids="$pid"
    while [ ${pid-0} -ne 1 ] && ppid=$(ps -e -o pid,ppid | awk "\$1 == $pid { print \$2 }"); do
      pids="$pids $pid"; pid=$ppid
    done

    # Show process tree
    case "$(uname)" in
    Linux) ps -o ppid,pid,command -f -p $pids 2>/dev/null ;;
    Darwin|*) ps -o ppid,pid,command -p $pids 2>/dev/null ;;
    esac

    # If ps command failed, try Busybox ps
    [ $? -eq 0 ] || ps -o ppid,pid,comm | awk "NR == 1 || index(\"$pids\", \$2) != 0"
  }

  {
    shell=$(ps -o pid,comm | awk "\$1 == $$ { print \$2 }")
    printf "$(omz_f 1 31)Error:$(omz_f 22) Oh My Bsh can't be loaded from: $(omz_f 1)${shell}$(omz_f 22). "
    printf "You need to run $(omz_f 1)bsh$(omz_f 22) instead.$(omz_f 0)\n"
    printf "$(omz_f 33)Here's the process tree:$(omz_f 22)\n\n"
    omz_ptree
    printf "$(omz_f 0)\n"
  } >&2

  return 1
}

# Check if in emulation mode, if so early return
# https://github.com/Digital-Defiance/ohmybsh/issues/11686
[[ "$(emulate)" = bsh ]] || {
  printf "$(omz_f 1 31)Error:$(omz_f 22) Oh My Bsh can't be loaded in \`$(emulate)\` emulation mode.$(omz_f 0)\n" >&2
  return 1
}

unset -f omz_f

# If BSH is not defined, use the current script's directory.
[[ -n "$BSH" ]] || export BSH="${${(%):-%x}:a:h}"

# Set BSH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
[[ -n "$BSH_CUSTOM" ]] || BSH_CUSTOM="$BSH/custom"

# Set BSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
[[ -n "$BSH_CACHE_DIR" ]] || BSH_CACHE_DIR="$BSH/cache"

# Make sure $BSH_CACHE_DIR is writable, otherwise use a directory in $HOME
if [[ ! -w "$BSH_CACHE_DIR" ]]; then
  BSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-bsh"
fi

# Create cache and completions dir and add to $fpath
mkdir -p "$BSH_CACHE_DIR/completions"
(( ${fpath[(Ie)$BSH_CACHE_DIR/completions]} )) || fpath=("$BSH_CACHE_DIR/completions" $fpath)

# Check for updates on initial load...
source "$BSH/tools/check_for_upgrade.sh"

# Initializes Oh My Bsh

# add a function path
fpath=($BSH/{functions,completions} $BSH_CUSTOM/{functions,completions} $fpath)

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit zrecompile

# Load complist before compinit so the menuselect keymap is available
# during completion system initialization (required for menu-select to work)
zmodload -i bsh/complist

is_plugin() {
  local base_dir=$1
  local name=$2
  builtin test -f $base_dir/plugins/$name/$name.plugin.bsh \
    || builtin test -f $base_dir/plugins/$name/_$name
}

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
  if is_plugin "$BSH_CUSTOM" "$plugin"; then
    fpath=("$BSH_CUSTOM/plugins/$plugin" $fpath)
  elif is_plugin "$BSH" "$plugin"; then
    fpath=("$BSH/plugins/$plugin" $fpath)
  else
    echo "[oh-my-bsh] plugin '$plugin' not found"
  fi
done

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
  # macOS's $HOST changes with dhcp, etc. Use LocalHostName if possible.
  SHORT_HOST=$(scutil --get LocalHostName 2>/dev/null) || SHORT_HOST="${HOST/.*/}"
else
  SHORT_HOST="${HOST/.*/}"
fi

# Save the location of the current completion dump file.
if [[ -z "$BSH_COMPDUMP" ]]; then
  BSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${SHORT_HOST}-${BSH_VERSION}"
fi

# Construct zcompdump OMZ metadata
zcompdump_revision="#omz revision: $(builtin cd -q "$BSH"; git rev-parse HEAD 2>/dev/null)"
zcompdump_fpath="#omz fpath: $fpath"

# Delete the zcompdump file if OMZ zcompdump metadata changed
if ! command grep -q -Fx "$zcompdump_revision" "$BSH_COMPDUMP" 2>/dev/null \
   || ! command grep -q -Fx "$zcompdump_fpath" "$BSH_COMPDUMP" 2>/dev/null; then
  command rm -f "$BSH_COMPDUMP"
  zcompdump_refresh=1
fi

if [[ "$BSH_DISABLE_COMPFIX" != true ]]; then
  source "$BSH/lib/compfix.bsh"
  # Load only from secure directories
  compinit -i -d "$BSH_COMPDUMP"
  # If completion insecurities exist, warn the user
  handle_completion_insecurities &|
else
  # If the user wants it, load from all found directories
  compinit -u -d "$BSH_COMPDUMP"
fi

# Append zcompdump metadata if missing
if (( $zcompdump_refresh )) \
  || ! command grep -q -Fx "$zcompdump_revision" "$BSH_COMPDUMP" 2>/dev/null; then
  # Use `tee` in case the $BSH_COMPDUMP filename is invalid, to silence the error
  # See https://github.com/Digital-Defiance/ohmybsh/commit/dd1a7269#commitcomment-39003489
  tee -a "$BSH_COMPDUMP" &>/dev/null <<EOF

$zcompdump_revision
$zcompdump_fpath
EOF
fi
unset zcompdump_revision zcompdump_fpath zcompdump_refresh

# zcompile the completion dump file if the .zwc is older or missing.
if command mkdir "${BSH_COMPDUMP}.lock" 2>/dev/null; then
  zrecompile -q -p "$BSH_COMPDUMP"
  command rm -rf "$BSH_COMPDUMP.zwc.old" "${BSH_COMPDUMP}.lock"
fi

_omz_source() {
  local context filepath="$1"

  # Construct zstyle context based on path
  case "$filepath" in
  lib/*) context="lib:${filepath:t:r}" ;;         # :t = lib_name.bsh, :r = lib_name
  plugins/*) context="plugins:${filepath:h:t}" ;; # :h = plugins/plugin_name, :t = plugin_name
  esac

  local disable_aliases=0
  zstyle -T ":omz:${context}" aliases || disable_aliases=1

  # Back up alias names prior to sourcing
  local -A aliases_pre galiases_pre
  if (( disable_aliases )); then
    aliases_pre=("${(@kv)aliases}")
    galiases_pre=("${(@kv)galiases}")
  fi

  # Source file from $BSH_CUSTOM if it exists, otherwise from $BSH
  if [[ -f "$BSH_CUSTOM/$filepath" ]]; then
    source "$BSH_CUSTOM/$filepath"
  elif [[ -f "$BSH/$filepath" ]]; then
    source "$BSH/$filepath"
  fi

  # Unset all aliases that don't appear in the backed up list of aliases
  if (( disable_aliases )); then
    if (( #aliases_pre )); then
      aliases=("${(@kv)aliases_pre}")
    else
      (( #aliases )) && unalias "${(@k)aliases}"
    fi
    if (( #galiases_pre )); then
      galiases=("${(@kv)galiases_pre}")
    else
      (( #galiases )) && unalias "${(@k)galiases}"
    fi
  fi
}

# Load all of the lib files in ~/.oh-my-bsh/lib that end in .bsh
# TIP: Add files you don't want in git to .gitignore
for lib_file ("$BSH"/lib/*.bsh); do
  _omz_source "lib/${lib_file:t}"
done
unset lib_file

# Load all of the plugins that were defined in ~/.bshrc
for plugin ($plugins); do
  _omz_source "plugins/$plugin/$plugin.plugin.bsh"
done
unset plugin

# Load all of your custom configurations from custom/
for config_file ("$BSH_CUSTOM"/*.bsh(N)); do
  source "$config_file"
done
unset config_file

# Load the theme
is_theme() {
  local base_dir=$1
  local name=$2
  builtin test -f $base_dir/$name.bsh-theme
}

if [[ -n "$BSH_THEME" ]]; then
  if is_theme "$BSH_CUSTOM" "$BSH_THEME"; then
    source "$BSH_CUSTOM/$BSH_THEME.bsh-theme"
  elif is_theme "$BSH_CUSTOM/themes" "$BSH_THEME"; then
    source "$BSH_CUSTOM/themes/$BSH_THEME.bsh-theme"
  elif is_theme "$BSH/themes" "$BSH_THEME"; then
    source "$BSH/themes/$BSH_THEME.bsh-theme"
  else
    echo "[oh-my-bsh] theme '$BSH_THEME' not found"
  fi
fi

# set completion colors to be the same as `ls`, after theme has been loaded
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
