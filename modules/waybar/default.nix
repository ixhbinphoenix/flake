{ lib, config, pkgs, ...}: with lib;
{
  imports = [];

  options = {};

  config = {
    # Need to wait for Waybar#3551
    programs.waybar = {
      enable = true;
      settings = {
        main = {
         layer = "bottom";
         position = "top";
         spacing = 5;
         modules-right = [
           "tray"
           "battery"
           "network"
           "clock"
         ];
  
         network = {
           format-wifi = "  {essid}";
           format-ethernet = "󰈁 {ipaddr}/{cidr}";
           format-linked = "󰈂 (no ip)";
           format-disconnected = "󰈂";
           family = "ipv4";
           tooltip = false;
         };
  
         clock = {
           format = "󰥔 {:%H:%M}";
           tooltip-format = "{:%H:%M %d %B %Y}";
         };
  
         tray = {
           spacing = 5;
         };
       };
    };
    style = ''
      @define-color bg #1e1e2e;
      @define-color text #cdd6f4;
  
      * {
        border: none;
        border-radius: 0px;
        min-height: 0;
        margin: 0.2em 0.3em 0.2em 0.3em;
      }
  
      #waybar {
        background: @bg;
        color: @text;
        font-size: 0.85rem;
        font-weight: bold;
       }
    '';
     };
  };
}
