{
  description = "neon-Devuan: Beautiful, minimal Devuan configuration with Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-shell = {
      url = "github:DreamMaoMao/dms-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Essential for OpenGL/EGL on non-NixOS
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, home-manager, mangowm, dms-shell, nixgl, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        home-manager = home-manager.packages.${system}.home-manager;
        default = self.packages.${system}.home-manager;
      };

      homeConfigurations."neonscar" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./modules/home.nix
        ];
      };
    };
}
