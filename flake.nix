{
  description = "my dotfiles";


  inputs = {
    # unstable has the 'freshest' packages you will find, even the AUR
    # doesn't do as good as this, and it's all precompiled.
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
	let
	  system = "x86_64-darwin";
	  pkgs  = nixpkgs.legacyPackages.${system};
	in {
      homeConfigurations.py = home-manager.lib.homeManagerConfiguration {
		inherit pkgs;
        modules = [ ./home.nix ];
      };
    };

}
