{
  pkgs,
  inputs,
  ...
}:
{
  home.file = {
    # ".config/yazi/yazi.toml".source = ./yazi.toml;
    # ".config/yazi/keymap.toml".source = ./keymap.toml;
    # ".config/yazi/init.lua".source = ./init.lua;
  };
  programs.yazi = {
    package = inputs.yazi.packages."${pkgs.system}".default;
    enable = true;
    initLua = ''
      -- Show user/group of files in status bar
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

      -- Show symlink in the status bar
      Status:children_add(function(self)
      	local h = self._current.hovered
      	if h and h.link_to then
      		return " -> " .. tostring(h.link_to)
      	else
      		return ""
      	end
      end, 3300, Status.LEFT)

      -- Show username and hostname in header
      Header:children_add(function()
      	if ya.target_family() ~= "unix" then
      		return ""
      	end
      	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
      end, 500, Header.LEFT)

      require("starship"):setup({
      	-- Hide flags (such as filter, find and search). This is recommended for starship themes which
      	-- are intended to go across the entire width of the terminal.
      	hide_flags = false, -- Default: false
      	-- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
      	flags_after_prompt = true, -- Default: true
      })

      require("git"):setup()
    '';
    settings = {
      manager = {
        sort_by = "alphabetical";
        show_hidden = true;
        show_symlink = true;
      };
      # cd
      cd_title = "Change directory:";
      cd_origin = "top-center";
      cd_offset = [
        0
        2
        50
        3
      ];

      # create
      create_title = [
        "Create:"
        "Create (dir):"
      ];
      create_origin = "top-center";
      create_offset = [
        0
        2
        50
        3
      ];

      # rename
      rename_title = "Rename:";
      rename_origin = "hovered";
      rename_offset = [
        0
        1
        50
        3
      ];

      # filter
      filter_title = "Filter:";
      filter_origin = "top-center";
      filter_offset = [
        0
        2
        50
        3
      ];

      # find
      find_title = [
        "Find next:"
        "Find previous:"
      ];
      find_origin = "top-center";
      find_offset = [
        0
        2
        50
        3
      ];

      # search
      search_title = "Search via {n}:";
      search_origin = "top-center";
      search_offset = [
        0
        2
        50
        3
      ];

      # shell
      shell_title = [
        "Shell:"
        "Shell (block):"
      ];
      shell_origin = "top-center";
      shell_offset = [
        0
        2
        50
        3
      ];

      confirm = {
        # trash
        trash_title = "Trash {n} selected file{s}?";
        trash_origin = "center";
        trash_offset = [
          0
          0
          70
          20
        ];
      };

      # delete
      delete_title = "Permanently delete {n} selected file{s}?";
      delete_origin = "center";
      delete_offset = [
        0
        0
        70
        20
      ];

      # overwrite
      overwrite_title = "Overwrite file?";
      overwrite_content = "Will overwrite the following file:";
      overwrite_origin = "center";
      overwrite_offset = [
        0
        0
        50
        15
      ];

      # quit
      quit_title = "Quit?";
      quit_content = "The following tasks are still running, are you sure you want to quit?";
      quit_origin = "center";
      quit_offset = [
        0
        0
        50
        15
      ];

      pick = {
        open_title = "Open with:";
        open_origin = "hovered";
        open_offset = [
          0
          1
          50
          7
        ];
      };

      which = {
        sort_by = "none";
        sort_sensitive = false;
        sort_reverse = false;
        sort_translit = false;
      };
      #
      # [[plugin.prepend_fetchers]]
      # id   = "git"
      # name = "*"
      # run  = "git"
      #
      # [[plugin.prepend_fetchers]]
      # id   = "git"
      # name = "*/"
      # run  = "git"
    };
    keymap = {
      };
    plugins = {
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
    };
  };
}
