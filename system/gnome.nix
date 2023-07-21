{ config, lib, pkgs, ... }:

{
  services.xserver = {

    # Enable a windowing system.
    enable = true;

    # Use GDM.
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # Use GNOME.
    desktopManager.gnome.enable = true;
  };

  # Cut the fluff.
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos   # photos tool
    gnome-tour     # tour
  ]) ++ (with pkgs.gnome; [
    cheese         # webcam tool
    gnome-music    # music tool
    gedit          # text editor
    epiphany       # web browser
    geary          # email reader
    tali           # poker game
    iagno          # go game
    hitori         # sudoku game
    atomix         # puzzle game
    yelp           # Help view
    gnome-contacts # contacts tool
    # gnome-characters
    # gnome-initial-setup
  ]);

  # Enable dconf for GNOME management.
  programs.dconf.enable = true;

  # Enable gnome-tweak for GNOME management.
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];

  # Probably already installed, but...
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
