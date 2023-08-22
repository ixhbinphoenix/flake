{ config, pkgs, lib, ...}:
{
  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = ''
    output DP-1 pos 1920 0 res 2560x1440@143.912Hz
    output DP-2 pos 0 0 res 1920x1080@60.00Hz
    output DP-3 pos 4480 0 res 1600x900@60.00Hz

    set $screen-left DP-2
    set $screen-center DP-1
    set $screen-right DP-3

    set $scripts /home/phoenix/.local/bin/scripts/

    exec --no-startup-id ${pkgs.swww}/bin/swww init
    exec_always --no-startup-id $scripts/random_wallpaper

    set $mod Mod1

    bindsym $mod+Shift+w exec $scripts/random_wallpaper

    font pango:Iosevka Nerd Font 8

    # Window design
    default_border pixel
    default_floating_border pixel
    for_window [class=".*"] border pixel 4

    # Gaps
    gaps inner 14
    gaps outer 0

    # Floating/Fullscreen fixes
    for_window [title="Picture-in-Picture"] floating enable
    for_window [app_id="flameshot"] border pixel 0, floating enable, fullscreen disable, move absolute position 0 0

    exec_always --no-startup-id dunst

    exec export SSH_AUTH_SOCK

    bar swaybar_command waybar

    bindsym $mod+Return exec ${pkgs.kitty}/bin/kitty
    bindsym $mod+Escape exec ${pkgs.nur.repos.aleksana.yofi}/bin/yofi
    bindsym $mod+F4 exec ${pkgs.wlogout}/bin/wlogout

    bindsym $mod+Shift+q kill

    # change focus
    bindsym $mod+j focus left
    bindsym $mod+k focus down
    bindsym $mod+l focus up
    bindsym $mod+semicolon focus right

    # move focused window
    bindsym $mod+Shift+j move left
    bindsym $mod+Shift+k move down
    bindsym $mod+Shift+l move up
    bindsym $mod+Shift+semicolon move right

    # Split in horizontal / vertical
    bindsym $mod+h split h
    bindsym $mod+v split v

    # Fullscreen toggle
    bindsym $mod+f fullscreen toggle

    # Container layouts
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Toggle floating
    bindsym $mod+Shift+space floating toggle

    # Focus parent/child
    bindsym $mod+a focus parent
    bindsym $mod+d focus child

    # Reload configuration
    bindsym $mod+Shift+c reload
    # Restart sway inplace (preserves layout/session)
    bindsym $mod+Shift+r restart
    # exit sway
    bindsym $mod+Shift+e exit

    mode "resize" {
      bindsym j resize shrink width 10 px or 10 ppt
      bindsym k resize grow height 10 px or 10 ppt
      bindsym l resize shrink height 10 px or 10 ppt
      bindsym semicolon resize grow width 10 px or 10 ppt

      bindsym Return mode "default"
      bindsym Escape mode "default"
      bindsym $mod+r mode "default"
    }
    bindsym $mod+r mode "resize"

    # Workspaces
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10

    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10

    # Workspace to monitor bindings
    workspace $ws2 output $screen-left

    workspace $ws1 output $screen-center
    workspace $ws4 output $screen-center
    
    workspace $ws3 output $screen-right
    workspace $ws5 output $screen-right
    '';
  };
}
