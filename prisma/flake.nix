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
          pkgs.sqlite
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = buildInputs;

          # Ensure node operates in dev mode
          NODE_ENV = "development";

          # Let prisma know where to find the introspection engine
          PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
          PRISMA_INTROSPECTION_ENGINE_BINARY =
            "${pkgs.prisma-engines}/bin/introspection-engine";
          PRISMA_QUERY_ENGINE_BINARY =
            "${pkgs.prisma-engines}/bin/query-engine";
          PRISMA_QUERY_ENGINE_LIBRARY =
            "${pkgs.prisma-engines}/lib/libquery_engine.node";
          PRISMA_SCHEMA_ENGINE_BINARY =
            "${pkgs.prisma-engines}/bin/schema-engine";

          shellHook = ''
            if [ ! -f ./package.json ]; then
              # Initialise a node project
              pnpm init
              pnpm install @prisma/client@$(prisma --version 2>&1 | ${pkgs.gawk}/bin/awk --field-separator=: '/^prisma\s/ { gsub(/ /, "", $2); print $2 }')
            fi

            if [ ! -f ./prisma/schema.prisma ]; then
              # Initialise prisma
              read -e -p "Choose datasource provider -$(prisma init --help 2>&1 | ${pkgs.gawk}/bin/awk --field-separator=: '/^--datasource-provider/ { print $2 }') (sqlite): " dsprovider
              prisma init --datasource-provider ''${dsprovider:-sqlite}
            fi

            if [ ! -d ./node_modules ]; then
              # Restore missing node_modules directory
              pnpm install
            fi

            # Output some helpful info
            echo -e "\nnode $(node --version)"
            echo "pnpm v$(pnpm --version)"
            echo -e "\n$(prisma --version 2> /dev/null)\n"
          '';
        };
      });
}
