{
    description = "Neovim derivation";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

        # Add bleeding-edge plugins here.
        # They can be updated with `nix flake update` (make sure to commit the generated flake.lock)
        # wf-nvim = {
        #   url = "github:Cassin01/wf.nvim";
        #   flake = false;
        # };
        "deadcolumn" = {
            url = "github:Bekaboo/deadcolumn.nvim";
            flake = false;
        };
        "stickybuf" = {
            url = "github:stevearc/stickybuf.nvim";
            flake = false;
        };
        "jupytext" = {
            url = "github:goerz/jupytext.vim";
            flake = false;
        };
        "poetry" = {
            url = "github:karloskar/poetry-nvim";
            flake = false;
        };
        "everforest-nvim" = {
            url = "github:neanias/everforest-nvim";
            flake = false;
        };
        "cuddlefish-nvim" = {
            url = "github:comfysage/cuddlefish.nvim";
            flake = false;
        };
        "evergarden" = {
            url = "github:everviolet/nvim";
            flake = false;
        };
        "jellybeans-nvim" = {
            url = "github:WTFox/jellybeans.nvim";
            flake = false;
        };
        "newpaper-nvim" = {
            url = "github:yorik1984/newpaper.nvim";
            flake = false;
        };
        "darkrose-nvim" = {
            url = "github:water-sucks/darkrose.nvim";
            flake = false;
        };
        "nordern-nvim" = {
            url = "github:fcancelinha/nordern.nvim";
            flake = false;
        };
        "luarocks-nvim" = {
            url = "github:vhyrro/luarocks.nvim";
            flake = false;
        };
        "vague-nvim" = {
            url = "github:vague2k/vague.nvim";
            flake = false;
        };

    };

    outputs =
        inputs@{
            self,
            nixpkgs,
            flake-utils,
            ...
        }:
        let
            systems = builtins.attrNames nixpkgs.legacyPackages;

            # This is where the Neovim derivation is built.
            neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };
        in
        flake-utils.lib.eachSystem systems (
            system:
            let
                pkgs = import nixpkgs {
                    inherit system;
                    overlays = [
                        # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
                        neovim-overlay
                        # This adds a function can be used to generate a .luarc.json
                        # containing the Neovim API all plugins in the workspace directory.
                        # The generated file can be symlinked in the devShell's shellHook.
                        inputs.gen-luarc.overlays.default
                    ];
                };
                shell = pkgs.mkShell {
                    name = "nvim-devShell";
                    buildInputs = with pkgs; [
                        # Tools for Lua and Nix development, useful for editing files in this repo
                        lua-language-server
                        nil
                        stylua
                        luajitPackages.luacheck
                        nvim-dev
                    ];
                    shellHook = ''
                        # symlink the .luarc.json generated in the overlay
                        ln -fs ${pkgs.nvim-luarc-json} .luarc.json
                        # allow quick iteration of lua configs
                        ln -Tfns $PWD/nvim ~/.config/nvim-dev
                    '';
                };
            in
            {
                packages = rec {
                    default = nvim;
                    nvim = pkgs.nvim-pkg;
                };
                devShells = {
                    default = shell;
                };
            }
        )
        // {
            # You can add this overlay to your NixOS configuration
            overlays.default = neovim-overlay;
        };
}
