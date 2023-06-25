{
  description = "Ruby on Rails Application";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        yarnAlias = pkgs.writeScriptBin "yarn" ''
          #!${pkgs.stdenv.shell}
          pnpm "$@"
        '';
        buildInputs = [
          pkgs.bashInteractive
          pkgs.ruby_3_2
          pkgs.nodejs-slim
          pkgs.nodePackages.pnpm
          pkgs.nodePackages.prettier
          yarnAlias
        ];
        environment = pkgs.stdenv.mkDerivation {
          inherit buildInputs;
          name = "environment";
          phases = [ "installPhase" "fixupPhase" ];
          installPhase = "touch $out";
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = buildInputs;
          shellHook = let
            environmentId =
              pkgs.lib.last (pkgs.lib.strings.splitString "/" "${environment}");
          in ''
            # Tie bundler working dir to environmental dependencies
            export BUNDLE_PATH=.bundle/${environmentId}

            # Assume development mode when running
            export NODE_ENV=development

            # Output some helpful info
            echo -e "\n$(ruby --version)"
            echo -e "$(bundler --version)"
            echo -e "node $(node --version)"
            echo "pnpm v$(pnpm --version)"
            echo ""
          '';
        };
      });
}
