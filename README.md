# Nix development environments

Independent, reproducible Nix development environments for common stacks:

- **.NET + Angular/TypeScript**: .NET SDK 10, Node.js 22, pnpm and language servers
- **Go**: Go, gopls, gotools, golangci-lint and Delve
- **STACKIT infrastructure**: STACKIT CLI, Terraform, kubectl and Helm

Each environment is a self-contained flake with its own lock file, so it can be
updated, used or copied into a project independently. These shells are for
application development; you do not need to develop a Nix package to benefit
from `nix develop`.

```text
.
├── dotnet-angular/
│   ├── flake.nix
│   └── flake.lock
├── go/
│   ├── flake.nix
│   └── flake.lock
└── stackit/
    ├── flake.nix
    └── flake.lock
```

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
nix develop ./dotnet-angular

# Go
nix develop ./go

# STACKIT infrastructure
nix develop ./stackit
```

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

Refresh one environment's pinned nixpkgs revision and commit its lock-file
change:

```console
(cd dotnet-angular && nix flake update)
# or: (cd go && nix flake update)
# or: (cd stackit && nix flake update)

git add */flake.lock
git commit -m "Update Nix dependencies"
```
