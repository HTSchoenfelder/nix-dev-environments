{
  description = "Development shell for STACKIT infrastructure and Kubernetes";

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
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              git
              jq
              kubectl
              kubernetes-helm
              stackit-cli
              terraform
            ];

            shellHook = ''
              export TF_PLUGIN_CACHE_DIR="$PWD/.cache/terraform/plugins"
              mkdir -p "$TF_PLUGIN_CACHE_DIR"

              echo "Development shell: STACKIT + Terraform + Kubernetes"
              echo "stackit: $(stackit --version)"
              echo "terraform: $(terraform version -json | jq -r .terraform_version)"
              echo "kubectl: $(kubectl version --client -o json | jq -r .clientVersion.gitVersion)"
              echo "helm: $(helm version --short)"
            '';
          };
        }
      );
    };
}
