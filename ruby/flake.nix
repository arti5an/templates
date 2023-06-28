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
          # Add further dependencies here, e.g.:
          # pkgs.sqlite
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = buildInputs;

          # Use gems from a local cache
          GEM_HOME = ".cache/gems";

          # Use an isolated vendor bundler environment
          BUNDLE_DISABLE_SHARED_GEMS = 1;
          BUNDLE_PATH = "vendor/bundle";

          shellHook = ''
            # Install bundle if environment is missing or changes
            if [ ! -d "$BUNDLE_PATH" ]; then
              bundle install
            fi

            # Create a git repo if missing, to simplify flake use
            if [ ! -d .git ]; then
              git init -b main
              git add -A
              git commit -m "Initial commit"
            fi

            # Output some helpful info
            echo -e "\n$(ruby --version)"
            bundle --version
            echo ""
          '';
        };
      });
}
