{
  description = ".NET Application";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        buildInputs = [
          pkgs.dotnet-sdk # or dotnet-sdk_7, etc.
          pkgs.gawk # needed for the dotnet tool listing
          # Add other packages here, such as these examples:
          # pkgs.nodejs-slim pkgs.nodePackages.pnpm
          # pkgs.nodePackages.prettier
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = buildInputs;

          shellHook = ''
            # Assume development mode when running - mainly to ensure user secrets and
            # other development niceties are loaded
            export ASPNETCORE_ENVIRONMENT=Development
            export DOTNET_USE_POLLING_FILE_WATCHER=1

            # Restore dotnet tools
            dotnet tool restore > /dev/null

            # Output some helpful info
            echo -e "\ndotnet v$(dotnet --version)"
            echo -e "dotnet tools:\n$(dotnet tool list --local | awk 'NR > 2 { sub(/^dotnet-/, "", $3); print "  " $3, "v" $2 }')"
            # echo -e "node $(node --version)"
            # echo "pnpm v$(pnpm --version)"
            echo ""
          '';
        };
      });
}
