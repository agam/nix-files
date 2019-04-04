{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "terminus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  #### Inserting my custom config

  # Enable the OpenSSH server.
  services.sshd.enable = true;

  # Allow the use of `sudo`
  security.sudo.enable =  true;

  # Allow members of the "wheel" group to sudo:
  security.sudo.configFile = ''
    %wheel ALL=(ALL) ALL
  '';

  # I wanna use mosh
  programs.mosh.enable = true;

  # Install FoundationDB
  services.foundationdb.enable = true;
  services.foundationdb.package = pkgs.foundationdb52;  # FoundationDB 5.2.x

  # Packages that everyone should have
  environment.systemPackages = with pkgs; [ git htop bat exa ripgrep jq tmux zsh oh-my-zsh ];

  # Environment variables that should always exist
  environment.variables = {
    OH_MY_ZSH = [ "${pkgs.oh-my-zsh}/share/oh-my-zsh" ];
  };

  programs.zsh = {
    enable = true;
    promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh
  };

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" ];
    theme = "agnoster";
  };

  environment.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    # Customize your oh-my-zsh options here
    ZSH_THEME="agnoster"
    plugins=(git)

    source $ZSH/oh-my-zsh.sh
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # My personal user account.
  users.users.agam = {
    isNormalUser = true;
    home = "/home/agam";
    description = "Agam";
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
