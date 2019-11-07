{ config, pkgs, ... }:

{

 nixpkgs = {
   config.allowUnfree = true;
 };

 environment.systemPackages = with pkgs; [

	# basic
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
        evince 
        tig
        peco
        neofetch
        direnv
        dmenu
        compton
        qemu

	# terminal
        terminator

	# browser
	chromium

	# editor
        emacs
        vim
	vscode

	# programming launguage 
        go
        gcc
        libcap

	# file manager
        ranger

	# desktop manager
	feh

        # editor
        emacs
        vim 
        vscode 
  ];

  environment.variables = {
    EDITOR  = "emacs";
    BROWSER = "chromium";
  };
}
