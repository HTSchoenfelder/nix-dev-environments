{
  description = "Reproducible development shells for .NET/Angular and Go";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          commonPackages = with pkgs; [
            git
            jq
          ];

          dotnetAngularShell = pkgs.mkShell {
            packages = commonPackages ++ (with pkgs; [
              dotnet-sdk_10
              nodejs_22
              pnpm
              typescript-language-server
              vscode-langservers-extracted
            ]);

            DOTNET_CLI_TELEMETRY_OPTOUT = "1";
            DOTNET_NOLOGO = "1";

            shellHook = ''
              export NUGET_PACKAGES="$PWD/.cache/nuget"
              export npm_config_cache="$PWD/.cache/npm"
              mkdir -p "$NUGET_PACKAGES" "$npm_config_cache"

              echo "Development shell: .NET + Angular/TypeScript"
              echo "dotnet: $(dotnet --version) | node: $(node --version) | pnpm: $(pnpm --version)"
            '';
          };

          goShell = pkgs.mkShell {
            packages = commonPackages ++ (with pkgs; [
              go
              gopls
              gotools
              golangci-lint
              delve
            ]);

            shellHook = ''
              export GOPATH="$PWD/.cache/go"
              export GOMODCACHE="$GOPATH/pkg/mod"
              export GOCACHE="$PWD/.cache/go-build"
              export PATH="$GOPATH/bin:$PATH"
              mkdir -p "$GOMODCACHE" "$GOCACHE" "$GOPATH/bin"

              echo "Development shell: Go"
              echo "$(go version) | gopls: $(gopls version | head -n 1)"
            '';
          };
        in
        {
          default = dotnetAngularShell;
          dotnet-angular = dotnetAngularShell;
          go = goShell;
        }
      );
    };
}
