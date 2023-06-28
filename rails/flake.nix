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
        buildInputs = [
          yarnAlias
          pkgs.bashInteractive
          pkgs.nodePackages.pnpm
          pkgs.nodePackages.prettier
          pkgs.nodejs-slim
          pkgs.ruby_3_2
          # Add further nix dependencies here, e.g.:
          # pkgs.sqlite
        ];
        yarnAlias = pkgs.writeScriptBin "yarn" ''
          #!${pkgs.stdenv.shell}
          pnpm "$@"
        '';
        environment = pkgs.stdenv.mkDerivation {
          inherit buildInputs;
          name = "environment";
          phases = [ "installPhase" "fixupPhase" ];
          installPhase = "touch $out";
        };
        environmentId =
          pkgs.lib.last (pkgs.lib.strings.splitString "/" "${environment}");
      in {
        devShells.default = pkgs.mkShell {
          packages = buildInputs;

          # Isolate the bundler environment
          BUNDLE_DISABLE_SHARED_GEMS = 1;
          BUNDLE_PATH = ".bundle/${environmentId}";

          # Ensure node operates in dev mode
          NODE_ENV = "development";

          shellHook = ''
            # Install bundle if environment is missing or changes
            if [ ! -d "$BUNDLE_PATH" ]; then
              bundle install
            fi

            # Output some helpful info
            echo -e "\nnode $(node --version)"
            echo "pnpm v$(pnpm --version)"
            ruby --version
            bundle --version
            bundle exec rails --version
            echo ""

            if [ ! -e config.ru ]; then
              echo -e "Run 'bundle exec rails' to get started.\n"
            fi
          '';
        };
      });
}
