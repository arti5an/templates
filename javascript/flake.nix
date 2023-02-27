{
  description = "JavaScript Application";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              nodejs
              nodePackages.prettier
              # Uncomment any of these to enable alternate package managers:
              # nodePackages.pnpm
              # yarn
            ];
            shellHook = ''
              # Assume development mode when running
              export NODE_ENV=development

              # Output some helpful info
              echo -e "\nnode $(node --version)"
              echo "npm v$(npm --version)"
              # echo "pnpm v$(pnpm --version)"
              # echo -e "yarn v$(yarn --version)"
              echo ""
            '';
          };
      });
}
