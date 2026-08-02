{
  inputs = {
    nixpkgs-26-05.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    my_feed_notification = {
      url = "github:LucasNT/MyFeedNotification/main";
      inputs.nixpkgs.follows = "nixpkgs-26-05";
    };
    swaylock-wrapper = {
      url = "github:LucasNT/swaylock-wrapper";
      inputs.nixpkgs.follows = "nixpkgs-26-05";
    };
    simple-go-uploader-file = {
      url = "github:LucasNT/simple-go-uploader-file";
      inputs.nixpkgs.follows = "nixpkgs-26-05";
    };
  };

  outputs = { self, nixpkgs-26-05, nixpkgs-unstable, ... }@inputs: {

    nixosConfigurations = {
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
        specialArgs = {
          inherit username;
          simple-go-uploader-file = inputs.simple-go-uploader-file.packages.x86_64-linux.default;
        };
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
