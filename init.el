;; Test

(defun dotspacemacs/layers ()
  (setq-default dotspacemacs-configuration-layers
                '(
                  swift
                  python
                  clojure
                  jabber
                  colors
                  javascript
                  dash
                  docker
                  emacs-lisp
                  git
                  html
                  markdown
                  (ruby :variables ruby-version-manager 'rbenv
                        ruby-enable-enh-ruby-mode t
                        ruby-test-runner 'rspec)
                  ruby-on-rails
                  yaml
                  syntax-checking
                  smex
                  shell
                  spell-checking

                  (shell :variables
                         shell-default-shell 'ansi-term))

                ;; Keep a kill ring
                dotspacemacs-enable-paste-micro-state t

                ;;rainbow delimiters, but no special highlighting for the "current" one
                dotspacemacs-highlight-delimiters 'any

                ;;these micro state have been buggy and I don't use them anyway
                dotspacemacs-enable-helm-micro-state nil

                dotspacemacs-smartparens-strict-mode t



                ;;these are annoying
                dotspacemacs-excluded-packages '(evil-little-word)))

(defun ah/get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

(defun ah/jabber-log-hook ()
  (flyspell-mode))

(defun ah/jabber-config ()
  (add-hook 'jabber-chat-mode-hook 'ah/jabber-log-hook)

  (setq jabber-auto-reconnect t)

  (let ((realpw (ah/get-string-from-file "~/.emacs.d.bak/.gmailpw")))
    (setq jabber-account-list
          `(("hinz.adam@gmail.com"
             (:password . ,realpw)
             (:port . 5223)
             (:network-server . "talk.google.com")
             (:connection-type . ssl)))))

  (jabber-connect-all))

(defun ah/clojure-config ()
  (with-eval-after-load 'clojure-mode
    (put-clojure-indent 'against-background 'defun)
    (put-clojure-indent 'nextTuple 'defun)
    (put-clojure-indent 'table 'defun)
    (put-clojure-indent 'tr 'defun)
    (put-clojure-indent 'td 'defun)
    (put-clojure-indent 'div 'defun)
    (put-clojure-indent 'header 'defun)
    (put-clojure-indent 'button 'defun)
    (put-clojure-indent 'span 'defun)
    (put-clojure-indent 'nav 'defun)
    (put-clojure-indent 'ul 'defun)
    (put-clojure-indent 'li 'defun)

    (put-clojure-indent 'GET 'defun)
    (put-clojure-indent 'POST 'defun)
    (put-clojure-indent 'fact 'defun)
    (put-clojure-indent 'routes 'defun)

    (put-clojure-indent 'emit-bolt! 'defun)
    (put-clojure-indent 'execute 'defun)
    (put-clojure-indent 'elmt 'defun))

  (add-hook 'clojure-mode-hook #'evil-smartparens-mode)

  (add-hook 'clojure-mode-hook #'clj-refactor-hook)
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)


  ;;make a "word" in Clojure span over hyphens
  (add-hook 'clojure-mode-hook #'(lambda () (modify-syntax-entry ?- "w")))
  ;;again, eyeball murder is frowned on
  (with-eval-after-load 'cider
    (set-face-attribute 'cider-error-highlight-face nil :underline "IndianRed3")))

(defun dotspacemacs/init ()
  (setq-default
   dotspacemacs-editing-style 'vim
   dotspacemacs-default-theme 'sanityinc-tomorrow-bright
   dotspacemacs-themes '(sanityinc-tomorrow-bright
                         spacemacs-dark
                         spacemacs-light)

   dotspacemacs-default-font '("Source Code Pro"
                               :size 18
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)

   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"

   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"

   dotspacemacs-smooth-scrolling t
   dotspacemacs-smartparens-strict-mode t
   dotspacemacs-whitespace-cleanup 'all)

  (set-face-attribute 'default nil :height 170))

(defun dotspacemacs/user-config ()
  ;;general settings
  (setq fill-column 100
        show-trailing-whitespace t
        evil-want-fine-undo 'no
        make-backup-files nil
        backup-directory-alist '((".*" . "~/.emacs.d/backups/"))
        magit-last-seen-setup-instructions "1.4.0"
        vc-follow-symlinks nil
        flycheck-rubocop-lint-only t
        flycheck-check-syntax-automatically '(mode-enabled save)
        system-uses-terminfo nil)

  ;; Don't let evil screw with my terminals
  (evil-set-initial-state 'term-mode 'emacs)

  ;;indents
  (setq evil-shift-width 2
        coffee-tab-width 2
        css-indent-offset 2
        js2-basic-offset 2
        js-indent-level 2
        js2-bounce-indent-p t)

  ;;save undo tree across sessions
  (setq undo-tree-auto-save-history t
        undo-tree-history-directory-alist
        `(("." . ,(concat spacemacs-cache-directory "undo"))))
  (unless (file-exists-p (concat spacemacs-cache-directory "undo"))
    (make-directory (concat spacemacs-cache-directory "undo")))

  (ah/clojure-config)
  (ah/jabber-config)


  (add-hook 'enh-ruby-mode-hook (lambda () (set-face-background 'enh-ruby-op-face nil)))


  ;;errors with less eyeball murder
  (with-eval-after-load 'flycheck
    (set-face-attribute 'flycheck-error nil :underline "IndianRed3"))


  ;;up the saturation of colored delimiters
  (with-eval-after-load 'rainbow-delimiters
    (require 'color)
    (dotimes (i (- rainbow-delimiters-max-face-count 1))
      (let ((face (rainbow-delimiters-default-pick-face (+ i 1) t nil)))
        (set-face-foreground face (color-saturate-name (face-foreground face) 30))))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (swift-mode yapfify pyvenv pytest pyenv-mode py-isort enh-ruby-mode projectile-rails pip-requirements live-py-mode hy-mode helm-pydoc feature-mode cython-mode anaconda-mode pythonic yaml-mode xterm-color ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package toc-org tagedit spacemacs-theme spaceline powerline smex smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe restart-emacs rbenv rake rainbow-mode rainbow-identifiers rainbow-delimiters pug-mode popwin persp-mode pcre2el paradox orgit org org-plus-contrib org-bullets open-junk-file neotree multi-term move-text mmm-mode minitest markdown-toc markdown-mode magit-gitflow macrostep lorem-ipsum livid-mode skewer-mode simple-httpd linum-relative link-hint less-css-mode js2-refactor js2-mode js-doc jabber fsm info+ indent-guide ido-vertical-mode hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile helm-gitignore request helm-flx helm-descbinds helm-dash helm-css-scss helm-ag haml-mode google-translate golden-ratio gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit git-commit with-editor evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eshell-z eshell-prompt-extras esh-help emmet-mode elisp-slime-nav dumb-jump f dockerfile-mode docker json-mode tablist magit-popup docker-tramp json-snatcher json-reformat diminish define-word dash-at-point column-enforce-mode color-identifiers-mode coffee-mode clj-refactor hydra inflections edn multiple-cursors paredit yasnippet s peg clean-aindent-mode cider-eval-sexp-fu eval-sexp-fu highlight cider spinner queue pkg-info clojure-mode epl chruby bundler inf-ruby bind-map bind-key auto-highlight-symbol auto-dictionary auto-compile packed dash aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async quelpa package-build color-theme-sanityinc-tomorrow))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
