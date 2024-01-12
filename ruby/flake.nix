{
  description = "Ruby Application";

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      buildInputs = [
        pkgs.ruby_3_2
        # Add further dependencies here, e.g.:
        # pkgs.ffmpeg-headless
        # pkgs.poppler
        # pkgs.sqlite
        # pkgs.vips
      ];
    in {
      devShells.default = pkgs.mkShell {
        packages = buildInputs;

        # Use gems from a local cache
        GEM_HOME = "tmp/gems";

        # Use an isolated vendor bundler environment
        BUNDLE_DISABLE_SHARED_GEMS = 1;
        BUNDLE_PATH = "vendor/bundle";

        shellHook = ''
          # Ensure local gem cache exists
          mkdir -p "$GEM_HOME/bin"

          # Install bundle if environment is missing or changes
          bundle check > /dev/null || bundle install

          # Create binstubs for lsp related tools, if included in bundle
          for stub in rubocop solargraph yard; do
            if [ ! -f bin/$stub ]; then
              bundle list --name-only | grep -q "^$stub$" && bundle binstubs $stub
            fi
          done

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

      formatter = pkgs.alejandra;
    });
}
