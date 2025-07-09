{ pkgs }:
let
    _overrideRust = args: oldAttrs: rec {
        src = oldAttrs.src.override args.src;
        cargoDeps = oldAttrs.cargoDeps.overrideAttrs {
            inherit src;
            outputHash = if args.hash == "" then pkgs.lib.fakeHash else args.hash;
        };
    };
    override =
        args: oldAttrs:
        let
            mysrc =
                if builtins.hasAttr "override" oldAttrs.src then oldAttrs.src.override args.src else args.src;
        in
        {
            src = mysrc;
        };

    hashes = {
        "tiny-inline-diagnostic.nvim" = override {
            src = {
                rev = "d16e068d2200eb6cc9ac3df71e119f82d9ce6694";
                sha256 = "sha256-oYvR11Fu+EqmLK16NRL1zsGue5fO8oiJBGmdZNoi6dI=";
            };
        };
        "git-conflict.nvim" = override {
            src = {
                rev = "v2.0.0";
                sha256 = "sha256-5BeWy0KhFG+MtWti7SFyT1jN2so47oD7JYYzbZSzndM=";
            };
        };
    };
    fetchHash = name: pkgs.lib.attrByPath [ name ] (abort "HASH NOT FOUND") hashes;
in
pkg:
(pkg.overrideAttrs (
    oldAttrs:
    let
        name = oldAttrs.pname;
        hash = fetchHash name;
    in
    hash oldAttrs
))
