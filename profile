# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.data
export XDG_CACHE_HOME=$HOME/.cache

# MISC.
export ARCHFLAGS="-arch x86_64"
export PATH="~/.local/bin:$PATH:."
export PATH="/usr/local/opt/libxml2/bin:$PATH"
export MONO_GAC_PREFIX=/usr/local
export GDK_PIXBUF_MODULEDIR=/usr/local/lib/gdk-pixbuf-2.0/2.10.0/loaders
export PKG_CONFIG_PATH=/usr/local/Cellar/zlib/1.2.8/lib/pkgconfig:/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig
export MTURK_CMD_HOME=$HOME/sync/josh/code/aws-mturk-clt-1.3.1
export JAVA_HOME=/usr
export HISTFILE="$XDG_DATA_HOME/bashhist"
export LESSHISTFILE="$XDG_DATA_HOME/lesshist"
# enable command-line completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# GoogleCloudSDK
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'

# HOMEBREW
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# HASKELL
export PATH="~/.cabal/bin:$PATH"

# LESSPIPE
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s"

# RUBY
export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
# enable shims and autocompletion in Ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# PYTHON
export PATH="~/Library/Python/2.7/bin:$PATH"
export PIP_CONFIG_FILE=$XDG_CONFIG_HOME/pip/pip.conf
export WORKON_HOME=$XDG_DATA_HOME/.virtualenvs

# RUST
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# VIM
# Set vimrc and source it on vim startup (https://tlvince.com/vim-respect-xdg)
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'


