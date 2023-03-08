{
  description = ".NET Application";

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
            buildInputs = [
              dotnet-sdk # or dotnet-sdk_7, etc.
              gawk # needed for the dotnet tool listing
              # Add other packages here, such as these examples:
              # nodejs
              # nodePackages.pnpm
              # nodePackages.prettier
            ];
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
              # echo "npm v$(npm --version)"
              # echo "pnpm v$(pnpm --version)"
              echo ""
            '';
          };
      });
}
