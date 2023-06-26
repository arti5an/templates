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
          pkgs.ruby_3_2
          pkgs.nodejs-slim
          pkgs.nodePackages.pnpm
          pkgs.nodePackages.prettier
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
          BUNDLE_SYSTEM_BINDIR = "./bin";

          # Ensure node operates in dev mode
          NODE_ENV = "development";

          shellHook = ''
            # Output some helpful info
            echo -e "\n$(ruby --version)"
            echo -e "$(bundle --version)"
            echo -e "node $(node --version)"
            echo "pnpm v$(pnpm --version)"
            echo ""
          '';
        };
      });
}
