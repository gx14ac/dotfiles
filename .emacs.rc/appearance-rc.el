;;; Fonts

(defun rc/get-default-font ()
    (cond
        ((eq system-type 'gnu-linux) "Ubuntu Mono-12")))

(add-to-list 'default-frame-alist '(font . ,(rc/get-default-font)))

(when (display-graphic-p)
    (set-face-attribute 'fixed-pitch nil :family (rc/get-default-font)))

;;; GUI
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-numer-mode 1)
(show-paren-mode 1)

;;; Themes
(rc/require-them 'gruber-darker)