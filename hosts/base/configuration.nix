{ config, lib, pkgs, username, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "nfs" ];

  };

  console = {
    font = "sun12x22";
    keyMap = "br-abnt2";
  };

  environment.systemPackages = with pkgs; [ vim wget curl tmux ];

  fonts.packages = with pkgs; [
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    cascadia-code
  ];

  i18n.defaultLocale = "pt_BR.UTF-8";

  programs = { git.enable = true; };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };
  };

  system.stateVersion = lib.mkDefault "24.11";

  time.timeZone = "America/Sao_Paulo";

  imports = [ ./services/openssh.nix ];

}
