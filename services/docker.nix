{ config, lib, pkgs, btrfsEnable ? false }:

{
  virtualisation.docker = {
    enable = true;
    storageDriver = if btrfsEnable then "btrfs" else null;
  };
}
