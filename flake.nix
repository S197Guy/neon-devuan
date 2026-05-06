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
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, mangowm, dms, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Expose home-manager package so 'nix run .#home-manager' works
      packages.${system} = {
        home-manager = home-manager.packages.${system}.home-manager;
        default = self.packages.${system}.home-manager;
      };

      homeConfigurations."neonscar" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./modules/home.nix
          catppuccin.homeManagerModules.catppuccin
          dms.homeModules.dank-material-shell
        ];
      };
    };
}
