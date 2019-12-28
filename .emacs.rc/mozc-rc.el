(rc/require 'mozc)

(global-set-key (kbd "C-j") 'toggle-input-method)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(prefer-coding-system 'utf-8)       
