{
  description = "nixpkgs-unstable extended with fenix for use in devenv";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.fenix.url = "github:nix-community/fenix";
  inputs.fenix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, fenix, flake-compat }: 
  let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in
  {
    inherit (nixpkgs) lib;
    legacyPackages = forAllSystems (system: builtins.import "${nixpkgs}/." {
      inherit system;
      overlays = [ (_: super: let pkgs = fenix.inputs.nixpkgs.legacyPackages.${super.system}; in fenix.overlays.default pkgs pkgs) ];
    });
  };
}
