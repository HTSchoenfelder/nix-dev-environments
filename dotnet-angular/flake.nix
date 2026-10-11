{
  description = "Development shell for .NET and Angular/TypeScript";

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
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              dotnet-sdk_10
              git
              jq
              nodejs_22
              pnpm
              typescript-language-server
              vscode-langservers-extracted
            ];

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
        }
      );
    };
}
