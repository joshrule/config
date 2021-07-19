{ config, pkgs, ... }:

let
  R-with-my-packages =  pkgs.rWrapper.override{ packages = with pkgs.rPackages; [ tidyverse lme4 ]; };
  RStudio-with-my-packages = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages; [ tidyverse lme4 ]; };
  my-python-packages = python-packages: with python-packages; [
    ipython
  ];
  python-with-my-packages = pkgs.python39.withPackages my-python-packages;
in 
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Setup overlays;
  nixpkgs.overlays = [
    # Emacs Overlay for gccemacs.
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rule";
  home.packages = with pkgs; [
    # cli
    jq
    lesspipe
    parallel
    # languages
    python-with-my-packages
    R-with-my-packages
    texlive.combined.scheme-full
    # gui
    google-chrome
    keepassxc
    mattermost-desktop
    RStudio-with-my-packages
    zoom-us
    zotero
  ];
  home.homeDirectory = "/home/rule";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  programs = {
    bash = {
      enable = true;
      sessionVariables = {
        EDITOR = "vim";
      };
    };

    emacs = {
      enable = true;
      package = pkgs.emacsGcc;
    };

    firefox = {
      enable = true;
    };

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

    # configuring tmux
    tmux = {
      enable = true;
    };
  };


  services = {
    # run Dropbox systemd service
    dropbox.enable = true;
  };
} 
