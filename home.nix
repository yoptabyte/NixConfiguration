{ config, pkgs, inputs, ... }:
let
  # Override upstream hash for warp preview .deb to current value
  warpPreview =
    inputs.warp-preview-flake.packages.${pkgs.system}.default.overrideAttrs (_: {
      src = pkgs.fetchurl {
        url = "https://app.warp.dev/download?channel=preview&package=deb";
        sha256 = "sha256-Iy64EIRYUHW/0aSF61o4FtYGFZzOEba8YhAV9+/7pzw=";
        curlOptsList = [ "-L" ];
        name = "warp-preview.deb";
      };
    });
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage
  home.username = "yoptabyte";
  home.homeDirectory = "/home/yoptabyte";

  # This value determines the Home Manager release that your
  # configuration is compatible with
  home.stateVersion = "23.11";

  # User packages
  home.packages = with pkgs; [
      (nerd-fonts.jetbrains-mono)
      (nerd-fonts.symbols-only)
      fd
      (ripgrep.override { withPCRE2 = true; })
      fontconfig
      nixfmt
      inputs.antigravity-nix.packages.x86_64-linux.default
      warpPreview
  ];

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Nixvim configuration
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Color scheme
    # colorschemes.catppuccin = {
    #   enable = true;
    #   settings = {
    #     flavour = "mocha";
    #     transparent_background = true;
    #   };
    # };

    colorschemes.gruvbox = {
      enable = true;
    };  

    # Global options
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      colorcolumn = "80";
      cursorline = true;
      mouse = "a";
      clipboard = "unnamedplus";
      completeopt = "menu,menuone,noselect";
      conceallevel = 0;
      fileencoding = "utf-8";
      pumheight = 10;
      showmode = false;
      showtabline = 2;
      splitbelow = true;
      splitright = true;
      timeoutlen = 300;
      writebackup = false;
    };

    # Global settings
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };


    # Keymaps
    keymaps = [
      # Better window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options = { desc = "Go to left window"; }; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options = { desc = "Go to lower window"; }; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options = { desc = "Go to upper window"; }; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options = { desc = "Go to right window"; }; }

      # Resize windows
      { mode = "n"; key = "<C-Up>"; action = ":resize +2<CR>"; options = { desc = "Increase window height"; }; }
      { mode = "n"; key = "<C-Down>"; action = ":resize -2<CR>"; options = { desc = "Decrease window height"; }; }
      { mode = "n"; key = "<C-Left>"; action = ":vertical resize -2<CR>"; options = { desc = "Decrease window width"; }; }
      { mode = "n"; key = "<C-Right>"; action = ":vertical resize +2<CR>"; options = { desc = "Increase window width"; }; }

      # Navigate buffers
      { mode = "n"; key = "<S-l>"; action = ":bnext<CR>"; options = { desc = "Next buffer"; }; }
      { mode = "n"; key = "<S-h>"; action = ":bprevious<CR>"; options = { desc = "Previous buffer"; }; }

      # Move text up and down
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; options = { desc = "Move block down"; }; }
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; options = { desc = "Move block up"; }; }

      # Stay in indent mode
      { mode = "v"; key = "<"; action = "<gv"; options = { desc = "Indent left"; }; }
      { mode = "v"; key = ">"; action = ">gv"; options = { desc = "Indent right"; }; }

      # Better paste
      { mode = "v"; key = "p"; action = "\"_dP"; options = { desc = "Paste without yanking"; }; }

      # Clear search highlighting
      { mode = "n"; key = "<Esc>"; action = ":noh<CR>"; options = { desc = "Clear search highlighting"; }; }

      # Save file
      { mode = "n"; key = "<C-s>"; action = ":w<CR>"; options = { desc = "Save file"; }; }

      # Quit
      { mode = "n"; key = "<leader>q"; action = ":q<CR>"; options = { desc = "Quit"; }; }
      { mode = "n"; key = "<leader>Q"; action = ":qa<CR>"; options = { desc = "Quit all"; }; }

      # Split windows
      { mode = "n"; key = "<leader>|"; action = ":vsplit<CR>"; options = { desc = "Vertical split"; }; }
      { mode = "n"; key = "<leader>-"; action = ":split<CR>"; options = { desc = "Horizontal split"; }; }

      # Telescope keymaps (AstroNvim style)
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options = { desc = "Find files"; }; }
      { mode = "n"; key = "<leader>fw"; action = "<cmd>Telescope live_grep<CR>"; options = { desc = "Find words"; }; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>"; options = { desc = "Find buffers"; }; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<CR>"; options = { desc = "Find help"; }; }
      { mode = "n"; key = "<leader>fo"; action = "<cmd>Telescope oldfiles<CR>"; options = { desc = "Find old files"; }; }
      { mode = "n"; key = "<leader>fc"; action = "<cmd>Telescope grep_string<CR>"; options = { desc = "Find word under cursor"; }; }
      { mode = "n"; key = "<leader>fk"; action = "<cmd>Telescope keymaps<CR>"; options = { desc = "Find keymaps"; }; }
      { mode = "n"; key = "<leader>fm"; action = "<cmd>Telescope marks<CR>"; options = { desc = "Find marks"; }; }
      { mode = "n"; key = "<leader>fr"; action = "<cmd>Telescope registers<CR>"; options = { desc = "Find registers"; }; }
      { mode = "n"; key = "<leader>ft"; action = "<cmd>Telescope colorscheme<CR>"; options = { desc = "Find themes"; }; }

      # Neo-tree keymaps
      { mode = "n"; key = "<leader>e"; action = ":Neotree toggle<CR>"; options = { desc = "Toggle file explorer"; }; }
      { mode = "n"; key = "<leader>o"; action = ":Neotree focus<CR>"; options = { desc = "Focus file explorer"; }; }

      # Git keymaps
      { mode = "n"; key = "<leader>gg"; action = ":LazyGit<CR>"; options = { desc = "LazyGit"; }; }
      { mode = "n"; key = "<leader>gj"; action = ":lua require('gitsigns').next_hunk()<CR>"; options = { desc = "Next git hunk"; }; }
      { mode = "n"; key = "<leader>gk"; action = ":lua require('gitsigns').prev_hunk()<CR>"; options = { desc = "Previous git hunk"; }; }
      { mode = "n"; key = "<leader>gp"; action = ":lua require('gitsigns').preview_hunk()<CR>"; options = { desc = "Preview git hunk"; }; }
      { mode = "n"; key = "<leader>gr"; action = ":lua require('gitsigns').reset_hunk()<CR>"; options = { desc = "Reset git hunk"; }; }
      { mode = "n"; key = "<leader>gs"; action = ":lua require('gitsigns').stage_hunk()<CR>"; options = { desc = "Stage git hunk"; }; }
      { mode = "n"; key = "<leader>gu"; action = ":lua require('gitsigns').undo_stage_hunk()<CR>"; options = { desc = "Undo stage git hunk"; }; }
      { mode = "n"; key = "<leader>gd"; action = ":lua require('gitsigns').diffthis()<CR>"; options = { desc = "Git diff"; }; }

      # LSP keymaps
      { mode = "n"; key = "<leader>la"; action = ":lua vim.lsp.buf.code_action()<CR>"; options = { desc = "Code action"; }; }
      { mode = "n"; key = "<leader>ld"; action = ":lua vim.lsp.buf.definition()<CR>"; options = { desc = "Go to definition"; }; }
      { mode = "n"; key = "<leader>lD"; action = ":lua vim.lsp.buf.declaration()<CR>"; options = { desc = "Go to declaration"; }; }
      { mode = "n"; key = "<leader>lf"; action = ":lua vim.lsp.buf.format()<CR>"; options = { desc = "Format"; }; }
      { mode = "n"; key = "<leader>lh"; action = ":lua vim.lsp.buf.hover()<CR>"; options = { desc = "Hover"; }; }
      { mode = "n"; key = "<leader>li"; action = ":lua vim.lsp.buf.implementation()<CR>"; options = { desc = "Go to implementation"; }; }
      { mode = "n"; key = "<leader>lr"; action = ":lua vim.lsp.buf.references()<CR>"; options = { desc = "References"; }; }
      { mode = "n"; key = "<leader>lR"; action = ":lua vim.lsp.buf.rename()<CR>"; options = { desc = "Rename"; }; }
      { mode = "n"; key = "<leader>ls"; action = ":lua vim.lsp.buf.signature_help()<CR>"; options = { desc = "Signature help"; }; }
      { mode = "n"; key = "<leader>lt"; action = ":lua vim.lsp.buf.type_definition()<CR>"; options = { desc = "Type definition"; }; }

      # Buffer management
      { mode = "n"; key = "<leader>c"; action = ":bdelete<CR>"; options = { desc = "Close buffer"; }; }
      { mode = "n"; key = "<leader>C"; action = ":bdelete!<CR>"; options = { desc = "Force close buffer"; }; }

      # Commenting
      { mode = "n"; key = "<leader>/"; action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>"; options = { desc = "Toggle comment line"; }; }
      { mode = "v"; key = "<leader>/"; action = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>"; options = { desc = "Toggle comment selection"; }; }
      
    ];

    # Plugins
    plugins = {
      # Telescope - fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        settings = {
          defaults = {
            prompt_prefix = " ";
            selection_caret = " ";
            path_display = [ "truncate" ];
            sorting_strategy = "ascending";
            layout_config = {
              horizontal = {
                prompt_position = "top";
                preview_width = 0.55;
              };
              vertical = {
                mirror = false;
              };
              width = 0.87;
              height = 0.80;
              preview_cutoff = 120;
            };
            mappings = {
              i = {
                "<C-n>" = "move_selection_next";
                "<C-p>" = "move_selection_previous";
                "<C-j>" = "move_selection_next";
                "<C-k>" = "move_selection_previous";
              };
            };
          };
        };
      };

      # Neo-tree - file explorer
      neo-tree = {
        enable = true;
         settings = {
          close_if_last_window = true;
          window = {
            width = 30;
            mappings = {
              "<space>" = "none";
            };
          };

          filesystem = {
            follow_current_file = {
              enabled = true;
            };
            use_libuv_file_watcher = true;
          };
        };
      };

      # Which-key - keybinding hints
      which-key = {
        enable = true;
        settings = {
          delay = 300;
          icons = {
            group = "";
          };
          spec = [
            { __unkeyed-1 = "<leader>f"; group = "Find"; }
            { __unkeyed-1 = "<leader>g"; group = "Git"; }
            { __unkeyed-1 = "<leader>l"; group = "LSP"; }
            { __unkeyed-1 = "<leader>b"; group = "Buffer"; }
          ];
        };
      };

      # Treesitter - syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # Typst support
      typst-vim.enable = true;

      # LSP configuration
      lsp = {
        enable = true;
        servers = {
          # Haskell
          hls.enable = true;
          hls.installGhc = false;

          nil_ls.enable = true; # Nix
          lua_ls.enable = true; # Lua
          pyright.enable = true; # Python
          ts_ls.enable = true; # TypeScript/JavaScript
          java_language_server.enable = true;
          clojure_lsp.enable = true;
          gopls.enable = true;
          postgres_lsp.enable = true;
          nginx_language_server.enable = true;
          docker_language_server.enable = true;
          docker_compose_language_service.enable = true;
          markdown_oxide.enable = true;
          html.enable = true;
          vue_ls.enable = true;
          tailwindcss.enable = true;
          cssls.enable = true;

          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };

          clangd = {
            enable = true;
            settings = {
              cmd = [
                "clangd"
                "--background-index"
              ];
              filetypes = [
                "c"
                "cpp"
              ];
              root_markers = [
                "compile_commands.json"
                "compile_flags.txt"
              ];
            };
          };

        };
      };

      # Mason - LSP/DAP/Linter installer (note: in nixvim, LSPs are managed by nix)
      # We'll add it for compatibility but use nix-managed LSPs
      #lsp-format.enable = true;

      # Autocompletion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
      };

      # Snippets
      luasnip.enable = true;
      friendly-snippets.enable = true;

      # Git integration
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
            untracked.text = "┆";
          };
        };
      };

      # LazyGit integration
      lazygit.enable = true;

      # Status line
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "gruvbox";
            component_separators = {
              left = "";
              right = "";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" "diff" "diagnostics" ];
            lualine_c = [ "filename" ];
            lualine_x = [ "encoding" "fileformat" "filetype" ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
        };
      };

      # Buffer line
      bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            separator_style = "slant";
            always_show_bufferline = true;
            show_buffer_close_icons = true;
            show_close_icon = false;
            color_icons = true;
          };
        };
      };

      # Auto pairs
      nvim-autopairs.enable = true;

      # Comment
      comment = {
        enable = true;
        settings = {
          toggler = {
            line = "<leader>/";
            block = "<leader>bc";
          };
          opleader = {
            line = "<leader>/";
            block = "<leader>b";
          };
        };
      };
      
      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
        };
      };

      # Colorizer
      colorizer.enable = true;

      # Web devicons
      web-devicons.enable = true;

      # Surround
      nvim-surround.enable = true;

      # Todo comments
      todo-comments.enable = true;

      # Trouble - diagnostics
      trouble.enable = true;

      # Dashboard
      alpha = {
        enable = true;
        settings.layout = [
          {
            type = "padding";
            val = 2;
          }
          {
            opts = {
              hl = "Type";
              position = "center";
            };
            type = "text";
            val = [
              "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
              "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
              "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
              "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
              "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = {
              __raw = ''
                {
                  { type = "button", val = "  Find File", on_press = function() vim.cmd("Telescope find_files") end, opts = { shortcut = "SPC f f" } },
                  { type = "button", val = "  New File", on_press = function() vim.cmd("ene | startinsert") end, opts = { shortcut = "SPC n" } },
                  { type = "button", val = "  Recent Files", on_press = function() vim.cmd("Telescope oldfiles") end, opts = { shortcut = "SPC f o" } },
                  { type = "button", val = "  Find Word", on_press = function() vim.cmd("Telescope live_grep") end, opts = { shortcut = "SPC f w" } },
                  { type = "button", val = "  Quit", on_press = function() vim.cmd("qa") end, opts = { shortcut = "SPC q" } },
                }
              '';
            };
          }
          {
            type = "padding";
            val = 2;
          }
        ];
      };
    };

    # Extra plugins not in nixvim
    extraPlugins = with pkgs.vimPlugins; [
      vim-sleuth  # Auto-detect indentation
      typst-preview-nvim
    ];

    # Extra configuration
    extraConfigLua = ''
      -- Additional Lua configuration
      vim.opt.iskeyword:append("-")
      
      -- Highlight on yank
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank({ timeout = 200 })
        end,
      })

      -- LSP error handling: prevent nil value errors in dynamic capability registration
      local original_register = vim.lsp.handlers["client/registerCapability"]
      vim.lsp.handlers["client/registerCapability"] = function(err, result, ctx, config)
        if not result or not result.registrations then
          return
        end
        return original_register(err, result, ctx, config)
      end
    '';
  };

  # Git configuration
    programs.git = {
      enable = true;
      settings = {
        user.name = "yoptabyte";
        user.email = "telinnikolai@gmail.com";
      };
        settings.safe.directory = [
          "/etc/nixos"
        ];
    };

    # Shell configuration
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        # Custom bash configuration
        export EDITOR=helix
      '';
    };

    # Ghostty terminal configuration
    home.file.".config/ghostty/config" = {
     force = true;
     text = ''
      # Theme
      theme = Gruvbox Material Dark
      background-opacity = 0.95
      background-blur = true

      # Font
      font-family = JetBrainsMono Nerd Font Mono
      font-size = 11
      # Window
      window-padding-x = 10
      window-padding-y = 10
      window-decoration = false
      # Cursor
      cursor-style = block
      cursor-style-blink = true
     '';
    };

    # Nushell configuration
    programs.nushell = {
      enable = true;
      shellAliases = {
        ll = "ls -lh";
        la = "ls -lah";
        ".." = "cd ..";
        "..." = "cd ../..";
      };
    };

    # Tmux configuration with custom gruvbox statusline
    programs.tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 100000;
      keyMode = "vi";
      customPaneNavigationAndResize = true;

      plugins = with pkgs.tmuxPlugins; [
        resurrect
        continuum
      ];
      
      extraConfig = ''
        # Gruvbox color scheme for tmux statusline
        set -g status-bg '#3c3836'
        set -g status-fg '#ebdbb2'
        set -g status-left ""
        set -g status-right ""
        set -g status-justify centre
        set -g pane-border-style 'fg=#3c3836'
        set -g pane-active-border-style 'fg=#8ec07c'
        set -g window-status-current-style 'fg=#ebdbb2,bg=#8ec07c'
        set -g window-status-style 'fg=#a89984,bg=default'
        set -g message-style 'fg=#ebdbb2,bg=#32302f'
        set -g mode-style 'fg=#ebdbb2,bg=#458588'
        set -g display-panes-active-colour '#8ec07c'
        set -g display-panes-colour '#3c3836'
        
        # Basic tmux settings
        set -g mouse on
        set -g base-index 1
        set -g pane-base-index 1
        set -g renumber-windows on
        set -g set-clipboard on
        
        # Vi key bindings
        setw -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        
        # Smart pane switching with awareness of Vim splits
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        
        # Pane resizing
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5
        
        # Window management
        bind c new-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"

        # Alt-based key bindings (no prefix)
        bind-key -n M-r source-file ~/.tmux.conf \; display-message "Tmux config reloaded"
        bind-key -n M-s choose-tree -Zw
        bind-key -n M-1 select-window -t 1
        bind-key -n M-2 select-window -t 2
        bind-key -n M-3 select-window -t 3
        bind-key -n M-4 select-window -t 4
        bind-key -n M-5 select-window -t 5
        bind-key -n M-6 select-window -t 6
        bind-key -n M-7 select-window -t 7
        bind-key -n M-8 select-window -t 8
        bind-key -n M-9 select-window -t 9

        # Pane selection with Alt + arrows
        bind-key -n M-Left select-pane -L
        bind-key -n M-Down select-pane -D
        bind-key -n M-Up select-pane -U
        bind-key -n M-Right select-pane -R

        # Pane resize with Alt + Shift + arrows
        bind-key -n M-S-Left resize-pane -L 5
        bind-key -n M-S-Down resize-pane -D 5
        bind-key -n M-S-Up resize-pane -U 5
        bind-key -n M-S-Right resize-pane -R 5

        # Splits and windows
        bind-key -n M-h split-window -v -c "#{pane_current_path}"
        bind-key -n M-v split-window -h -c "#{pane_current_path}"
        bind-key -n M-Enter new-window -c "#{pane_current_path}"

        # Kill and detach
        bind-key -n M-c kill-pane
        bind-key -n M-q kill-window
        bind-key -n M-d detach-client
        bind-key -n M-Q kill-session

        # Search in copy mode
        bind-key -T copy-mode-vi M-/ send-keys -X search-forward
        bind-key -T copy-mode-vi M-? send-keys -X search-backward

        # Tmux continuum options
        set -g @continuum-restore 'on'
        set -g @continuum-save-interval '15'
      '';
    };
  
   # Sway configuration file
  home.file.".config/sway/config".text = ''
    # Sway configuration
    # Modifier key (Mod4 = Win key)
    set $mod Mod4

    # Terminal
    set $term ghostty

    # Application launcher
    set $menu wofi --show drun


    # Startup applications
    # Import environment first
    exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP PATH
    exec hash dbus-update-activation-environment 2>/dev/null && \
         dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP PATH
    
    # Start applications
    exec mako
    exec blueman-applet  
    exec nm-applet
    exec sleep 2 && vicinae server
    exec waybar


    exec_always {
      systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
      dbus-update-activation-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
    }


    # Keybindings
    # Terminal
    bindsym $mod+Return exec $term

    # Application launcher
    bindsym $mod+d exec $menu

    # Vicinae
    bindsym $mod+c exec vicinae open

    # Window management
    bindsym $mod+q kill
    bindsym $mod+Shift+c reload
    bindsym $mod+Shift+e exec swaynag -t warning -m 'SOSAL?' -B 'Yes' 'swaymsg exit'

    # Focus
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # Move windows
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right

    # Workspaces
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10

    # Move to workspace
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10

    # Layout
    bindsym $mod+b splith
    bindsym $mod+v splitv
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split
    bindsym $mod+f fullscreen toggle
    bindsym $mod+Shift+space floating toggle
    bindsym $mod+space focus mode_toggle

    # Scratchpad
    bindsym $mod+Shift+minus move scratchpad
    bindsym $mod+minus scratchpad show

    # Screenshots
    bindsym Print exec grim -g "$(slurp)" - | wl-copy
    bindsym $mod+Print exec grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

    # Audio control
    bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindsym XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    # Brightness control
    bindsym XF86MonBrightnessUp exec brightnessctl set +5%
    bindsym XF86MonBrightnessDown exec brightnessctl set 5%-

    # Lock screen
    bindsym $mod+Shift+x exec swaylock -f -c 000000

     # Floating modifier (drag with mod+left mouse, resize with mod+right mouse)
    floating_modifier $mod normal

    # Resize mode
    mode "resize" {
      bindsym h resize shrink width 10px
      bindsym j resize grow height 10px
      bindsym k resize shrink height 10px
      bindsym l resize grow width 10px

      bindsym Left resize shrink width 10px
      bindsym Down resize grow height 10px
      bindsym Up resize shrink height 10px
      bindsym Right resize grow width 10px

      bindsym Return mode "default"
      bindsym Escape mode "default"
    }
    bindsym $mod+r mode "resize"



    # Window appearance
    default_border pixel 2
    default_floating_border pixel 2
    titlebar_padding 1
    titlebar_border_thickness 0

    # Gaps
    gaps inner 6
    gaps outer 3

    # Colors
    client.focused          #3c3836 #8ec07c #ebdbb2 #8ec07c   #8ec07c
    client.focused_inactive #a89984 #3c3836 #a89984 #3c3836   #3c3836
    client.unfocused        #a89984 #3c3836 #a89984 #3c3836   #3c3836
    client.urgent           #fb4934 #3c3836 #fb4934 #3c3836   #3c3836
    client.placeholder      #ebdbb2 #3c3836 #ebdbb2 #3c3836   #3c3836

    # Input configuration
    input "*" {
      xkb_layout "us,ru"
      #xkb_options "grp:caps_toggle"
      xkb_options "grp:caps_toggle,shift:both_capslock"
    }

    # Output configuration
    #output "*" bg #1e1e2e solid_color
    output * bg /etc/nixos/cosmic.png fill

    #wl-gammarelay-applet
    for_window [app_id="wl-gammarelay-applet"] sticky enable, move position cursor, move up 20
  '';

  # Yazi configuration
  home.file.".config/yazi/yazi.toml".text = ''
    [opener]
    doc = [
      { run = 'zathura "$@"', orphan = true, desc = 'View document' },
    ]
    img = [
      { run = 'nsxiv "$@"',   orphan = true, desc = 'View images' },
    ]
    edit = [
      { run = 'nvim "$@"', block = true, desc = 'Edit in Neovim' },
    ]

    [open]
    rules = [
      # Code / text files -> nvim
      { name = "*.nix", use = "edit" },
      { name = "*.rs",  use = "edit" },
      { name = "*.py",  use = "edit" },
      { name = "*.ts",  use = "edit" },
      { name = "*.tsx", use = "edit" },
      { name = "*.js",  use = "edit" },
      { name = "*.jsx", use = "edit" },
      { name = "*.lua", use = "edit" },
      { name = "*.md",  use = "edit" },
      { name = "*.txt", use = "edit" },

      # Documents / images -> zathura / nsxiv
      { mime = "application/pdf", use = "doc" },
      { name = "*.epub",           use = "doc" },
      { name = "*.djvu",           use = "doc" },
      { mime = "image/*",          use = "img" },
    ]
  '';

  #Waybar configuration using programs.waybar
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        reload_style_on_change = true;
        modules-left = ["custom/notification" "tray" "sway/language"];
        modules-center = ["sway/workspaces"];
        modules-right = ["group/expand" "clock" "network" "pulseaudio" "battery"];

        "sway/workspaces" = {
          format = "{name}";
          format-icons = {
            active = "󰮯";
            default = "󰊠";
            urgent = "󰮯";
            empty = "󰊠";
          };
          persistent_workspaces = {
            "*" = [ 1 2 3 4 5 ];
          };
        };
        
        "custom/notification" = {
          tooltip = false;
          format = "";
          on-click = "swaync-client -t -sw";
          escape = true;
        };
        
        clock = {
          format = "{:%I:%M:%S %p} ";
          interval = 1;
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            format = {
              today = "<span color='#fAfBfC'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "shift_down";
            on-click = "shift_up";
          };
        };

        "sway/language" = {
          format = "{short}";
          tooltip = false;
        };
        
        network = {
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "";
          tooltip-format-disconnected = "Error";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} ";
          on-click = "kitty nmtui";
        };


        pulseaudio = {
          format = "{volume}%";
          format-muted = "";
          on-click = "pavucontrol";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
          tooltip = false;
        };


        
        bluetooth = {
          format-on = "";
          format-off = "BT-off";
          format-disabled = "";
          format-connected-battery = "{device_battery_percentage}% ";
          format-alt = "{device_alias} ";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\n{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\n{device_address}\n{device_battery_percentage}%";
          on-click-right = "blueman-manager";
        };
        
        battery = {
          interval = 30;
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        
        "custom/expand" = {
          format = "";
          tooltip = false;
        };
        
        "custom/endpoint" = {
          format = "|";
          tooltip = false;
        };
        
        "group/expand" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 600;
            transition-to-left = true;
            click-to-reveal = true;
          };
          modules = ["custom/expand" "cpu" "memory" "temperature" "custom/endpoint"];
        };
        
        cpu = {
          format = "";
          tooltip = true;
        };
        
        memory = {
          format = "";
        };
        
        temperature = {
          critical-threshold = 80;
          format = "";
        };
        
        tray = {
          icon-size = 14;
          spacing = 10;
        };
      };
    };

    style = ''
      /*@import url('https://fonts.googleapis.com/css2?family=CodeNewRoman&display=swap');*/

      * {
        font-size: 8px;
        font-family: "CodeNewRoman Nerd Font Propo", monospace;
      }
      
      window#waybar {
        all: unset;
      }
      
      .modules-left {
        padding: 1px 3px;
        margin: 1px 0px 1px 2px;
        border-radius: 3px;
        background: rgba(40, 40, 40, 0.8);
        box-shadow: 0px 0px 1px rgba(0, 0, 0, 0.5);
      }
      
      .modules-center {
        padding: 1px 3px;
        margin: 1px 0px 1px 0px;
        border-radius: 3px;
        background: rgba(40, 40, 40, 0.8);
        box-shadow: 0px 0px 1px rgba(0, 0, 0, 0.5);
      }
      
      .modules-right {
        padding: 1px 3px;
        margin: 1px 2px 1px 0px;
        border-radius: 3px;
        background: rgba(40, 40, 40, 0.8);
        box-shadow: 0px 0px 1px rgba(0, 0, 0, 0.5);
      }
      
      tooltip {
        background: #282828;
        color: #ebdbb2;
        border: 1px solid #665c54;
      }

      #clock:hover, #custom-notification:hover, #bluetooth:hover, #network:hover, #pulseaudio:hover, #battery:hover, #cpu:hover, #memory:hover, #temperature:hover { 
        transition: all 0.3s ease;
        color: #fabd2f;
      }
      
      #custom-notification {
        padding: 0px 3px;
        transition: all 0.3s ease;
        color: #ebdbb2;
      }
      
      #clock {
        padding: 0px 3px;
        color: #ebdbb2;
        transition: all 0.3s ease;
      }
      
      #workspaces {
        padding: 0px 3px;
      }
      
      #workspaces button {
        all: unset;
        padding: 2px 6px;
        margin: 0px 2px;
        color: rgba(251, 241, 199, 0.6);
        background: rgba(40, 40, 40, 0.3);
        border-radius: 3px;
        transition: all 0.2s ease;
      }
      
      #workspaces button:hover {
        color: #ebdbb2;
        background: rgba(40, 40, 40, 0.6);
        transition: all 0.2s ease;
      }
            
      #workspaces button.active,
      #workspaces button.focused {
        color: #8ec07c;
        background: transparent;
        font-weight: bold;
      }
      
      #workspaces button.empty {
        color: rgba(251, 241, 199, 0.3);
        background: rgba(40, 40, 40, 0.2);
      }
      
      #workspaces button.empty:hover {
        color: rgba(251, 241, 199, 0.5);
        background: rgba(40, 40, 40, 0.4);
        transition: all 0.2s ease;
      }
      
      #workspaces button.empty.active,
      #workspaces button.empty.focused {
        color: #8ec07c;
        background: transparent;
        font-weight: bold;
      } 
      
      #bluetooth {
        padding: 0px 3px;
        transition: all 0.3s ease;
        color: #ebdbb2;
      }

       
      #network {
        padding: 0px 3px;
        transition: all 0.3s ease;
        color: #ebdbb2;
      }


      #pulseaudio {
        padding: 0px 3px;
        transition: all 0.3s ease;
        color: #ebdbb2;
      }
      
      
      #battery {
        padding: 0px 3px;
        transition: all 0.3s ease;
        color: #ebdbb2;
      }
      
      #battery.charging {
        color: #b8bb26;
      }
      
      #battery.warning:not(.charging) {
        color: #fabd2f;
      }
      
      #battery.critical:not(.charging) {
        color: #fb4934;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      
      #group-expand {
        padding: 0px 3px;
        transition: all 0.3s ease;
      }
      
      #custom-expand {
        padding: 0px 3px;
        color: rgba(235, 219, 178, 0.3);
        text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.7);
        transition: all 0.3s ease;
      }
      
      #custom-expand:hover {
        color: rgba(255, 255, 255, 0.2);
        text-shadow: 0px 0px 2px rgba(255, 255, 255, 0.5);
      }
      
      #cpu, #memory, #temperature {
        padding: 0px 3px;
        transition: all 0.3s ease;
        color: #ebdbb2;
      }
      
      #custom-endpoint {
        color: transparent;
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 1);
      }
      
      #tray {
        padding: 0px 3px;
        transition: all 0.3s ease;
      }
      
      #tray menu * {
        padding: 0px 3px;
        transition: all 0.3s ease;
      }
      
      #tray menu separator {
        padding: 0px 3px;
        transition: all 0.3s ease;
      }
      
      @keyframes blink {
        50% {
          opacity: 0.5;
        }
      }
    '';
 };
}
