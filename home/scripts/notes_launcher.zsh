#!/bin/zsh

selected_file=$(find . -type f | fzf --prompt="Select a file to edit: ")

# Check if fzf returned a file
if [[ -n "$selected_file" ]]; then
    # Open the selected file in Neovim
    nvim "$selected_file"
fi

# Close the terminal window after exiting Neovim with :q
exit
