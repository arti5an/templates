{
  description = "Nix Flake Templates";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
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
        hugoTemplate = {
          inherit welcomeText;
          path = ./hugo;
          description = "A Hugo website project";
        };
        javascriptTemplate = {
          inherit welcomeText;
          path = ./javascript;
          description = "A JavaScript project";
        };
        prismaTemplate = {
          inherit welcomeText;
          path = ./prisma;
          description = "A JavaScript project with Prisma";
        };
        railsTemplate = {
          inherit welcomeText;
          path = ./rails;
          description = "A ruby on rails project";
        };
        rubyTemplate = {
          inherit welcomeText;
          path = ./ruby;
          description = "A ruby project";
        };
      in {
        templates = {
          csharp = dotnetTemplate;
          dotnet = dotnetTemplate;
          hugo = hugoTemplate;
          javascript = javascriptTemplate;
          js = javascriptTemplate;
          node = javascriptTemplate;
          prisma = prismaTemplate;
          rails = railsTemplate;
          ruby = rubyTemplate;
        };
      });
}
