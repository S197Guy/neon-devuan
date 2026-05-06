{
  description = "neon-Devuan: Beautiful, minimal Devuan configuration with Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    
    mangowm = {
      url = "github:mangowm/mangowm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, mangowm, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."neon-devuan" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./modules/home.nix
          catppuccin.homeManagerModules.catppuccin
        ];
      };
    };
}
