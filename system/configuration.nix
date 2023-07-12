# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# This configuration is for a Lenovo X1 Carbon Gen 9.

{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true; 

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Configure GNOME.
      ./gnome.nix
      # Configure keyboard.
      ./keyboard.nix
    ];

  # Enable nix flakes and nix commands.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Configure booting.
  boot = {
    # Stay up-to-date on the kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "auto";
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };

    # Disable containers because this install is old.
    enableContainers = false;

    # Silent Boot
    # https://wiki.archlinux.org/title/Silent_boot
    kernelParams = [
      "quiet"
      "splash"
      # "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log-priority=3"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 0;
    # github.com/NixOS/nixpkgs/pull/108294
    initrd.verbose = false;

    # Run plymouth.
    # plymouth.enable = true;
    # Load modules to help the boot splash screen.
    initrd.kernelModules = [ "i915" ];

    # TODO: What am I for?
    tmp.cleanOnBoot = true;
  };

  # Configure networking.
  networking = {
    # Define the hostname.
    hostName = "cogito";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    # https://github.com/NixOS/nixpkgs/issues/152288
    # networking.interfaces.wlp0s20f3.useDHCP = true;

    # Use networkmanager
    wireless.enable = false;
    networkmanager.enable = true;
  };

  # Set time zones automatically.
  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Setup the system console.
  console = {
    # Make fonts readable from the start of boot
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };

  services.xserver = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # video support
    videoDrivers = [ "modesetting" ];
  };

  ## HiDPI
  # 3840 x 2400 on 14.0" monitor
  services.xserver.dpi = 323;
  environment.variables = {
    # Scale QT stuff automatically.
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };


  # Allow firmware updating.
  services.fwupd.enable = true;

  # Additional hardware configuration
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware = {
    # Update the Intel microcode.
    cpu.intel.updateMicrocode = true;
    # Allow connected display discovery.
    i2c.enable = true;
    # Setup graphics acceleration.
    # TODO: Do we want this?
    # nixpkgs.config.packageOverrides = pkgs: {
    # vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    # };
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    # Use pipewire instead.
    pulseaudio.enable = false;
    # Allow trackpoint configuration.
    trackpoint.enable = true;
  };

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint 
      gutenprintBin
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
      hplip
      hplipWithPlugin
      splix
      samsung-unified-linux-driver
    ];
  };

  users = {
    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      rule = {
        isNormalUser = true;
        extraGroups = [
          "audio"          # Let me control sound.
          "networkmanager" # Let me control network connections.
          "video"          # Let me control video.
          "wheel"          # Let me `sudo`.
        ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brightnessctl # brightness
    vim           # To edit configuration.nix!
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.less.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Fix Eduroam.
  environment.etc."wpa_supplicant/openssl.cnf" = {
    source = ./openssl.cnf;
    mode = "0440";
  };
  systemd.services.wpa_supplicant.serviceConfig = {
    Environment = "OPENSSL_CONF=/etc/wpa_supplicant/openssl.cnf";
  };

  # Make Podman available.
  virtualisation = {
    podman = {
      enable = true;

      # alias `docker` to `podman`.
      dockerCompat = true;
      dockerSocket.enable = true;

      # Useful for `podman-compose`.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
