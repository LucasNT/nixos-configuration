{
  inputs = {
    nixpkgs-25-11.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-26-05.url = "github:NixOS/nixpkgs/nixos-26.05";
    my_feed_notification = {
      url = "github:LucasNT/MyFeedNotification/main";
      inputs.nixpkgs.follows = "nixpkgs-25-11";
    };
    swaylock-wrapper = {
      url = "github:LucasNT/swaylock-wrapper";
      inputs.nixpkgs.follows = "nixpkgs-25-11";
    };
  };

  outputs = { self, nixpkgs-26-05, nixpkgs-25-11, ... }@inputs: {

    nixosConfigurations = {
      vm-nixos = let
        username = "lucas";
        specialArgs = { inherit username; };
      in nixpkgs-25-11.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "vm-test"; }
          ./hosts/base/configuration.nix
          ./hosts/vm-teste/configuration.nix
        ];
      };

      ringo = let
        username = "ringo";
        specialArgs = {
          inherit username;
          swaylock-wrapper =
            inputs.swaylock-wrapper.packages.x86_64-linux.default;
        };
      in nixpkgs-26-05.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "ringo"; }
          ./modules/baseSystem.nix
          ./hosts/ringo/configuration.nix
        ];
      };

      visio-lucasNT = let
        username = "lucas";
        specialArgs = {
          inherit username;
          my_feed_notification =
            inputs.my_feed_notification.packages.x86_64-linux.default;
          swaylock-wrapper =
            inputs.swaylock-wrapper.packages.x86_64-linux.default;
        };
      in nixpkgs-26-05.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "visio-lucasNT"; }
          ./modules/baseSystem.nix
          ./modules/updateSystem.nix
          ./hosts/visio-note/configuration.nix
        ];
      };

      momo = let
        username = "lucas";
        specialArgs = { inherit username; };
      in nixpkgs-26-05.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "momo"; }
          ./modules/baseSystem.nix
          ./modules/updateSystem.nix
          ./hosts/momo/configuration.nix
        ];
      };

    };
  };
}
