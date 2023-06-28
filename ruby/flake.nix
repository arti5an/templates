{
  description = "Ruby Application";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        buildInputs = [
          pkgs.bashInteractive
          pkgs.ruby_3_2
          # Add further nix dependencies here, e.g.:
          # pkgs.sqlite
        ];
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

          shellHook = ''
            # Install bundle if environment is missing or changes
            if [ ! -d "$BUNDLE_PATH" ]; then
              bundle install
            fi

            # Output some helpful info
            echo -e "\n$(ruby --version)"
            bundler --version
            echo ""
          '';
        };
      });
}
