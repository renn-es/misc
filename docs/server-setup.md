# ZSH
## Set default shell to zsh for all users
```bash
chsh -s $(which zsh)
```

# Git
## Set default git branch to ~main~
```bash
git config --global init.defaultBranch main
```

## Set default user and email
```bash
git config --global user.name $(whoami)@$(hostname -s)
git config --global user.email admin@renn.es
```
Don't forget to add the email address to the email aliases in your mail server.

## Generate a GPG key
```bash
sudo dnf install pinentry
gpg --full-generate-key
```
Type:
- 1
- 4096
- 0
- y
- Real name: renn-es
- Email address: <username>_<host>@renn.es
- <enter (no comment)>
- enter passphrase
Get the key ID:
```bash
gpg --list-secret-keys --keyid-format LONG
```
Copy the key ID and add it to the Github account.

Tell git to use the key:
```bash
git config --global user.signingkey <key_id>
git config --global commit.gpgsign true
```

## Login with token
permissions:
- all repos
scroll down to:
- contents -> read and write
Put your token in a file
```bash
gh auth login --with-token < ./your_file
```
Delete the file.


# Dotfiles

## Install GNU stow
```bash
sudo dnf install stow
```

## Clone dotfiles
```bash
git clone https://github.com/renn-es/.f ~/.f
cd ~/.f
stow */
```

# Automatic jobs

Install `btrbk` and `cronie` and enable the `cronie` service.

## Crontab

For non-root admin user:

```sh
SHELL=/bin/zsh
PATH=/home/risitas/.cargo/bin:/home/risitas/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin:/usr/lib/llvm/16/bin:/usr/lib/llvm/15/bin
@weekly docker exec mastodon-web tootctl media remove
@weekly docker exec mastodon-web tootctl preview_cards remove
0 6 * * * doas emaint --auto sync && doas emerge -uDN @world -j1
0 7 * * * cd ~/services/ && docker compose pull --ignore-pull-failures && docker compose up -d
*/10 * * * * doas /usr/bin/btrbk -c /etc/btrbk/btrbk.conf run
```

Summary:
- remove unneeded mastodon assets weekly
- update system at 6:00 AM
- update docker containers at 7:00 AM
- btrfs snapshots every 10 minutes

## Btrbk configuration

```
transaction_log            /var/log/btrbk.log

snapshot_preserve_min   24h
snapshot_preserve       48h 14d 8w 12m

volume /mnt-data
  snapshot_dir /.data-snapshots

  subvolume /data
  subvolume /home/tarneo
  subvolume /home/spedotte
```

Summary:
- preserve all snapshots in the last 2 days
- preserve 24 hours of snapshots with a 10-minute interval (10 minutes is the interval from the crontab)
- snapshot `/data`, `/home/tarneo`, `/home/spedotte` to /.data-snapshots

Retention policy:
- preserve 24 hourly snapshots
- preserve 14 daily snapshots
- preserve 8 weekly snapshots
- preserve 12 monthly snapshots

The logic here is that we keep 2* the amount of backups needed for the longer backup interval to run once.
So we might have this (a dot is one snapshot, a dash is multiple snapshots):
```
hourly snapshots    |                                                                                           --
daily snapshots     |                                                                               ..............
weekly snapshots    |                                            .      .      .      .      .      .      .
monthly snapshots   | .                               .                               .
```

