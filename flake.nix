{
  description = "Jin's Nix PC";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, 
              hyprland,
              ...} @ inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nabokov = lib.nixosSystem {
          inherit system;

          specialArgs = {inherit inputs;};
          modules = [ 
            ./configuration.nix
            #home-manager.nixosModules.home-manager {
            #  home-manager.useGlobalPkgs = true;
            #  home-manager.useUserPackages = true;
            #  home-manager.users.nabokov = {
            #    imports = [ 
            #      ./dotfiles/.config/home-manager/home.nix 
            #    ];
            #  };
            #}

            hyprland.nixosModules.default
          ];
        };
      };

      homeConfigurations."nabokov@Jin-NixPC" = home-manager.lib.homeManagerConfiguration {
        modules = [
          ./home.nix
          #hyprland.homeManagerModules.default
          #{ wayland.windowManager.hyprland.enable = true; }
        ];
      };
    }; 
}
