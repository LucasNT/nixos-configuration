{
  inputs = {
    nixpkgs-25-05.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-24-11.url = "github:NixOS/nixpkgs/nixos-24.11";
    dwl = { url = "github:LucasNT/dwl/main"; };
  };

  outputs = { self, nixpkgs-25-05, nixpkgs-24-11, ... }@inputs: {

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
        specialArgs = { inherit username; };
      in nixpkgs-25-05.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "ringo"; }
          ./hosts/base/configuration.nix
          ./hosts/ringo/configuration.nix
          { environment.systemPackages = [ inputs.dwl.packages.default ]; }
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
