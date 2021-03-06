# Add `~/bin` to the `$PATH
if [[ ! ":$PATH:" == *":$HOME/bin:"* ]]; then
	export PATH="$HOME/bin:$PATH";
fi
if [[ ! ":$PATH:" == *":$HOME/.rbenv/plugins/ruby-build/bin:"* ]]; then
	export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH";
fi
if [[ ! ":$PATH:" == *":/usr/local/aws/bin:"* ]]; then
	export PATH="/usr/local/aws/bin:$PATH";
fi

# /usr/local/bin
if [[ ! ":$PATH:" == *":/usr/local/sbin:"* ]]; then
	export PATH="/usr/local/sbin:$PATH";
fi
#/usr/local/sbin
if [[ ! ":$PATH:" == *":/usr/local/sbin:"* ]]; then
	export PATH="/usr/local/sbin:$PATH";
fi
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,bash_logout,exports,aliases,functions,extra,git-completion,npm-completion}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

if [ -f /usr/local/bin/aws_completer ]; then
	complete -C '/usr/local/bin/aws_completer' aws
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

if command -v rbenv > /dev/null 2>&1; then
	eval "$(rbenv init -)"
fi

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

if command -v screenfetch >/dev/null 2>&1; then
  screenfetch -E
elif command -v archey > /dev/null 2>&1; then
	archey
fi
