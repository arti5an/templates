{
  description = "JavaScript Application";

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
            buildInputs =
              [ nodejs-slim nodePackages.pnpm nodePackages.prettier ];
            shellHook = ''
              # Assume development mode when running
              export NODE_ENV=development

              # Output some helpful info
              echo -e "\nnode $(node --version)"
              echo "pnpm v$(pnpm --version)"
              echo ""
            '';
          };
      });
}
