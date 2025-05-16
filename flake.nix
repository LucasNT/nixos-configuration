{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; };

  outputs = { self, nixpkgs }: {

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
    };
  };
}
