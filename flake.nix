{
  description = "k3s";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    nixidy.url = "github:arnarg/nixidy";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = pkgs.git;
        packages.nixidy = inputs.nixidy.packages.${system}.default;
        legacyPackages = {
          nixidyEnvs.${system} = inputs.nixidy.lib.mkEnvs {
            inherit pkgs;
            # libOverlay = self: old: {
            #   lib = old.lib // {
            #     apps = import ./lib/lib.nix { inherit pkgs; };
            #   };
            # };
            # charts = inputs.nixhelm.chartsDerivations.${system};
            # modules = [
            #   ./modules
            #   ./apps
            #   ./policies
            # ];
            envs = {
              # prod = {
              #   name = "Production";
              #   description = "Production environment (default)";
              #   modules = [
              #     ./envs/prod.nix
              #   ];
              # };
              dev = {
                name = "Dev";
                description = "Dev environment (default)";
                modules = [
                  ./env/dev.nix
                ];
              };
            };
          };
        };

        # packages.nixidy = nixidy.packages.${system}.default;

        devenv.shells.default = {
          name = "k3s";

          languages = { };

          pre-commit.hooks = {
            treefmt = {
              package = pkgs.treefmt2;
              enable = true;
              settings = {
                formatters = [
                  pkgs.nixpkgs-fmt
                  pkgs.mdformat
                  pkgs.taplo # TOML - primarily just for the treefmt config files
                  pkgs.typos
                  pkgs.yamlfmt
                ];
              };
            };
          };

          packages = with pkgs; [
            config.packages.default

            self'.packages.nixidy

            just
            k3s
            k3d
            k9s
            kubectl
            kustomize
            kubernetes-helm
            crossplane-cli
            argocd
          ];
        };
      };
    };
}
