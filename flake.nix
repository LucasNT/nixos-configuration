{
  inputs = {
    nixpkgs-25-05.url = "github:NixOS/nixpkgs/nixos-25.05";
    dwl = {
      url = "github:LucasNT/dwl/main";
      inputs.nixpkgs.follows = "nixpkgs-25-05";
    };
    my_feed_notification = {
      url = "github:LucasNT/MyFeedNotification/main";
      inputs.nixpkgs.follows = "nixpkgs-25-05";
    };
  };

  outputs = { self, nixpkgs-25-05, ... }@inputs: {

    nixosConfigurations = {
      vm-nixos = let
        username = "lucas";
        specialArgs = { inherit username; };
      in nixpkgs-25-05.lib.nixosSystem {
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
          dwl_local = inputs.dwl.packages.x86_64-linux.default;
        };
      in nixpkgs-25-05.lib.nixosSystem {
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
          dwl_local = inputs.dwl.packages.x86_64-linux.default;
          my_feed_notification =
            inputs.my_feed_notification.packages.x86_64-linux.default;
        };
      in nixpkgs-25-05.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "visio-lucasNT"; }
          ./modules/baseSystem.nix
          ./hosts/visio-note/configuration.nix
        ];
      };

      momo = let
        username = "lucas";
        specialArgs = { inherit username; };
      in nixpkgs-25-05.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "momo"; }
          ./hosts/base/configuration.nix
          ./hosts/momo/configuration.nix
        ];
      };

    };
  };
}
