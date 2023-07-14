{
  description = "JavaScript Application with Prisma";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        buildInputs = [
          pkgs.nodePackages.pnpm
          pkgs.nodePackages.prettier
          pkgs.nodePackages.prisma
          pkgs.nodejs-slim
          pkgs.openssl
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = buildInputs;

          shellHook = ''
            # Assume development mode when running
            export NODE_ENV=development

            # Let prisma know where to find stuff
            export PRISMA_MIGRATION_ENGINE_BINARY="${prisma-engines}/bin/migration-engine"
            export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
            export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
            export PRISMA_INTROSPECTION_ENGINE_BINARY="${prisma-engines}/bin/introspection-engine"
            export PRISMA_FMT_BINARY="${prisma-engines}/bin/prisma-fmt"

            # Output some helpful info
            echo -e "\nnode $(node --version)"
            echo "pnpm v$(pnpm --version)"
            echo -e "\n$(prisma --version)\n"
          '';
        };
      });
}
