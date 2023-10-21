{ config, pkgs, lib, ...}: {
  imports = [
    ../eww
  ];
  home.file.".config/hypr/mocha.conf" = {
    source = ./mocha.conf;
  };
  home.packages = with pkgs; [ nur.repos.mikilio.xwaylandvideobridge-hypr ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
    monitor=DP-1,2560x1440@144,1920x0,1
    monitor=DP-2,1920x1080@60,0x0,1
    monitor=HDMI-A-1,1600x900@60,4480x0,1

    workspace=1,monitor:DP-1,default:true
    workspace=2,monitor:DP-2,default:true
    workspace=3,monitor:HDMI-A-1,default:true

    windowrulev2= float,title:^(Picture-In-Picture)$

    # xwaylandvideobridge workaround
    windowrulev2 = opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$
    windowrulev2 = noanim,class:^(xwaylandvideobridge)$
    windowrulev2 = nofocus,class:^(xwaylandvideobridge)$
    windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$

    exec=random_wallpaper
    exec=dunst

    exec-once=wl-paste -t text --watch clipman store
    exec-once=swww init
    exec-once=waybar

    source=~/.config/hypr/mocha.conf

    input {
      kb_layout = us

      follow_mouse = 1
    }

    general {
      no_border_on_floating=true

      border_size=2
      gaps_in=5
      gaps_out=20

      col.active_border=0xff$mauveAlpha
      col.inactive_border=0x66$overlay0Alpha

      layout = dwindle
    }

    dwindle {
      pseudotile = true
      preserve_split = true
    }

    decoration {
      inactive_opacity=0.8

      drop_shadow=true
      shadow_range=4
      shadow_render_power=3
      col.shadow=0x1a$baseAlpha

      blur {
        enabled=true
        size=3
        passes=1
      }
    }

    animations {
      enabled=true

      # Default example animations
      bezier = myBezier, 0.05, 0.9, 0.1, 1.05

      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 7, default, popin 80%
      animation = border, 1, 10, default
      animation = borderangle, 1, 8, default
      animation = fade, 1, 7, default
      animation = workspaces, 1, 6, default
    }

    $mod = SUPER
    $actionMod = SUPER_SHIFT

    bind = $mod,Return,exec,kitty
    bind = $mod,Escape,exec,yofi
    bind = $mod,F4,exec,wlogout
    bind = $actionMod,W,exec,random_wallpaper
    bind = $actionMod,Q,killactive

    bind = ALT_SHIFT,S,exec,/home/phoenix/zipline.sh

    bind = $mod,F,fullscreen,0
    bind = $mod,G,togglefloating
    bind = $mod,W,pseudo
    bind = $mod,S,togglesplit


    # VIM-style focus moving
    bind = $mod,h,movefocus,l
    bind = $mod,j,movefocus,d
    bind = $mod,k,movefocus,u
    bind = $mod,l,movefocus,r

    # VIM-style window moving
    bind = $actionMod,h,swapwindow,l
    bind = $actionMod,j,swapwindow,d
    bind = $actionMod,k,swapwindow,u
    bind = $actionMod,l,swapwindow,r

    # Move focus to workspace
    bind = $mod,1,workspace,1
    bind = $mod,2,workspace,2
    bind = $mod,3,workspace,3
    bind = $mod,4,workspace,4
    bind = $mod,5,workspace,5
    bind = $mod,6,workspace,6
    bind = $mod,7,workspace,7
    bind = $mod,8,workspace,8
    bind = $mod,9,workspace,9
    bind = $mod,0,workspace,10

    # Move active window to workspace
    bind = $actionMod,1,movetoworkspacesilent,1
    bind = $actionMod,2,movetoworkspacesilent,2
    bind = $actionMod,3,movetoworkspacesilent,3
    bind = $actionMod,4,movetoworkspacesilent,4
    bind = $actionMod,5,movetoworkspacesilent,5
    bind = $actionMod,6,movetoworkspacesilent,6
    bind = $actionMod,7,movetoworkspacesilent,7
    bind = $actionMod,8,movetoworkspacesilent,8
    bind = $actionMod,9,movetoworkspacesilent,9
    bind = $actionMod,0,movetoworkspacesilent,10

    '';
  };
}
