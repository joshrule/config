;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Joshua Rule"
      user-mail-address "joshua.s.rule@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "monospace" :font "JetBrains Mono" :size 24 :weight 'regular))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/"
      org-roam-directory "~/org/roam/"
      org-roam-dailies-directory "daily/")


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Workaround for upstream emacs 29 bug.
;; https://github.com/hlissner/doom-emacs/issues/5785#issuecomment-977536787
(general-auto-unbind-keys :off)
(remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; spell-checking
(after! spell-fu
  ;; Set the idle delay to be slightly higher.
  (setq spell-fu-idle-delay 0.25)   ; default is 0.25
  ;; Keep spell-checking from over-activating.
  (setf (alist-get 'markdown-mode +spell-excluded-faces-alist)
        '(markdown-code-face
          markdown-reference-face
          markdown-link-face
          markdown-url-face
          markdown-markup-face
          markdown-html-attr-value-face
          markdown-html-attr-name-face
          markdown-html-tag-name-face)))

;; Make text mode editing a little easier.
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; check these out:
;;
;; - (setq rust-format-on-save t)
;; - setup org agenda
;;   - setup org-stuck-projects

(after! lsp-julia
  (setq lsp-julia-default-environment "~/.local/share/julia/environments/v1.6"))

(after! org
  ;;;; General
  ;; Use the current window for c-c ' source editing.
  (setq org-src-window-setup 'current-window)
  ;; Special behaviors when using shift and arrow keys.
  (setq org-support-shift-select t)
  ;; Press enter to follow a link. Mouse clicks also work.
  (setq org-return-follows-link t)
  ;; Do smart things when navigating or editing lines.
  (setq org-special-ctrl-a/e t)
  (setq org-special-ctrl-k t)
  ;; Indent everything - the way an outline should be.
  (setq org-startup-indented t)
  ;; Open files with just the top headings visible.
  (setq org-startup-folded t)
  ;; Don't clobber trees.
  (setq org-catch-invisible-edits t)
  ;; Put indirect buffers in the current window.
  (setq org-indirect-buffer-display 'current-window)
  ;; Turn off hl-todo-mode in org buffers. We already have the faces we want there.
  (add-hook 'org-mode-hook #'(lambda () (hl-todo-mode -1)))
  ;; Use :ignore: on headings so that they are not exportedd.
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))
  ;; Clean up the ellipsis.
  (setq org-ellipsis "…")
  ;; Give me nice headings.
  (dolist (face '(outline-1
                  outline-2
                  outline-3
                  outline-4
                  outline-5
                  outline-6
                  outline-7
                  outline-8))
     (set-face-attribute face nil
                         :family "Monospace"
                         :foreground 'unspecified
                         :weight 'medium
                         :height 1.0))

;;;; TODOs
  ;; todo-states and faces
  (setq org-todo-keywords
        '((sequence "TODO(t!)" "LATER(l!)" "NEXT(n!)" "WAITING(w@)" "|" "CANCELLED(c@)" "DONE(x!)"))
        org-todo-keyword-faces
        '(("TODO"      :foreground "#00afaf" :weight black)
          ("LATER"     :foreground "#00afaf" :weight black)
          ("NEXT"      :foreground "#5f5faf" :weight black)
          ("WAITING"   :foreground "#d75f00" :weight black)
          ("CANCELLED" :foreground "#5b6268" :weight black)
          ("DONE"      :foreground "#5b6268" :weight black)))

  ;; Enforce dependencies so projects don't end with open items.
  (setq org-enforce-todo-dependencies t)

  ;;;; Capture
  ;; Store notes here by default
  (setq org-default-notes-file "~/org/capture.org")

  ;;;; Logging
  ;; Log each time a repeated task is completed.
  (setq org-log-repeat 'time)
  ;; Write log entries into a drawer.
  (setq org-log-into-drawer t)
  ;; Let's get org-roam going, too.
  (require 'org-roam))

(after! org-roam
  (setq org-roam-v2-ack t
        org-id-link-to-org-use-id t)
  ;; 2021-12-08: waiting for bugfix
  ;; https://github.com/org-roam/org-roam/issues/1981
  (require 'ucs-normalize)
  (require 'org-roam-dailies)
  ;;(org-roam-db-autosync-mode)
  )


(after! org-roam-dailies
  (setq org-roam-dailies-capture-templates
   '(
     ("s" "prayer" entry (file "~/org/templates/prayer.org")
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured)
     ("g" "gratitude" entry (file "~/org/templates/gratitude.org")
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured)
     ("j" "joy" entry (file "~/org/templates/joy.org")
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured)
     ("p" "daily preview" entry (file "~/org/templates/daily-preview.org")
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured)
     ("r" "daily review" entry (file "~/org/templates/daily-review.org")
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured)
     ("w" "weekly review" entry (file "~/org/templates/weekly-review.org")
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured)
     ("b" "bullseye review" entry (file "~/org/templates/bullseye-review.org")
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured)
     ("m" "bullseye review" entry (file "~/org/templates/meeting.org")
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured)
     ("n" "note" entry "* %U %?"
      :target (file+head+olp
               "%<%Y-%m-%d>.org"
               "#+title: %<%Y-%m-%d>\n"
               ("[[id:A7E4FA6D-99A9-4973-B9C1-B734E8F7D1E7][daily log]]"))
      :immediate-finish
      :jump-to-captured))))

(after! org-superstar
  (setq org-superstar-headline-bullets-list '("•")))
