;; List of modifier:
;;   Release, Control, Shift, Mod1 (Alt), Mod2 (NumLock),
;;   Mod3 (CapsLock), Mod4, Mod5 (Scroll).

;;;;EXTRA FUNCTIONS: Enable numlock, scrolllock or capslock usage
;;(set-numlock! #t)
;;(set-scrolllock! #t)
;;(set-capslock! #t)

;;;; Scheme API reference
;; Shell command key:
;; (xbindkey key "foo-bar-command [args]")
;; (xbindkey '(modifier* key) "foo-bar-command [args]")
;; 
;; Scheme function key:
;; (xbindkey-function key function-name-or-lambda-function)
;; (xbindkey-function '(modifier* key) function-name-or-lambda-function)
;; 
;; Other functions:
;; (remove-xbindkey key)
;; (run-command "foo-bar-command [args]")
;; (grab-all-keys)
;; (ungrab-all-keys)
;; (remove-all-keys)
;; (debug)

(xbindkey '(mod4 x) "xterm")
(xbindkey '(mod4 c) "conkeror")
(xbindkey '(mod4 j) "x-alt-tab")
(xbindkey '(mod4 k) "x-alt-tab -1")
(xbindkey '(mod4 space) "dmenu_run")
(xbindkey '(mod4 F10) "x-move-resize")
(xbindkey '(mod4 F11) "xdotool selectwindow windowsize 100% 100% windowmove 0 0")
