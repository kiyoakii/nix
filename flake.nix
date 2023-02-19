{
  description = "Jin's Nix PC";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = github:pta2002/nixvim;
  };

  outputs = { self, nixpkgs, home-manager, ...}: 
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

          modules = [ 
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nabokov = {
                imports = [ ./home.nix ];
              };
            }
          ];

        };
      };

    }; 
}
