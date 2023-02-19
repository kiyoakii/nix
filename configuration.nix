# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
 
  # Bootloader.
  #boot.loader.systemd-boot.enable = true;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      version = 2;
      configurationLimit = 5;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
    };
    timeout = 10;
  };
  boot.kernelParams = [ "module_blacklist=i915" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  users.defaultUserShell = pkgs.fish;

  networking.hostName = "Jin-NixPC"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod.enabled = "ibus";
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ libpinyin ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nabokov = {
    isNormalUser = true;
    description = "Jin Li";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = builtins.concatLists [
      (with pkgs; [ firefox kate tdesktop thunderbird discord ])
      (with pkgs.fishPlugins; [sponge fzf-fish forgit grc bass ])
    ];

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCt/0z8gv87aLnAl3sdA7YF+IEGSriwOgT4z18q8ErD4QuUuTuwlqg2B97QdEaK/xFSi0WiCL3xQaWQSfu5YFEXW5wwvPCbaPzkXMqbUBp/y3QP2DjWKuZNukTDlRvjt2bE5tRA3W9GxQbmbQ7u/BmEpWkwdyNKfXK5XEI+LkhSsKrZ2NZ/IW9KoicSkkqlu2omQxEUdbADujRYQK0n/uTVfdOXMLtJ8AudOAfjWGiFr5RcfNuYvhRae2GTmjzlFFhviEsoEXTE3cXA8oIkENB80j/6cDc3Hi236i1cFRkZxuAtuDgxKFiSl1x8Bu0mlov33UzsfQ76Nk0VD/FKDSAB/ahKjmsGI3ElW5jnECPtpqiom7wbTBIe4nrubjIMUfp/eID+OGMamVcfSsVyM2IdCGN/rcv1bXP6bQuYsqXadKITLdU6ZkbpRAqPhivPwBj4f9UATvmnFBuc20ZuwFiBrl4e7cd+y5tzfQIyjMlBDcNai2+IDk8+R/ue+RdWnAS7TfW3qiwd+5Ibc9qeBlTPZNKjzXGHqI4XK0NsFcbZWUtBX3peDulHTh3duODbibFy9EEr4LxDhFB5SOblLRAERrFj3h2yD1CmEzXwrVFE08DbKko2ZkmF433oW2d9RSn5Tmzz2wF8q3zR7hSzy+z8UAqgpaJCJ7JglbtcLE4NFw== lijin110110@gmail.com" 
    ];
  };
  
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      fish 
      vim
      helix
      git
      wget
      vscode
      nginx
      htop
      cifs-utils
    ];
    
    shells = with pkgs; [ fish ];
    binsh = "${pkgs.dash}/bin/dash";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    fish.enable = true;
  };
  
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  
  services.samba-wsdd.enable = true;
  services.samba = {
    package = pkgs.samba4Full;
    enable = true;
    enableNmbd = true;
    securityType = "user";
    extraConfig = ''
      security = user 
      #use sendfile = yes
      #max protocol = smb2
    '';
    shares = {
      public = {
        path = "/mnt/hdd/movies";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
      };
    }; 
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "12yrhlbigpy44rl3icir3jj2p5fqq2ywgbp5v3m1hxxmbawsm6wi";
          }; } );
    })
  ];
 
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      system-features = [ "kvm" ];
      warn-dirty = false;
    };
  };
 
 
}
