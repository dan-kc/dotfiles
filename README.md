# Dotfiles

This repository contains the configuration files (dotfiles) for various applications and tools that I use on my system. These dotfiles are managed using [GNU Stow](https://www.gnu.org/software/stow/), a symlink farm manager.

## Getting Started

To get started with using my dotfiles, follow the steps below:

### Prerequisites

- Make sure you have [GNU Stow](https://www.gnu.org/software/stow/) installed on your system. If not, you can install it using your package manager.

### Installation

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/dan-kc/dotfiles.git
   ```

2. Navigate into the cloned repository:

   ```bash
   cd dotfiles
   ```

3. Use Stow to symlink the desired configuration files to their respective locations:

   ```bash
   stow <folder-name>
   ```

   Replace `<folder-name>` with the name of the folder containing the configuration files you want to use. For example, if you want to symlink the configuration files for nvim, run:

   ```bash
   stow nvim
   ```

### Yabai Installation

One of the packages listed in the Brewfile is yabai, a tiling window manager. However, yabai requires additional installation steps. To install yabai from the HEAD, please follow the instructions in the [this guide](<https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(from-HEAD)>).

Make sure to complete the installation steps mentioned in the guide to set up yabai correctly.

## Acknowledgements

I've drawn inspiration and learned from various sources while creating my dotfiles, in particular from:

- [Ben Frain](https://github.com/benfrain)
- [Josh Medeski](https://github.com/joshmedeski)
- [Folke Lemaitre](https://github.com/folke)

## Todo

- Xplr tmux
- Complete TSX snippets
