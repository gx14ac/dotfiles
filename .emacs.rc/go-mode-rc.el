(require 'go-mode)
(require 'go-autocomplete)
(require 'go-flymake)
(require 'open-godoc)

(setq gofmt-command "goimports")
(add-hook 'go-mode-hook
          '(lambda()
             (add-hook 'before-save-hook 'gofmt-before-save)
             (common-mode-init)
             (setq indent-tabs-mode t)
             (go-eldoc-setup)))

;; helm-ghq-list
(defun helm-ghq--get-candidates ()
  (let* ((cmd-result (funcall 'shell-command-to-string "ghq list"))
         (candidates (split-string cmd-result "\n"))
         (candidates (sort candidates 'string<))
         (candidates (cdr candidates)))
    candidates))

(defvar helm-ghq-list-source
  (helm-build-sync-source "Helm ghq list"
    :candidates (helm-ghq--get-candidates)
    :candidate-number-limit 300
    :action 'helm-ghq--dired))

(defun helm-ghq--dired (name)
  (when (one-window-p)(split-window-horizontally))
  (other-window 1)
  (dired (concat (getenv "GOPATH") "/src/" name)))

(defun helm-ghq-list ()
  (interactive)
  (helm :sources '(helm-ghq-list-source) :buffer "*helm ghq list*"))

;; Change godoc buffer name
(defun godoc--get-buffer (query)
  "Get an empty buffer for a godoc QUERY."
  (let* ((buffer-name "*godoc*")
         (buffer (get-buffer buffer-name)))
    ;; Kill the existing buffer if it already exists.
    (when buffer (kill-buffer buffer))
    (get-buffer-create buffer-name)))

;; Docoument Popup
(defun godoc-popup ()
  (interactive)
  (unless (use-region-p)
    (error "Dose not region selection"))
  (let ((query (buffer-substring-no-properties (region-beginning) (region-end))))
    (run-at-time 0.1 nil 'deactivate-mark)
    (popup-tip
     (with-temp-buffer
       (let ((standard-output (current-buffer))
             (help-xref-following t))
         (prin1 (funcall 'shell-command-to-string (concat "go doc " query)))
         (buffer-substring-no-properties (+ (point-min) 1) (- (point-max) 3)))))))

;; toggle to test file
(defun go-toggle-to-test-file ()
  (interactive)
  (go-internal-toggle-to-test-file))

;; Open a go file and a test file side by side
(defun go-open-with-test-file ()
  (interactive)
  (other-window-or-split)
  (go-internal-toggle-to-test-file))

(defun go-internal-toggle-to-test-file ()
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "_test.go$" current-file)
           (setq tmp-file (replace-regexp-in-string "_test.go$" ".go" tmp-file)))
          ((string-match ".go$" current-file)
           (setq tmp-file (replace-regexp-in-string ".go$" "_test.go" tmp-file))))
    (unless (eq current-file tmp-file)
      (find-file tmp-file))))
