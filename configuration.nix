{ config, pkgs, callPackage, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "flekystyley";
  networking.nameservers = [ "8.8.8.8" ];  
  networking.wireless.enable = true;
  networking.networkmanager.enable = false;
  networking.networkmanager.extraConfig = ''
     [main]
     rc-manager=resolvconf
    '';

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts = {
    enableDefaultFonts     = true;
    enableFontDir          = true;
    enableGhostscriptFonts = true;
    fontconfig.enable      = true;
    fonts = with pkgs; [
      hack-font
      nerdfonts
    ];
  };

  i18n = {
    inputMethod.enabled      = "ibus";
    inputMethod.ibus.engines = with pkgs.ibus-engines; [ mozc anthy ];
    consoleFont              = "Lat2-Terminus16";
    consoleKeyMap 	     = "us";
    defaultLocale            = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Tokyo";

  environment.systemPackages = with pkgs; [
	wget 
	curl
    	git
   	zsh 
   	gcc 
   	gnumake 
   	binutils 
	pkg-config 
	zip 
	unzip 
	xclip 
	htop
   	openal 
	byobu 
	xorg.xev 
	xorg.xprop
   	vscode 
	chromium
	evince 
	tig
	emacs
	vim
	peco 
	neofetch 
	direnv 
	dmenu 
	polybar 
	hack-font
  	psmisc
	st
	compton
  ];
  
  environment.variables = {
      EDITOR  = "emacs";
      BROWSER = "chromium";
    };

  programs = {
      tmux.enable = true;
      zsh.enable  = true;
  };
  
  services.openssh.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable          = true;
    layout 	    = "us";
    xkbOptions      = "ctrl:nocaps";
    libinput.enable = true;

   windowManager.i3 = {
     enable        = true;
     package       = pkgs.i3-gaps;
     extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
     ];
    };
  };

  # TODO: must be working on 'compton.conf' 
  services.compton = {
    enable          = true;
    fade            = true;
    activeOpacity   = "0.9";
    inactiveOpacity = "0.8";
    shadow          = true;
    fadeDelta       = 4;
  };

 users.users.flekystyley = {
    isNormalUser = true;
    uid 	     = 1000;
    shell 	     = pkgs.zsh;
    home 	     = "/home/flekystyley";
    createHome 	     = true;
    extraGroups      = [ "wheel" "networkmanager" "tty" "dialout" "zsh" "plugdev" ];
  }; 
  
  # hardware.openrazer.enable = true;
  
  system.stateVersion = "19.03";
}
