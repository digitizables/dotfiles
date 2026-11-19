# dotfiles

Copies of the shell, terminal, and git signing config from this machine. Paths are relative to `$HOME`.

- `home/.zshrc` and `home/.zprofile` — Gentoo-style prompt and the VT1 GNOME start
- `home/.config/ghostty/config.ghostty` — black window, GNOME 16-color palette, Zellij
- `home/.config/zellij/config.kdl` — full pane frames, focused border `#CCFF00`
- `home/.local/share/applications/com.mitchellh.ghostty.desktop` — OpenRC override, DBus activation off
- `home/.gitconfig` and `home/.config/git/allowed_signers` — commits signed with the SSH public key

App state, shell history, and private keys are not in this repo.
