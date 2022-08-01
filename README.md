# Adam's dotfiles


Configuration files for bash, vim, git, irb, and tmux.

## Installation

The installation script will automatically clone the git repository, symlink
the dotfiles to your home directory, and install the vim plugins.

```bash
$ bash < <(curl --silent https://raw.github.com/abiggy/dotfiles/master/install.sh)
```

## Fonts for iTerm2 and Vim
```bash
$ brew tap homebrew/cask-fonts
$ brew cask install homebrew/cask-fonts/font-hack-nerd-font
``
Choose Font in iTerm2;
`Hack Nerd Font`

### Credit
This is based on https://github.com/thenovices/dotfiles
