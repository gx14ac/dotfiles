{ config, pkgs, ... }:

{
  services.xserver = {
    enable          = true;
    layout     	    = "us";
    xkbOptions      = "ctrl:nocaps";
    libinput.enable = true;

    windowManager.i3 = {
      enable  = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
	i3status
	i3lock
	i3blocks
      ];
    };
  };
  
  services.compton = {
    enable 	    = true;
    fade            = true;
    activeOpacity   = "0.9";
    inactiveOpacity = "0.8";
    shadow          = true;
    fadeDelta       = 4; 
  };
  
  fonts = {
    enableDefaultFonts     = true;
    enableFontDir          = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      hack-font
      nerdfonts
    ];
  };
}
