# Neovim Config

This is a place for me to store my Neovim configuration, experiment with plugins, and try new setups. o7

# Installation Notes

Cloning this repository does **not** install everything Neovim needs.

The repository contains the configuration files, but plugins, language servers, debuggers, Treesitter parsers, and system dependencies must be installed separately on each machine.

## 1. Install Neovim

Install a recent version of Neovim.

Check the installed version:

```bash
nvim --version
```

Using roughly the same Neovim version on each machine helps prevent compatibility issues.

## 2. Install Required System Programs

The configuration expects several external programs to exist.

At minimum, install:

- Git
- Ripgrep
- A C/C++ compiler
- Curl
- Unzip
- A system clipboard provider

Check whether they are installed:

```bash
git --version
rg --version
g++ --version
curl --version
unzip -v
```

### Clipboard Support

For Wayland, install:

```bash
wl-clipboard
```

For X11, install either:

```bash
xclip
```

or:

```bash
xsel
```

Clipboard support is required because some mappings use Neovim's `"+` system clipboard register.

Check clipboard support inside Neovim with:

```vim
:checkhealth provider
```

## 3. Clone the Configuration

Back up an existing Neovim configuration first:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

Clone this repository into the expected configuration directory:

```bash
git clone https://github.com/DamascusSmith/nvim ~/.config/nvim
```

The final path should be:

```text
~/.config/nvim/init.lua
```

It should **not** be:

```text
~/.config/nvim/nvim/init.lua
```

## 4. Install Packer

The following line in `packer.lua`:

```lua
vim.cmd [[packadd packer.nvim]]
```

does **not** install Packer.

It only tells Neovim to load Packer if Packer is already installed.

Install Packer manually:

```bash
git clone --depth 1 \
  https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Open Neovim:

```bash
nvim
```

Install and synchronize the plugins:

```vim
:PackerSync
```

Close and reopen Neovim after the installation finishes.

The generated `plugin/packer_compiled.lua` file does not contain the actual plugins. The plugins still need to be downloaded onto each machine using `:PackerSync`.

## 5. Create the Undo Directory

`set.lua` contains:

```lua
vim.opt.undodir = os.getenv("HOME") .. "/vim/undodir"
```

This means Neovim expects the following directory to exist:

```text
~/vim/undodir
```

Create it with:

```bash
mkdir -p ~/vim/undodir
```

The `-p` option prevents an error if the directory already exists.

## 6. Install Mason Packages

Mason installs external development tools such as language servers, formatters, and debuggers.

Open Mason inside Neovim:

```vim
:Mason
```

Install the tools used by this configuration:

```vim
:MasonInstall clangd clang-format codelldb
```

These provide:

- `clangd` — C and C++ language server
- `clang-format` — C and C++ formatter
- `codelldb` — C and C++ debugger

The debugger configuration currently expects `codelldb` to exist at:

```text
~/.local/share/nvim/mason/bin/codelldb
```

Confirm it exists:

```bash
ls ~/.local/share/nvim/mason/bin/codelldb
```

## 7. Install Treesitter Parsers

Treesitter parsers are not stored in this repository.

Install or update them inside Neovim:

```vim
:TSUpdate
```

If Treesitter fails, run:

```vim
:checkhealth nvim-treesitter
```

A compiler may be required to build some parsers.

## 8. Run Health Checks

Run the general Neovim health check:

```vim
:checkhealth
```

Useful individual checks include:

```vim
:checkhealth provider
:checkhealth telescope
:checkhealth nvim-treesitter
```

Check Packer:

```vim
:PackerStatus
```

Check Mason:

```vim
:Mason
```

# Machine-Specific Things to Remember

## Plugin Files Are Not Stored in the Repository

Git stores the plugin configuration, but not the installed plugin repositories.

Run this on every new machine:

```vim
:PackerSync
```

## Mason Packages Are Not Stored in the Repository

Language servers, formatters, and debuggers must be installed again:

```vim
:MasonInstall clangd clang-format codelldb
```

## Treesitter Parsers Are Not Stored in the Repository

Install them again with:

```vim
:TSUpdate
```

## The Undo Directory Is Not Created Automatically

Create it manually:

```bash
mkdir -p ~/vim/undodir
```

## The C++ Mappings Require `g++`

Some custom mappings compile C++ files directly using `g++`.

Check that it is installed:

```bash
g++ --version
```

Different compiler versions may produce different warnings, especially because the configuration uses strict warning flags.

# Complete New-Machine Setup

```bash
mv ~/.config/nvim ~/.config/nvim.backup

git clone https://github.com/DamascusSmith/nvim ~/.config/nvim

git clone --depth 1 \
  https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p ~/vim/undodir

nvim
```

Then run inside Neovim:

```vim
:PackerSync
```

Restart Neovim, then run:

```vim
:MasonInstall clangd clang-format codelldb
:TSUpdate
:checkhealth
```

# Basic Troubleshooting

If Neovim opens without the expected configuration:

```vim
:echo $MYVIMRC
```

It should point to:

```text
~/.config/nvim/init.lua
```

Check where Neovim stores its data:

```vim
:echo stdpath("data")
```

Normally, this will be:

```text
~/.local/share/nvim
```

If a plugin is missing:

```vim
:PackerSync
```

If a language server or debugger is missing:

```vim
:Mason
```

If syntax highlighting is broken:

```vim
:TSUpdate
:checkhealth nvim-treesitter
```

If clipboard mappings do not work:

```vim
:checkhealth provider
```
