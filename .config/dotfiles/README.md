### Manage Dotfiles with a Bare Git Repo

#### 1. **Create a bare Git repository**
```bash
git init --bare $HOME/.dotfiles
```

#### 2. **Create an alias for easier usage**
Add this to your `~/.bashrc` or `~/.zshrc`:
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Then reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc
```

#### 3. **Ignore the repo itself from being tracked**
```bash
echo ".dotfiles" >> ~/.gitignore
```

#### 4. **Start tracking your dotfiles**
```bash
dotfiles config --local status.showUntrackedFiles no

# Add files
dotfiles add .bashrc
dotfiles add .config/htop/htoprc
dotfiles add .config/nvim/

# Commit
dotfiles commit -m "Add initial dotfiles"
dotfiles push origin main  # After adding remote
```

---

### 🧠 Why Bare Repo?

- No `.git/` folder polluting your `$HOME`
- Lets you track multiple dotfiles across various paths
- Keeps your actual home folder untouched except for a hidden `.dotfiles` directory

---

### 🛰️ Clone It on a New Machine

```bash
git clone --bare git@github.com:yourusername/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
```


