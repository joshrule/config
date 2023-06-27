{ config, lib, pkgs, ... }:

{
  # nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

  # Use GCC emacs.
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  home.packages = with pkgs; [
    ## Doom dependencies
    git
    (ripgrep.override {withPCRE2 = true;})
    gnutls                          # for TLS connectivity

    ## Optional dependencies
    coreutils                       # basic utilities
    fd                              # faster projectile indexing
    imagemagick                     # for image-dired
    # (lib.mkIf (config.programs.gnupg.agent.enable)
    #   pinentry_emacs)               # in-emacs gnupg prompts
    zstd                            # for undo-fu-session/undo-tree compression
    pkgs.emacs-all-the-icons-fonts  # fonts/icons

    ## Module dependencies
    # :checkers spell
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    # :lang latex
    texlab
    texlive.combined.scheme-full
    # :lang markdown
    pandoc
    mdl
    # :lang nix
    nixfmt
    nodePackages.yaml-language-server # for doom-emacs :lang yaml
    # :lang org
    sqlite
    # :lang shell
    shellcheck
    # :lang yaml
    tree-sitter
    tree-sitter-grammars.tree-sitter-yaml
  ];

  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  home.sessionVariables = with config.xdg; {
    DOOMDIR = "${configHome}/doom";
    DOOMLOCALDIR = "${configHome}/doom";
  };

  # fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

  xdg.configFile.emacs = {
    source = builtins.fetchGit {
        url = "https://github.com/hlissner/doom-emacs";
        ref = "develop";
    };
    onChange = "${pkgs.writeShellScript "doom-change" ''
        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
        if [ ! -d "$DOOMLOCALDIR" ]; then
            # ${config.xdg.configHome}/emacs/bin/doom -y install
            echo "YOU NEED TO INSTALL DOOM"
        else
            ${config.xdg.configHome}/doom/bin/doom -y clean
            ${config.xdg.configHome}/doom/bin/doom -y sync -u
        fi
    ''}";
  };

  # system.userActivationScripts = {
  #   installDoomEmacs = ''
  #     if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
  #        git clone --depth=1 --single-branch "${cfg.doom.repoUrl}" "$XDG_CONFIG_HOME/emacs"
  #        git clone "${cfg.doom.configRepoUrl}" "$XDG_CONFIG_HOME/doom"
  #     fi
  #   '';
  # };
}
