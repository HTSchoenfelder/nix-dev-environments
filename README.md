# Nix development environments

Reproducible Nix development shells for two common stacks:

- **.NET + Angular/TypeScript**: .NET SDK 10, Node.js 22, pnpm and language servers
- **Go**: Go, gopls, gotools, golangci-lint and Delve

These shells are for application development. You do not need to develop a Nix
package to benefit from `nix develop`.

## Prerequisites

Install Nix with flakes enabled. On NixOS, the relevant system setting is:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

## Usage

Clone the repository and enter the desired shell:

```console
git clone https://github.com/HTSchoenfelder/nix-dev-environments.git
cd nix-dev-environments

# .NET + Angular/TypeScript
nix develop .#dotnet-angular

# Go
nix develop .#go
```

Running `nix develop` without a shell name opens the .NET/Angular environment.

The first invocation downloads the pinned dependencies. Project-specific build
caches are stored in `.cache/`, which Git ignores.

## Starting projects

Inside the .NET/Angular shell:

```console
dotnet new webapi -n Api
pnpm dlx @angular/cli@latest new web
```

The Angular CLI is intentionally invoked through pnpm instead of being pinned
globally, so each Angular project can control its own CLI version.

Inside the Go shell:

```console
mkdir hello-go && cd hello-go
go mod init example.com/hello-go
```

## Updating

Refresh the pinned nixpkgs revision and commit the resulting lock-file change:

```console
nix flake update
git add flake.lock
git commit -m "Update Nix dependencies"
```
