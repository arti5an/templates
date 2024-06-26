{
  description = "Nix Flake Templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-templates.url = "github:NixOS/templates";
    community-templates.url = "github:nix-community/templates";
  };

  outputs = {
    nixpkgs,
    nixos-templates,
    community-templates,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    welcomeText = ''
      Usage:

      $ nix develop

      or, if you have direnv installed:

      $ direnv allow

      See https://github.com/arti5an/templates for more information.
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
    phoenixTemplate = {
      inherit welcomeText;
      path = ./devbox/phoenix;
      description = "An Elixir/Phoenix project";
    };
    prismaTemplate = {
      inherit welcomeText;
      path = ./prisma;
      description = "A JavaScript project with Prisma";
    };
    railsWithoutNodeTemplate = {
      inherit welcomeText;
      path = ./railswithoutnode;
      description = "A ruby on rails project with no dependency on node";
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
    inherit (nixos-templates) defaultTemplate;
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    templates =
      nixos-templates.templates
      // community-templates.templates
      // {
        csharp = dotnetTemplate;
        dotnet = dotnetTemplate;
        hugo = hugoTemplate;
        javascript = javascriptTemplate;
        js = javascriptTemplate;
        node = javascriptTemplate;
        phoenix = phoenixTemplate;
        prisma = prismaTemplate;
        rails = railsTemplate;
        railswithoutnode = railsWithoutNodeTemplate;
        ruby = rubyTemplate;
      };
  };
}
