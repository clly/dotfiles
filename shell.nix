{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
}:

pkgs.mkShell {
    packages = with pkgs; [
        git
        bun
        helix
    ];
}
