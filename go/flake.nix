{
  description = "Development shell for Go";

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
              delve
              git
              go
              golangci-lint
              gopls
              gotools
              jq
            ];

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
        }
      );
    };
}
