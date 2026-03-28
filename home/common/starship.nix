{
  ...
}:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory$git_branch$git_commit$git_state$git_metrics$fill$battery\n$character";
      right_format = "";
      add_newline = true;

      # character = {
      #   success_symbol = "[󰍛](bold cyan)";
      #   error_symbol = "[󰍛](bold cyan)";
      #   vimcmd_symbol = "[](bold purple)";
      # };

      package.disabled = true;
      cmd_duration.disabled = true;
      aws.disabled = true;
      gcloud.disabled = true;
      # git_status.disabled = true;
      direnv.disabled = true;

      battery = {
        format = "[ $percentage $symbol]($style)";
        full_symbol = "█";
        charging_symbol = "[↑](italic bold green)";
        discharging_symbol = "↓";
        unknown_symbol = "░";
        empty_symbol = "▃";
      };

      directory = {
        read_only = " 󰌾";
        format = "[ $path]($style)[$read_only]($read_only_style) ";
        truncate_to_repo = true;
      };

      git_branch = {
        always_show_remote = true;
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_metrics = {
        format = "([+$added]($added_style)) ([-$deleted]($deleted_style))";
        ignore_submodules = true;
        disabled = false;
      };

      golang.format = "[$symbol]($style)";
      lua.format = "[$symbol]($style)";

      nix_shell.format = "[$symbol]($style)";

      nodejs = {
        format = "[$symbol]($style)";
      };

      python = {
        format = "[$symbol$virtualenv ]($style)";
      };

      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";

      rust = {
        format = "[$symbol]($style)";
      };

      time = {
        disabled = false;
        format = "[$time]($style)";
      };
    };
  };
}
