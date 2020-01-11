(package-initialize)

(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/appearance-rc.el")
(load "~/.emacs.rc/ido-smex-rc.el")
(load "~/.emacs.rc/paredit-rc.el")
(load "~/.emacs.rc/emacs-lisp-rc.el")
(load "~/.emacs.rc/magit-rc.el")
(load "~/.emacs.rc/multiple-cursor-rc.el")
(load "~/.emacs.rc/openwith-rc.el")
(load "~/.emacs.rc/dired-rc.el")
(load "~/.emacs.rc/helm-rc.el")
(load "~/.emacs.rc/autocommit-rc.el")
(load "~/.emacs.rc/eldoc-rc.el")
(load "~/.emacs.rc/recentf-rc.el")
(load "~/.emacs.rc/company-rc.el")
(load "~/.emacs.rc/editorconfig-rc.el")
(load "~/.emacs.rc/nasm-mode-rc.el")
(load "~/.emacs.rc/adga2-mode-rc.el")
(load "~/.emacs.rc/move-text-rc.el")
(load "~/.emacs.rc/mozc-rc.el")
(load "~/.emacs.rc/beep-rc.el")
(load "~/.emacs.rc/go-mode-rc.el")
(load "~/.emacs.rc/startup-rc.el")

;;; Packages that don't require configuration
(rc/require
 'dockerfile-mode
)

(setq inhibit-startup-message t)
