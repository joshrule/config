{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "adwaita";
    };
  };

  home.sessionVariables.GTK_THEME = "adwaita";

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com"
        "dash-to-panel@jderose9.github.com"
      ];
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "adwaita";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita";
  };

  # Scale QT stuff automatically.
  home.sessionVariables.QT_AUTO_SCREEN_SCALE_FACTOR = "1";

  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    qgnomeplatform
  ];

  # home.sessionVariables = {
  #   # Configure QT for zoom.
  #   # QT_AUTO_SCALE_FACTOR= 1;
  #   # QT_QPA_PLATFORM="xcb";
  #   # QT_WAYLAND_FORCE_DPI="physical";
  #   # QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
  #
  #   # Configure GDK for HiDPI.
  #   #GDK_DPI_SCALE = 1.0;
  #   #GDK_SCALE = 2.0;
  # };
}
