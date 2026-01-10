{
  ...
}:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory$git_branch$git_commit$git_state$git_metrics$fill$time$battery\n$character";

      right_format = "";

      add_newline = true;

      character = {
        success_symbol = "[󰍛](bold cyan)";
        error_symbol = "[󰍛](bold cyan)";
        vimcmd_symbol = "[](bold purple)";
      };

      package.disabled = true;
      cmd_duration.disabled = true;

      aws = {
        symbol = " ";
        disabled = true;
      };

      gcloud.disabled = true;

      battery = {
        format = "[ $percentage $symbol]($style)";
        full_symbol = "█";
        charging_symbol = "[↑](italic bold green)";
        discharging_symbol = "↓";
        unknown_symbol = "░";
        empty_symbol = "▃";
      };

      buf.symbol = " ";
      c.symbol = " ";
      conda.symbol = " ";
      dart.symbol = " ";

      directory = {
        read_only = " 󰌾";
        format = "[ $path]($style)[$read_only]($read_only_style) ";
        truncate_to_repo = true;
      };

      direnv.disabled = true;
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";

      fill.symbol = " ";

      git_branch = {
        symbol = " ";
        always_show_remote = true;
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status.disabled = true;

      git_metrics = {
        format = "([ $added]($added_style)) ([ $deleted]($deleted_style))";
        ignore_submodules = true;
        disabled = false;
      };

      golang = {
        symbol = " ";
        format = "[$symbol]($style)";
      };

      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";
      hostname.ssh_symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";

      lua = {
        symbol = " ";
        format = "[$symbol]($style)";
      };

      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = "󰆥 ";

      nix_shell = {
        symbol = "  ";
        format = "[$symbol]($style)";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol]($style)";
      };

      os.symbols = {
        Alpaquita = " ";
        Alpine = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Windows = "󰍲 ";
      };

      pijul_channel.symbol = " ";

      python = {
        symbol = " ";
        format = "[$symbol$virtualenv ]($style)";
      };

      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";

      rust = {
        symbol = " ";
        format = "[$symbol]($style)";
      };

      scala.symbol = " ";

      time = {
        disabled = false;
        format = "[$time]($style)";
      };
    };
  };
}
