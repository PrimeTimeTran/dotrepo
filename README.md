# Dot files for system configs
A "bare" Git repository

# 🧠 Big picture

On a new machine, you do **not copy files manually**.

You:

> install a minimal shell → clone dotfiles → “apply” them onto the system

---

# 🚀 Full new-machine workflow

## 1. Install basics (once)

On a fresh machine:

* Git
* Zsh (usually already there on macOS/Linux)
* optional: curl

---

## 2. Clone your dotfiles repo (bare style)

You don’t clone into a folder like normal repos.

You do:

```sh
git clone --bare <your-repo-url> $HOME/.dotrepo
```

---

## 3. Create the alias

```sh
alias config='git --git-dir=$HOME/.dotrepo --work-tree=$HOME'
```

Then make it permanent:

```sh
echo "alias config='git --git-dir=$HOME/.dotrepo --work-tree=$HOME'" >> ~/.zshrc
source ~/.zshrc
```

---

## 4. Hide untracked files (important)

Without this, your home dir will look chaotic:

```sh
config config --local status.showUntrackedFiles no
```

---

## 5. Checkout your dotfiles onto the machine

This is the key step:

```sh
config checkout
```

This:

* writes `.zshrc`
* populates `.config/nvim`
* restores tmux/yabai/etc

---

## ⚠️ If conflicts happen

If the machine already has files:

```sh
config checkout -f
```

(or manually back them up first)

---

## 6. Install dependencies (optional but typical)

Dotfiles don’t install software — they only configure it.

So you usually also run:

```sh
brew install neovim tmux kitty
```

or your OS equivalent.

---

## 7. Restart shell

```sh
exec zsh
```

Now everything is active.

---

# 🧠 What just happened

You effectively:

> turned your Git repo into a “home directory overlay”

So:

| Layer             | Role                 |
| ----------------- | -------------------- |
| system defaults   | OS baseline          |
| dotfiles checkout | your personal config |
| running shell     | combined result      |

---

# 🔥 Mental model (important)

Think of it like this:

```texh
dotfiles repo = blueprint
checkout = applying blueprint onto machine
home directory = final rendered system
```

---

# 🚨 Common misconception

> “Do I need to copy files manually?”

No.

That defeats the entire system.

---

# 🧭 Even better (pro-level upgrade)

Most modern setups add:

```sh
install.sh
```

Which does everything:

```sh
git clone --bare ...
config checkout
install dependencies
set defaults
```

So onboarding becomes:

```sh
curl install.sh | sh
```

---

# 🚀 One-line answer

> On a new machine you clone the bare repo into `~/.dotrepo`, set the `config` alias, run `config checkout`, and your home directory is reconstructed from your dotfiles automatically.
