{
  description = "Josh Rule's system configurations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { emacs-overlay, home-manager, nixpkgs, nixos-hardware, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
        inherit system;
        config = {
            allowUnfree = true;
        };
        overlays = [ (import emacs-overlay) ];
    };
    lib = nixpkgs.lib;
  in {
    homeConfigurations."rule" = home-manager.lib.homeManagerConfiguration {
      # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
      # TODO: should I be using that "legacyPackages" command here?
      pkgs = pkgs;
      modules = [ ./users/rule/home.nix ./users/rule/emacs.nix ];
      # Optionally use extraSpecialArgs to pass arguments to home.nix.
    };
    nixosConfigurations = {
      cogito = lib.nixosSystem {
        inherit system;
        modules = [
          ./system/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
        ];
      };
    };
  };
}
