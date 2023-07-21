{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita";
    };
  };

  home.sessionVariables.GTK_THEME = "Adwaita";

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
      name = "Adwaita";
    };
  };

  ## Cursor
  home.pointerCursor = {
    name = "macOS-Monterey";
    package = pkgs.apple-cursor;
    size = 40;
    gtk.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "Adwaita";
  };

  # Scale QT stuff automatically.
  home.sessionVariables.QT_AUTO_SCREEN_SCALE_FACTOR = "1";

  # Zoom works better when this is enabled.
  # https://github.com/telegramdesktop/tdesktop/issues/24164
  #
  # I still have bugs, but looks like it's a known bug until upgrading to QT >= 6.5:
  # - https://bugreports.qt.io/browse/QTBUG-85297
  # - https://github.com/telegramdesktop/tdesktop/issues/16943
  home.sessionVariables.QT_QPA_PLATFORM = "wayland";

  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    qgnomeplatform
  ];
}
