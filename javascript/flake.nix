{
  description = "JavaScript Application";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        buildInputs = [
          pkgs.nodePackages.pnpm
          pkgs.nodePackages.prettier
          pkgs.nodejs-slim
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = buildInputs;

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
