{
  description = "Hugo Site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      buildInputs = [pkgs.hugo pkgs.nodePackages.prettier];
    in {
      devShells.default = pkgs.mkShell {
        packages = buildInputs;

        shellHook = ''
          # Output some helpful info
          echo -e "\n\e[0;32m$(hugo version)\e[0m\n"
        '';
      };

      formatter = pkgs.alejandra;
    });
}
