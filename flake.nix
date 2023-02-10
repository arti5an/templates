{
  description = "Nix Flake Templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = with pkgs;
          mkShell { buildInputs = [ nixfmt nodePackages.prettier ]; };
      }) // {
        templates.dotnet = {
          path = ./dotnet;
          description = "A standard .NET project";
          welcomeText = ''
            Usage:

            $ nix develop

            or, if you have direnv installed:

            $ direnv allow

            See https://github.com/arti5an/flake-templates for more information.
          '';
        };
      };
}
