{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-24-11.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, nixpkgs-24-11 }: {

    nixosConfigurations = {
      vm-nixos = let
        username = "lucas";
        specialArgs = { inherit username; };
      in nixpkgs.lib.nixosSystem {
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
        specialArgs = { inherit username; };
      in nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "ringo"; }
          ./hosts/base/configuration.nix
          ./hosts/ringo/configuration.nix
        ];
      };

      visio-lucasNT = let
        username = "lucas";
        specialArgs = { inherit username; };
      in nixpkgs-24-11.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "visio-lucasNT"; }
          ./hosts/base/configuration.nix
          ./hosts/visio-note/configuration.nix
        ];
      };

    };
  };
}
