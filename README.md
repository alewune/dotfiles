# dotfiles

Sway/SwayFX on Arch (CachyOS/Garuda), plus Neovim, tmux, kitty, waybar and friends.
Tracked as a bare git repo in `~/.dotfiles` with `$HOME` as the work tree. Only files
added explicitly are tracked, so nothing private is picked up by accident.

## Install on a new machine

```sh
git clone --bare https://github.com/alewune/dotfiles.git $HOME/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config status.showUntrackedFiles no
dot checkout        # if it complains about existing files, move them aside and retry
```

Then install the tools (neovim, tmux, kitty, sway, waybar, JetBrains Mono Nerd Font) and:

- tmux plugins: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, start tmux, press `prefix + I`
- Neovim: open `nvim`; lazy.nvim bootstraps itself and installs everything

## Daily use

```sh
dot status
dot add ~/.config/foo/bar.conf
dot commit -m "foo: change bar"
dot push
```
