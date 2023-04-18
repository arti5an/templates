{
  description = "Hugo Site";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [ hugo nodePackages.prettier ];
            shellHook = ''
              # Output some helpful info
              echo -e "\n\e[0;32m$(hugo version)\e[0m\n"
            '';
          };
      });
}
