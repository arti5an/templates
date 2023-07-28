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

          # Ensure node operates in dev mode
          NODE_ENV = "development";

          # Let prisma know where to find stuff
          PRISMA_MIGRATION_ENGINE_BINARY =
            "${pkgs.prisma-engines}/bin/migration-engine";
          PRISMA_QUERY_ENGINE_BINARY =
            "${pkgs.prisma-engines}/bin/query-engine";
          PRISMA_QUERY_ENGINE_LIBRARY =
            "${pkgs.prisma-engines}/lib/libquery_engine.node";
          PRISMA_INTROSPECTION_ENGINE_BINARY =
            "${pkgs.prisma-engines}/bin/introspection-engine";
          PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";

          shellHook = ''
            # Output some helpful info
            echo -e "\nnode $(node --version)"
            echo "pnpm v$(pnpm --version)"
            echo -e "\n$(prisma --version)\n"
          '';
        };
      });
}
