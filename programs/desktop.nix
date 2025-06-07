{ config, lib, pkgs, username ? "lucas", dwl }:

{
  programs = { hyprlock.enable = true; };

  services = {
    hypridle.enable = true;
    libinput.enable = true;
  };

  users = {
    users."${username}" = {
      packages = with pkgs; [
        alacritty
        brightnessctl
        (callPackage ./dwlmsg.nix { })
        (callPackage ./dwl-tag-viewer.nix { })
        dunst
        dwl
        eww
        grim
        playerctl
        rose-pine-cursor
        rxvt-unicode
        slurp
        swappy
        wl-clipboard
        wlr-randr
        wofi
        xdg-utils
        xorg.xrdb
      ];
    };
  };

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
