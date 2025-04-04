#ln -s ~/Insync/pierrez1984@gmail.com/Dropbox/mac_config/home-manager ~/.config
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in {
  home.username = "py";
  home.homeDirectory = "/Users/py";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.hack

    #yabai
    texliveFull
    sagetex
    tldr
    #powertop
    htop
    nvd
    du-dust
    fd
    ripgrep
    bat
    neofetch
    #eza
    lsof
    eza
    #bandwhich
    delta
    #maple-mono
    glances
    bottom
    aria
    thefuck
    rclone
    #syncthing
    nil
    nixfmt-rfc-style
    pyright
    ruff
    ruff-lsp
    luajitPackages.luacheck
    lua-language-server
    marksman
    tree-sitter
    tree-sitter-grammars.tree-sitter-python
    texlab
    rectangle
    deluge
    ffsubsync
    zoom-us
    yt-dlp
    #rustdesk
    #pdfarranger


    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (python313.withPackages (p:
      with p; [
        pip
        numpy
        sympy
        jupyter
        requests
        pandas
        matplotlib
        pytz
        tenacity
        timeout-decorator
        ipdb
        ipython
        #pysnooper
        debugpy
        python-lsp-server
        pynvim
        send2trash
        openpyxl
        setuptools
      ]))
  ];
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/mpv".source = dotfiles/mpv;
    #".config/wezterm/wezterm.lua".source = dotfiles/wezterm.lua;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/py/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  #services.mpris-proxy.enable = true;
  programs.mpv = {
    # mkdir /var/log/mpv && sudo chmod -R u=rwx,g=rwx,o=rwx /var/log/mpv    ### for recent.lua history.log
    enable = true;
    package = (
      pkgs.mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [
          #uosc
          #mpris
          sponsorblock
          thumbfast
        ];
        mpv = pkgs.mpv-unwrapped.override {
          #waylandSupport = true;
          ffmpeg = pkgs.ffmpeg-full;
        };
      }
    );
  };

  programs.lf = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
      hidden = true;
      icons = false;
    };
    keybindings = {
      gh = "cd ~";
      gd = "cd ~/Downloads";
      gc = "cd ~/.config";
      gn = "cd /etc/nixos/";
      DD = "trash";
      md = "mkdir";
      i = "$less $f";
      oo = "extractcode";
      sp = "usage";
      Q = "quit-and-cd";
    };
    extraConfig = ''
      #!/bin/sh
      #https://github.com/gokcehan/lf/wiki/Tips
      cmd trash $IFS="$(printf '\n\t')"; trash $fx
      cmd extractcode $IFS="$(printf '\n\t')"; extractcode $fx
      cmd usage $du -h -d1 | less
      cmd quit-and-cd &{{
        pwd > $LF_CD_FILE
        lf -remote "send $id quit"
      }}
      #cmd open &{{
        #case $(file --mime-type -Lb $f) in
          #text/*) lf -remote "send $id \$$EDITOR \$fx";;
          #*) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
        #esac
      #}}
    '';
  };

  programs.git = {
    enable = true;
    userEmail = "pierrez1984@gmail.com";
    userName = "zh-py";
    #includes = [{ path = "~/.config/home-manager/dotfiles/.gitconfig"; }];
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "delta --dark";
        whitespace = "trailing-space,space-before-tab";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };

  programs.fzf = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      bl = "sudo python3 ~/Downloads/osx_battery_charge_limit/main.py -s 42";
      bh = "sudo python3 ~/Downloads/osx_battery_charge_limit/main.py -s 77";
      y7 = "(){ yt-dlp -f 137+140 --no-mtime $1. ;}";
      y6 = "(){ yt-dlp -f 136+140 --no-mtime $1. ;}";
      y67 = "(){ yt-dlp -f '137+140/136+140' --no-mtime $1. ;}";
      yfm = "(){ yt-dlp --list-formats $1. ;}";
      yf = "(){ yt-dlp --write-auto-sub --write-sub --sub-lang en --convert-subtitles srt -f '137+140/136+140/135+140/134+140/137+140-8/137+140-7/137+140-6/137+140-5/137+140-4/137+140-3/137+140-2/137+140-1/136+140-8/136+140-7/136+140-6/136+140-5/136+140-4/136+140-3/136+140-2/136+140-1' --no-mtime $1. ;}";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./dotfiles/p10k-config;
        file = ".p10k.zsh";
      }
    ];
    initExtra = builtins.readFile ./dotfiles/.zshrc;
    #envExtra= builtins.readFile ./dotfiles/.zshenv;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "thefuck"
        "z"
        "command-not-found"
        "poetry"
        "sudo"
        "terraform"
        "systemadmin"
      ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    withPython3 = true;
    extraConfig = ''
      colorscheme gruvbox
      filetype plugin indent on
      syntax enable
      set mouse=a
      set number
      set wrap
      set linebreak
      set clipboard=unnamed
      set nu rnu
      let &scrolloff = 5
      nn <F7> :setlocal spell! spell?<CR>
      nn <A-s> :setlocal spell! spell?<CR>
      autocmd Filetype lua setlocal tabstop=4
      autocmd Filetype lua setlocal shiftwidth=4
      cnoremap <C-a> <Home>
      cnoremap <C-e> <End>
      cnoremap <C-p> <Up>
      cnoremap <C-n> <Down>
      cnoremap <C-b> <Left>
      cnoremap <C-f> <Right>
      cnoremap <C-d> <Del>
      cnoreabbrev <expr> tn getcmdtype() == ":" && getcmdline() == 'tn' ? 'tabnew' : 'tn'
      cnoreabbrev <expr> th getcmdtype() == ":" && getcmdline() == 'th' ? 'tabp' : 'th'
      cnoreabbrev <expr> tl getcmdtype() == ":" && getcmdline() == 'tl' ? 'tabn' : 'tl'
      cnoreabbrev <expr> te getcmdtype() == ":" && getcmdline() == 'te' ? 'tabedit' : 'te'
      lua vim.opt.signcolumn = "yes"
      lua vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]])
      lua vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]])
      lua vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]])
      lua vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]])
      autocmd Filetype python map <silent> <A-r> :w<CR>:terminal python3 % -m pdb<CR>:startinsert<CR>
      autocmd Filetype python map! <silent> <A-r> <ESC> :w<CR>:terminal python3 % -m pdb<CR>:startinsert<CR>
      autocmd Filetype python map <silent> <F5> :w<CR>:terminal python3 % -m pdb<CR>:startinsert<CR>
      autocmd Filetype python map! <silent> <F5> <ESC> :w<CR>:terminal python3 % -m pdb<CR>:startinsert<CR>
      autocmd FileType python map <silent> <leader>b oimport ipdb; ipdb.set_trace()<esc>
      autocmd FileType python map <silent> <leader>B obreakpoint()<esc>
      autocmd Filetype tex,latex map <A-r> :w <Enter> <localleader>lk<localleader>ll
      autocmd Filetype tex,latex map! <A-r> <ESC> :w <Enter> <localleader>lk<localleader>ll
      autocmd Filetype tex,latex map <F5> :w <Enter> <localleader>lk<localleader>ll
      autocmd Filetype tex,latex map! <F5> <ESC> :w <Enter> <localleader>lk<localleader>ll
      autocmd Filetype tex,latex map <A-e> <localleader>le
      autocmd Filetype tex,latex map! <A-e> <ESC> <localleader>le
      autocmd Filetype tex,latex map <F4> <localleader>le
      autocmd Filetype tex,latex map! <F4> <ESC> <localleader>le
      autocmd Filetype tex,latex set shiftwidth=4
      autocmd Filetype markdown map <silent> <A-r> :w<CR>:MarkdownPreview<CR>
      autocmd Filetype markdown map! <silent> <A-r> <ESC> :w<CR>:MarkdownPreview<CR>
      autocmd Filetype markdown map <silent> <F5> :w<CR>:MarkdownPreview<CR>
      autocmd Filetype markdown map! <silent> <F5> <ESC> :w<CR>:MarkdownPreview<CR>
      map [b :bprevious<CR>
      map ]b :bnext<CR>
      map qb :Bdelete<CR>
      lua vim.keymap.set("n", "H", [[<cmd>bprevious<cr>]])
      lua vim.keymap.set("n", "L", [[<cmd>bnext<cr>]])
      if has("autocmd")
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
      endif
      autocmd FileType css setlocal tabstop=2 shiftwidth=2
      autocmd FileType haskell setlocal tabstop=2 shiftwidth=2
      autocmd FileType nix setlocal tabstop=2 shiftwidth=2
      autocmd FileType json setlocal tabstop=2 shiftwidth=2
      autocmd FileType cpp setlocal tabstop=2 shiftwidth=2
      autocmd FileType c setlocal tabstop=2 shiftwidth=2
      autocmd FileType java setlocal tabstop=4 shiftwidth=4
      autocmd FileType markdown setlocal spell
      autocmd FileType markdown setlocal tabstop=2 shiftwidth=2
      au BufRead,BufNewFile *.wiki setlocal textwidth=80 spell tabstop=2 shiftwidth=2
      autocmd FileType xml setlocal tabstop=2 shiftwidth=2
      autocmd FileType help wincmd L
      autocmd FileType gitcommit setlocal spell
    '';
      #let g:airline#extensions#tabline#enabled = 1
      #let g:airline#extensions#tabline#switch_buffers_and_tabs = 0
      #if !exists('g:airline_symbols')
        #let g:airline_symbols = {}
      #endif
      #let g:airline_left_sep = ''
      #let g:airline_left_alt_sep = ''
      #let g:airline_right_sep = ''
      #let g:airline_right_alt_sep = ''
      #let g:airline_symbols.branch = ''
      #let g:airline_symbols.colnr = ' ℅:'
      #let g:airline_symbols.readonly = ''
      #let g:airline_symbols.linenr = ' :'
      #let g:airline_symbols.maxlinenr = '☰ '
      #let g:airline_symbols.dirty='⚡'
    plugins = with pkgs.vimPlugins; [
      vim-visual-multi
      gruvbox
      trouble-nvim
      vim-nix
      nerdcommenter
      markdown-preview-nvim
      vim-bbye
      #{
        #plugin = zk-nvim;
        #type = "lua";
        #config = ''
          #require("zk").setup({
            #-- can be "telescope", "fzf", "fzf_lua" or "select" (`vim.ui.select`)
            #-- it's recommended to use "telescope", "fzf" or "fzf_lua"
            #picker = "telescope",
            #lsp = {
              #-- `config` is passed to `vim.lsp.start_client(config)`
              #config = {
                #cmd = { "zk", "lsp" },
                #name = "zk",
                #-- on_attach = ...
                #-- etc, see `:h vim.lsp.start_client()`
              #},
              #-- automatically attach buffers in a zk notebook that match the given filetypes
              #auto_attach = {
                #enabled = true,
                #filetypes = { "markdown" },
              #},
            #},
          #})
        #'';
      #}
      #vim-airline
      #vim-airline-themes
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            highlight = {
              enable = true,
              --disable = { "latex" },
            },
            indent = { enable = true},
          })
        '';
      }
      #nui-nvim
      #nvim-notify
      #{
        #plugin = noice-nvim;
        #type = "lua";
        #config = builtins.readFile(./neovim/noice.lua);
      #}
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require("nvim-web-devicons").setup()
        '';
      }
      {
        plugin = fzf-lua;
        type = "lua";
        config = ''
          -- require("fzf-lua").setup({})
          -- require('fzf-lua').setup({'fzf-native'})
          -- vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
          -- require"fzf-lua".setup({"telescope",winopts={preview={default="bat"}}})
          require('fzf-lua').setup({'fzf-vim'})
        '';
      }
      #{
        #plugin = nvim-tree-lua;
        #type = "lua";
        #config = builtins.readFile(./neovim/nvimtree.lua);
      #}
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile(./neovim/lualine.lua);
      }
      #{
        #plugin = bufferline-nvim;
        #type = "lua";
        #config = ''
          #vim.opt.termguicolors = true
          #require("bufferline").setup{}
        #'';
      #}
      {
        plugin = vimtex;
        config = /* vim */ ''
          let g:vimtex_view_method='skim'
          let g:vimtex_view_skim_activate=0
          let g:vimtex_view_skim_reading_bar=1
          let g:vimtex_syntax_enabled=0
        '';
      }
      markdown-preview-nvim
      {
        plugin = vim-markdown;
        config = /* vim */ ''
          let g:vim_markdown_folding_disabled = 1
          let g:vim_markdown_conceal = 0
          let g:vim_markdown_frontmatter = 1
          let g:vim_markdown_toml_frontmatter = 1
          let g:vim_markdown_json_frontmatter = 1
        '';
      }
      {
        plugin = nvim-lastplace;
        type = "lua";
        config = ''
          require('nvim-lastplace').setup()
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile(./neovim/lspconfig.lua);
      }
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lua
      cmp-vsnip
      vim-vsnip
      #friendly-snippets
      cmp-nvim-lsp
      lspkind-nvim
      {
        plugin = nvim-surround;
        type = "lua";
        config = ''
          require("nvim-surround").setup()
        '';
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile(./neovim/completion.lua);
      }
      plenary-nvim
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          require('mini.trailspace').setup()
        '';
      }
      {
        plugin = harpoon2;
        type = "lua";
        config = builtins.readFile(./neovim/harpoon.lua);
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile(./neovim/telescope.lua);
      }
      telescope-file-browser-nvim
      #telescope-ui-select-nvim
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require('ibl').setup({
            indent = {
              char = "┊",
            },
            scope = {
              enabled = true,
              show_start = true,
              show_end = true,
            },
          })
        '';
      }
      {
        plugin = treesj;
        type = "lua";
        config = ''
          require('treesj').setup{
            lang = {
                lua = require('treesj.langs.lua'),
                typescript = require('treesj.langs.typescript'),
                python = require('treesj.langs.python'),
              },
            use_default_keymaps = true,
            check_syntax_error = true,
            max_join_length = 120,
            cursor_behavior = 'hold',
            notify = true,
            dot_repeat = true,
            on_error = nil,
            }
        '';
      }
      nvim-dap
      {
        plugin = nvim-dap-python;
        type = "lua";
        config = builtins.readFile(./neovim/debuggerpy.lua);
      }
      telescope-dap-nvim
      nvim-dap-ui
      neodev-nvim
      nvim-dap-virtual-text
    ];
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 16;
    themeFile= "SpaceGray_Eighties";
    extraConfig = ''
      hide_window_decorations yes #macos
      shell_integration enabled
      shell zsh
      editor .
      tab_bar_edge top
      tab_bar_style powerline
      tab_switch_strategy right
      #tab_title_template " {index}: {f'{title[:6]}…{title[-6:]}' if title.rindex(title[-1]) + 1 > 13 else title.center(7)}"
      #tab_title_template "{index}: {title[title.rfind('/')+1:]}"
      tab_title_template " {index}: {f'…{title[-14:]}' if title.rindex(title[-1]) + 1 > 15 else title.center(10)}"
      active_tab_font_style bold
      tab_bar_margin_width 6
      tab_powerline_style round
      tab_separator " ┇"
      macos_option_as_alt no #macos
      map cmd+1 goto_tab 1
      map cmd+2 goto_tab 2
      map cmd+3 goto_tab 3
      map cmd+4 goto_tab 4
      map cmd+5 goto_tab 5
      map cmd+6 goto_tab 6
      map cmd+7 goto_tab 7
      map cmd+8 goto_tab 8
      map cmd+9 goto_tab 9
      map cmd+t launch --cwd=current --type=tab
      confirm_os_window_close 0
      #map ctrl+shift+t new_tab_with_cwd
      #map cmd+shift+h previous_tab
      #map cmd+shift+l next_tab
      ##map cmd+c copy_to_clipboard
      #map ctrl+insert copy_and_clear_or_interrupt
      ##map cmd+v paste_from_clipboard
      #map shift+insert paste_from_clipboard
    #'';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };
      window = {
        #padding.x = 10;
        #padding.y = 10;
        dynamic_padding = true;
        opacity = 0.96;
        decorations = "buttonless";
        startup_mode = "Maximized";
      };
      font = {
        size = 16.0;
        #normal.family = "Jetbrains Mono";
        #bold.family = "Jetbrains Mono";
        #italic.family = "Jetbrains Mono";
        normal.family = "Hack Nerd Font Mono";
        bold.family = "Hack Nerd Font Mono";
        italic.family = "Hack Nerd Font Mono";
      };
      cursor = {
        style.shape = "Beam";
        style.blinking = "On";
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      shell = {
        program = "zsh";
        args = [
          "-l"
        ];
      };
      #terminal = {
        #shell = {
          #program = "zsh";
          #args = [
            #"-l"
          #];
        #};
      #};
      colors = {
        primary = {
          background = "0x1b182c";
          foreground = "0xcbe3e7";
        };
        normal = {
          black = "0x100e23";
          red = "0xff8080";
          green = "0x95ffa4";
          yellow = "0xffe9aa";
          blue = "0x91ddff";
          magenta = "0xc991e1";
          cyan = "0xaaffe4";
          white = "0xcbe3e7";
        };
        bright = {
          black = "0x565575";
          red = "0xff5458";
          green = "0x62d196";
          yellow = "0xffb378";
          blue = "0x65b2ff";
          magenta = "0x906cff";
          cyan = "0x63f2f1";
          white = "0xa6b3cc";
        };
      };
    };
  };

  #home.activation = mkIf pkgs.stdenv.isDarwin {
  #copyApplications = let
  #apps = pkgs.buildEnv {
  #name = "home-manager-applications";
  #paths = config.home.packages;
  #pathsToLink = "/Applications";
  #};
  #in
  #lib.hm.dag.entryAfter ["writeBoundary"] ''
  #baseDir="$HOME/Applications/Home Manager Apps"
  #if [ -d "$baseDir" ]; then
  #rm -rf "$baseDir"
  #fi
  #mkdir -p "$baseDir"
  #for appFile in ${apps}/Applications/*; do
  #target="$baseDir/$(basename "$appFile")"
  #$DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
  #$DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
  #done
  #'';
  #};
}
