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
      }) // (let
        welcomeText = ''
          Usage:

          $ nix develop

          or, if you have direnv installed:

          $ direnv allow

          See https://github.com/arti5an/flake-templates for more information.
        '';
        dotnetTemplate = {
          inherit welcomeText;
          path = ./dotnet;
          description = "A standard .NET project";
        };
        javascriptTemplate = {
          inherit welcomeText;
          path = ./javascript;
          description = "A JavaScript project";
        };
      in {
        templates = {
          csharp = dotnetTemplate;
          dotnet = dotnetTemplate;
          javascript = javascriptTemplate;
          js = javascriptTemplate;
          node = javascriptTemplate;
        };
      });
}
