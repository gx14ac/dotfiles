{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      ./desktop.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.pulseaudio.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  sound.enable = true;

  networking = {
    hostName = "flekystyley";
    nameservers = [ "8.8.8.8" ];  
    wireless.enable = true;
    networkmanager.enable = false;
    networkmanager.extraConfig = ''
     [main]
     rc-manager=resolvconf
    '';
  };

  i18n = {
    inputMethod.enabled      = "ibus";
    inputMethod.ibus.engines = with pkgs.ibus-engines; [ mozc anthy ];
    consoleFont              = "Lat2-Terminus16";
    consoleKeyMap 	     = "us";
    defaultLocale            = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Tokyo";

  programs = {
    tmux.enable    = true;
    zsh.enable     = true;
    ssh.startAgent = true;
  };
  
  services.openssh.enable = true;

  users.users.flekystyley = {
    isNormalUser = true;
    uid 	 = 1000;
    shell 	 = pkgs.zsh;
    home 	 = "/home/flekystyley";
    createHome 	 = true;
    extraGroups  = [ "wheel" "networkmanager" "tty" "dialout" "zsh" "plugdev" ];
  }; 
  
  system.stateVersion = "19.03";
}
