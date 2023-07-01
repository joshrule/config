{ flake-inputs, config, lib, pkgs, ... }:
{
  # Configuring tmux
  programs.tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      historyLimit = 50000;
      mouse = true;
      newSession = true;
      prefix = "C-b";
      terminal = "screen-256color";
      plugins = with pkgs; [
        tmuxPlugins.sensible
      ];
      extraConfig = ''
        # split panes using | and -
        unbind '"'
        unbind %
        bind | split-window -h
        bind - split-window -v

        # listen to alerts from all windows
        set -g bell-action any

        # status bar config
        # host and session number on left
        set -g status-left "#h:[#S]"
        set -g status-left-length 50
        set -g status-right-length 50
        setw -g window-status-current-format "|#I:#W|"
        set-window-option -g automatic-rename off

        # vim movement bindings in copy mode
        setw -g mode-keys vi
      '';
  };

}
