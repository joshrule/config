{ flake-inputs, config, pkgs, lib, ... }:

let
  # Escaping `$` with `''$`:
  # https://discourse.nixos.org/t/pkgs-writeshellscriptbin-error-syntax-error-unexpected/8405
  remove-live-photos = pkgs.writeShellScriptBin "remove-live-photos" ''
    for f in *.HEIC; do
        MOV_FILE=''${f%.HEIC}.MOV
        printf '%s\n' "''${f%.HEIC}"
        if [ -f "''$MOV_FILE" ]; then
            echo "removing ''${MOV_FILE}"
            rm ''${MOV_FILE}
        fi
    done
  '';

  # local-logseq = with pkgs; import ./logseq.nix { inherit lib stdenv fetchurl appimageTools makeWrapper electron_15; };

  my-python-packages = python-packages: with python-packages; [
    pip ipython
  ];

  python-with-my-packages = pkgs.python39.withPackages my-python-packages;

in 
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./emacs.nix
    ./tmux.nix
    ./gnome.nix
  ];

  # Home Manager needs information about you and the paths it should manage.
  home = {
    username = "rule";
    homeDirectory = "/home/rule";
    packages = with pkgs; [
      # custom stuff
      remove-live-photos
      # cli
      acpi                           # Query battery state.
      cmake
      dropbox
      exa                            # so nice for ls
      git-lfs                        # for BIG-bench
      glxinfo                        # Test opengl with glxgears.
      htop                           # Replace top with something reasonable.
      jq
      lesspipe                       # See more from the command line.
      nix-index                      # for locating files
      nixos-option                   # for checking system settings
      nodejs
      nodePackages.npm
      nodePackages.eslint
      parallel                       # Run stuff in parallel.
      pipenv
      pulseaudio                     # to control volume buttons
      qt5ct                          # This helps zoom work better.
      unzip                          # for opening stuff
      util-linux
      xsettingsd
      # languages
      python-with-my-packages
      texlive.combined.scheme-full
      # fonts
      corefonts                      # times, verdana, etc.
      font-awesome                   # for waybar.
      google-fonts                   # (almost) everything I ever wanted.
      # gui
      alacritty
      chromium
      firefox-wayland
      foot
      globalprotect-openconnect      # UC Berkeley VPN
      gnome.nautilus
      gnome.sushi
      inkscape                       # Let's draw.
      keepassxc
      libreoffice
      logseq
      mattermost-desktop
      networkmanagerapplet
      pavucontrol                    # Show me audio input/output levels.
      thunderbird-wayland
      unison
      zoom-us
      zotero
    ];
    sessionVariables = with config.xdg; {
      CONFIGDIR = "${config.home.homeDirectory}/project/config";
      MOZ_ENABLE_WAYLAND = 1;
      # XDG_CURRENT_DESKTOP = "sway";
      # Configure Julia.
      JULIA_DEPOT_PATH="${dataHome}/julia:\$JULIA_DEPOT_PATH";
    };
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };


  xdg = {
      enable = true;
      configFile = {
          "chromium-flags.conf".text = ''
            # Enable wayland support.
            --enable-features=UseOzonePlatform
            --ozone-platform=wayland
            # Configure hardware acceleration.
            --ignore-gpu-blocklist
            --enable-gpu-rasterization
            --enable-zero-copy
          '';
          "electron-flags.conf".text = ''
            # Enable wayland support.
            --enable-features=UseOzonePlatform
            --ozone-platform=wayland
          '';
          # Xft.dpi: 375808
          # "Xresources".text = ''
          #   Xcursor.theme: "Adwaita"
          #   Xcursor.size: 48
          # '';
          "alacritty/alacritty.yml".source = ./alacritty/alacritty.yml;
          "foot/foot.ini".source = ./foot/foot.ini;
          "vim/.vimrc".source = ./vim/vimrc;
          # Gdk/WindowScalingFactor 2
          # Xft/dpi 375808
          # "xsettingsd/xsettingsd.conf".text = ''
          #   Xft/Antialias 1
          #   Xft/Hinting 1
          #   Xft/HintStyle "hintslight"
          #   Xft/RGBA "rgb"
          #   Xcursor/size 48
          #   Xcursor/theme "Adwaita"
          # '';
      };
      cacheHome = "${config.home.homeDirectory}/.local/cache";
      configHome = "${config.home.homeDirectory}/.local/config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      # https://discourse.nixos.org/t/is-there-any-way-to-modify-an-applications-desktop-file/16739
      desktopEntries = {
          "org.codeberg.dnkl.foot" = {
            name = "Foot";
            type = "Application";
            exec = "foot";
            icon = "foot";
            terminal = false;
            categories= [ "System" "TerminalEmulator" ];
            genericName = "Terminal";
            comment = "A wayland native terminal emulator";
            settings = {
              Keywords = "shell;prompt;command;commandline";
              StartupWMClass = "foot";
            };
          };
      };
      userDirs = {
          enable = true;
          createDirectories = true;
          desktop = "\$HOME/inbox";
          download = "\$HOME/inbox";
          documents = "\$HOME/reference/documents";
          music = "\$HOME/reference/audio";
          pictures = "\$HOME/reference/images";
          publicShare = "\$HOME/.local/public";
          templates = "\$HOME/.local/templates";
          videos = "\$HOME/reference/videos";
      };
  };
  
  fonts.fontconfig.enable = true;

  programs = {
    bash = {
      enable = true;
      sessionVariables = {
        EDITOR = "vim";
      };
      profileExtra = ''
        # Set vimrc and source it on vim startup (https://tlvince.com/vim-respect-xdg)
        export VIMINIT='let $MYVIMRC="${config.xdg.configHome}/vim/.vimrc" | source $MYVIMRC'
      ''; 
      shellAliases = {
        gg = "git log --branches --remotes --tags --graph --oneline --decorate";
        gl = "git log --oneline -n $1";
        mv = "mv -i";
        o = "xdg-open";
        rm = "rm -i";
        timestamp = "date --utc +%Y-%m-%d-%H-%M-%S";
      };
    };

    # configuring git
    git = {
      enable = true;
      userName = "Josh Rule";
      userEmail = "joshua.s.rule@gmail.com";
      aliases = { wdiff = "diff --word-diff=color --unified=1"; };
      extraConfig = {
        core = { autocrlf = "input"; };
        init = { defaultBranch = "main"; };
      };
    };

    # set LESSOPEN to use lesspipe
    lesspipe.enable = true;
  };
} 
