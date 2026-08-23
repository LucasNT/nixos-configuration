{ config, lib, pkgs, swaylock-wrapper, ... }:
let cfg = config.LucasNT.graphical-interface;
in {
  options.LucasNT.graphical-interface = {
    enable = lib.mkEnableOption "Enable niri grpahical interface";
    pkgs = lib.mkPackageOption pkgs "niri" { };
    extraFonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra fonts to install in the system";
    };

  };

  config = lib.mkIf cfg.enable {

    # miscellanious

    fonts = {
      fontconfig.useEmbeddedBitmaps = true;
      packages = with pkgs;
        [
          liberation_ttf
          fira-code
          fira-code-symbols
          mplus-outline-fonts.githubRelease
          noto-fonts
          dina-font
          proggyfonts
          cascadia-code
        ] ++ cfg.extraFonts;
    };

    hardware.graphics.enable = true;

    # Niri
    programs.niri.enable = true;
    programs.niri.package = cfg.pkgs;
    programs.niri.useNautilus = false;

    systemd.user.services.niri = {
      wants = [ "niri-swaybg.service" "niri-swayidle.service" ] ;
    };

    systemd.user.services.niri-swaybg = {
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      requires = [ "graphical-session.target" ];
      enable = true;
      serviceConfig = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -i %h/Imagens/planoDeFundo/103260037_p0.png -m fill";
        Restart = "on-failure";
      };
    };

    systemd.user.services.niri-swayidle = {
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      requires = [ "graphical-session.target" ];
      enable = true;
      serviceConfig = {
        ExecStart = "${pkgs.swayidle}/bin/swayidle -d timeout 60 '${swaylock-wrapper}/bin/swaylock-wrapper > /tmp/asd 2>&1' timeout 300 '${cfg.pkgs}/bin/niri msg action power-off-monitors' before-sleep '${pkgs.playerctl}/bin/playerctl -a stop' before-sleep '${swaylock-wrapper}/bin/swaylock-wrapper'";
        Restart = "on-failure";
      };
    };

    # xdg-portal

    services.gnome.gcr-ssh-agent.enable = false;

    xdg.portal = {
      enable = true;
      config = {
        niri = {
          default = [ "gnome" "gtk" ];
          "org.freedesktop.impl.portal.Access" = [ "gtk" ];
          "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        };
      };
      extraPortals =
        [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
    };

    # Sound System
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        extraConfig = {
          "10-bluez" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "hsp_hs" "hsp_ag" ];
          };
          "11-bluetooth-policy" = {
            "wireplumber.settings" = {
              "bluetooth.autoswitch-to-headset-profile" = false;
            };
          };
        };
      };
    };

    # Programs

    programs.firefox.enable = true;
    programs.waybar.enable = true;
    services.libinput.enable = true;

    users.users."${config.LucasNT.system.username}" = {
      packages = with pkgs; [
          alacritty
          bash-language-server
          brightnessctl
          dunst
          fuzzel
          grim
          playerctl
          rose-pine-cursor
          rxvt-unicode
          slurp
          swappy
          swaybg
          swayidle
          swaylock
          wl-clipboard
          wlr-randr
          xdg-utils
          xrdb
          xwayland-satellite
      ];
    };

  };
}
