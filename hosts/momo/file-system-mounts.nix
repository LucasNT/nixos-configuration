{ config, lib, pkgs, ... }:

{
  fileSystems."/files/Lucas" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@Lucas" ];
  };

  fileSystems."/files/backup-note" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@backup-note" ];
  };

  fileSystems."/files/memos" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@memos" ];
  };

  fileSystems."/files/visio-backup" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@visio-note-backup2" ];
  };

  fileSystems."/files/media" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@media-server" ];
  };

  fileSystem."/files/vmBackups" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@vmBackups" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /files/Lucas 192.168.189.9(rw,nohide,subtree_check) 192.168.189.8(rw,nohide,subtree_check) 192.168.189.4(rw,nohide,subtree_check) 192.168.135.3(rw,nohide,subtree_check)
      /files/media 192.168.189.9(rw,nohide,subtree_check) 192.168.189.8(rw,nohide,subtree_check) 192.168.189.4(rw,nohide,subtree_check) 192.168.135.3(rw,nohide,subtree_check) 192.168.189.82(rw,nohide,subtree_check)
      /files/vmBackups 192.168.189.5(rw,nohide,subtree_check)
    '';
  };
}
