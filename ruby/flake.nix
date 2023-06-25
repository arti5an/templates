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
        buildInputs = [ pkgs.bashInteractive pkgs.ruby_3_2 ];
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

            # Output some helpful info
            echo -e "\n$(ruby --version)"
            echo -e "$(bundler --version)"
            echo ""
          '';
        };
      });
}
