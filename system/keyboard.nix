{ config, lib, pkgs, ... }:

{
  # Configure console keymap for US keyboard.
  console.keyMap = "us";

  # Configure GUI keymap for US keyboard.
  services.xserver.layout = "us";

  # Configure kanata (software keyboard remapper: https://github.com/jtroo/kanata).
  services.kanata = {
    enable = true;
    keyboards.cogito = {
      devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
      config = ''
        (defsrc
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          caps a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lmet lalt           spc            ralt prnt rctl
        )

        (deflayer qwerty
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          @cap a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lmet lalt           spc            ralt prnt rctl
        )

        (defalias
          ;; tap for esc, hold for lctl
          cap (tap-hold 200 200 esc lctl)
        )
      '';
    };
  };
}
