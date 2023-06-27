{ flake-inputs, config, lib, pkgs, ... }:
let
  doom-install-dir = "${config.xdg.configHome}/emacs/bin";
in
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

  home.sessionPath = [ doom-install-dir ];

  home.sessionVariables = with config.xdg; {
    DOOMDIR = "${configHome}/doom";
    DOOMLOCALDIR = "${configHome}/doom";
  };

  # fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

  xdg.configFile.emacs = {
    source = flake-inputs.doom;
    # TODO: Pull in source-controlled versions of personal doom configuration.
    onChange = "${pkgs.writeShellScript "doom-change" ''
        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
        if [ ! -d "$DOOMLOCALDIR" ]; then
            ${doom-install-dir}/doom --force install
        else
            ${doom-install-dir}/doom clean
            ${doom-install-dir}/doom sync -u
        fi
    ''}";
  };
}
