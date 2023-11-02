{
  description = ".NET Application";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        buildInputs = [
          pkgs.dotnet-sdk # or dotnet-sdk_7, etc.
          # Add other packages here, such as these examples:
          # pkgs.nodejs-slim pkgs.nodePackages.pnpm
          # pkgs.nodePackages.prettier
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = buildInputs;

          # Ensure user secrets and other development niceties are loaded
          ASPNETCORE_ENVIRONMENT = "Development";

          # Uncomment if file changes aren't detected by dotnet watch
          # DOTNET_USE_POLLING_FILE_WATCHER = 1;

          shellHook = ''
            if [ -f .config/dotnet-tools.json ]; then
              # Restore dotnet tools specified in ./.config/dotnet-tools.json
              dotnet tool restore > /dev/null
            else
              # Create dotnet tools
              dotnet new tool-manifest > /dev/null

              # Add commonly used dotnet tools
              dotnet tool install csharpier > /dev/null
              dotnet tool install dotnet-outdated-tool > /dev/null
            fi

            # Output some helpful info
            echo -e "\ndotnet v$(dotnet --version)"
            echo -e "dotnet tools:\n$(dotnet tool list --local | ${pkgs.gawk}/bin/awk 'NR > 2 { sub(/^dotnet-/, "", $3); print "  " $3, "v" $2 }')"
            # echo -e "node $(node --version)"
            # echo "pnpm v$(pnpm --version)"
            echo ""
          '';
        };
      });
}
