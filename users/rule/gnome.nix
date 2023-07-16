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
        "appindicatorsupport@rgcjonas.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
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
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    qgnomeplatform
  ];
}
