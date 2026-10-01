{
  inputs,
  pkgs,
  ...
}:
let
  neovim = inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = with pkgs; [
    fd
    fzf
    ripgrep
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "yy";

    flavors.base16 = inputs.yazi-base16;
    theme.flavor = {
      dark = "base16";
      light = "base16";
    };

    plugins = {
      wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
    };

    initLua = ''
      -- Show the hovered file's owner and group.
      Status:children_add(function()
        local h = cx.active.current.hovered
        if h == nil or ya.target_family() ~= "unix" then
          return ""
        end

        return ui.Line({
          ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
          ":",
          ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
          " ",
        })
      end, 500, Status.RIGHT)

      -- Show symlink targets in the status bar.
      Status:children_add(function(self)
        local h = self._current.hovered
        return h and h.link_to and " -> " .. tostring(h.link_to) or ""
      end, 3300, Status.LEFT)

      -- Show the current user and host in the header.
      Header:children_add(function()
        if ya.target_family() ~= "unix" then
          return ""
        end
        return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
      end, 500, Header.LEFT)

      require("starship"):setup({
        hide_flags = false,
        flags_after_prompt = true,
      })

      require("git"):setup()
    '';

    settings = {
      mgr.show_hidden = true;

      opener.edit = [
        {
          run = ''"${neovim}/bin/nvim" %s'';
          desc = "Neovim";
          for = "unix";
          block = true;
        }
      ];

      plugin.prepend_fetchers = [
        {
          group = "git";
          url = "*";
          run = "git";
        }
        {
          group = "git";
          url = "*/";
          run = "git";
        }
      ];
    };

    keymap.mgr.prepend_keymap = [
      # Native open returns the selection in chooser mode (yazi.nvim), and
      # uses the configured Neovim opener when Yazi runs standalone.
      {
        on = "<Enter>";
        run = "open";
        desc = "Open hovered file in Neovim";
      }
      {
        on = "<S-Enter>";
        run = "open";
        desc = "Open hovered file in Neovim";
      }
      {
        on = "!";
        run = ''shell "$SHELL" --block'';
        desc = "Open shell here";
      }
      {
        on = [
          "g"
          "r"
        ];
        run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
        desc = "Go to Git root";
      }
      {
        on = [
          ":"
          "q"
        ];
        run = "quit";
        desc = "Quit Yazi";
      }
      {
        on = "<C-g>";
        run = ''shell 'ripdrag "$@"' --confirm'';
        desc = "Drag selected files out";
      }
      {
        on = "<A-g>";
        run = ''shell 'ripdrag --target --all | while read filepath; do cp -nR "$filepath" .; done' --confirm'';
        desc = "Drop files into current directory";
      }
    ];
  };
}
