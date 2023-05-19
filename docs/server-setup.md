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
