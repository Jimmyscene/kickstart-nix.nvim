# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
    pkgs = final;

    # Use this to create a plugin from a flake input
    mkNvimPlugin =
        src: pname:
        pkgs.vimUtils.buildVimPlugin {
            inherit pname src;
            version = src.lastModifiedDate;
        };

    # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
    # otherwise it could have an incompatible signature when applying this overlay.
    pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

    # This is the helper function that builds the Neovim derivation.
    mkNeovim = pkgs.callPackage ./mkNeovim.nix {
        inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
    };

    # A plugin can either be a package or an attrset, such as
    # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
    #   config = <config>; # String; a config that will be loaded with the plugin
    #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
    #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
    #   optional = <true|false>; # Default: false
    #   ...
    # }
    all-plugins =
        let
            overridePlugin = import ./hashes.nix { inherit pkgs; };
        in
        with pkgs;
        with pkgs.vimPlugins;
        [
            aerial-nvim
            cmp-calc
            cmp-nvim-lsp
            nvim-dap
            nvim-lspconfig
            neodev-nvim
            cmp-path
            luasnip
            cmp_luasnip
            conform-nvim
            diffview-nvim
            fidget-nvim
            friendly-snippets
            gitsigns-nvim
            indent-blankline-nvim
            jupytext-nvim
            lualine-nvim
            lush-nvim
            mini-nvim
            mini-trailspace
            neo-tree-nvim
            neogit
            neorg
            neorg-telescope
            luajitPackages.tree-sitter-norg
            nvim-cmp
            (nvim-treesitter.withPlugins (
                prev:
                (builtins.filter (g: g.pname != "comment-grammar") nvim-treesitter.passthru.allGrammars)
                ++ [ pkgs.tree-sitter-grammars.tree-sitter-norg-meta ]
            ))

            (overridePlugin tiny-inline-diagnostic-nvim)
            nvim-treesitter-context
            remote-nvim-nvim
            (overridePlugin git-conflict-nvim)
            nvim-treesitter-textobjects
            nvim-ufo
            nvim-web-devicons
            marks-nvim
            oil-nvim
            plenary-nvim
            promise-async
            rainbow-delimiters-nvim
            scope-nvim
            lualine-lsp-progress
            render-markdown-nvim
            overseer-nvim
            smart-open-nvim
            tabby-nvim
            telescope-fzf-native-nvim
            telescope-fzy-native-nvim
            snacks-nvim
            telescope-nvim

            nvim-nio
            nui-nvim
            neorg
            telescope-ui-select-nvim
            telescope-undo-nvim
            todo-comments-nvim
            trouble-nvim
            toggleterm-nvim
            nvim-window-picker

            nvim-dap
            nvim-dap-ui
            nvim-nio

            ts-comments-nvim
            vim-eunuch
            vim-fetch
            vim-sleuth
            zen-mode-nvim

            #colorschemes
            bluloco-nvim
            catppuccin-nvim
            kanagawa-nvim
            embark-vim

            (mkNvimPlugin inputs.vague-nvim "vague.nvim")
            (mkNvimPlugin inputs.deadcolumn "deadcolumn")
            (mkNvimPlugin inputs.stickybuf "stickybuf")
            (mkNvimPlugin inputs.jupytext "jupytext")
            (mkNvimPlugin inputs.poetry "poetry")
            (mkNvimPlugin inputs.everforest-nvim "everforest-nvim")
            ((mkNvimPlugin inputs.cuddlefish-nvim "cuddlefish.nvim").overrideAttrs {
                nvimSkipModules = [ "cuddlefish.extras" ];
            })
            ((mkNvimPlugin inputs.evergarden "evergarden").overrideAttrs {
                nvimSkipModules = [
                    "evergarden.extras"
                    "minidoc"
                ];
            })

            (mkNvimPlugin inputs.jellybeans-nvim "jellybeans.nvim")
            (mkNvimPlugin inputs.newpaper-nvim "newpaper.nvim")
            (mkNvimPlugin inputs.darkrose-nvim "darkrose.nvim")
            (mkNvimPlugin inputs.nordern-nvim "nordern.nvim")
            (mkNvimPlugin inputs.luarocks-nvim "luarocks-nvim")
            (mkNvimPlugin inputs.vague-nvim "vague-nvim")
        ];

    extraPackages =
        with pkgs;
        with python312Packages;
        [
            bash-language-server
            black
            docker-compose-language-service
            dockerfile-language-server-nodejs
            flake8
            fzf
            gitlab-ci-ls
            gopls
            isort
            llvmPackages_19.clang-tools
            lua-language-server
            neocmakelsp
            cmake-format
            nixfmt-rfc-style
            nil
            nixpkgs-fmt
            nodePackages.bash-language-server
            nodePackages.vscode-json-languageserver
            nodePackages.yaml-language-server
            nodejs_24
            pyright
            ripgrep
            ruff
            cargo
            rustfmt
            rust-analyzer
            shellcheck
            shfmt
            sql-formatter
            stylua
            taplo
            terraform-ls
            uncrustify
            yamlfmt
            debugpy

            pkgs.nur.repos.Freed-Wu.termux-language-server
        ];
in
{
    # This is the neovim derivation
    # returned by the overlay
    nvim-pkg = mkNeovim {
        plugins = all-plugins;
        inherit extraPackages;
    };

    # This is meant to be used within a devshell.
    # Instead of loading the lua Neovim configuration from
    # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
    nvim-dev = mkNeovim {
        plugins = all-plugins;
        inherit extraPackages;
        appName = "nvim-dev";
        wrapRc = false;
    };

    # This can be symlinked in the devShell's shellHook
    nvim-luarc-json = final.mk-luarc-json {
        plugins = all-plugins;
    };

    # You can add as many derivations as you like.
    # Use `ignoreConfigRegexes` to filter out config
    # files you would not like to include.
    #
    # For example:
    #
    # nvim-pkg-no-telescope = mkNeovim {
    #   plugins = [];
    #   ignoreConfigRegexes = [
    #     "^plugin/telescope.lua"
    #     "^ftplugin/.*.lua"
    #   ];
    #   inherit extraPackages;
    # };
}
