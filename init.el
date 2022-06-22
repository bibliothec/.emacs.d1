(require 'package)
;; package.elが管理していないelisp置き場
(add-to-list 'load-path "~/.emacs.d/elisp/")
;; MELPAを追加(package.el)
(add-to-list 'package-archives '("melpa" . "https://stable.melpa.org/packages/")t)
;; Marmaladeを追加(package.el)
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/")t)
(fset 'package-desc-vers 'package--ac-desc-version)
;; package.elの初期化
(package-initialize)
;;上のワーニング回避
(setq display-warning-minimum-level :error)
;; タイトルパーにファイルのフルパスを表示する
(setq frame-title-format "%f")
(tab-bar-mode 1)
;; 行間
(setq-default line-spacing 0)
;;括弧を補完
(electric-pair-mode 1)
;; scroll一行づつ
(setq scroll-step 1)
;;タブ文字の削除
(setq-default indent-tabs-mode nil)
;;タブの大きさを指定
(setq-default tab-width 2)
;;初期画面でwelcome画面の表示を消す方法
(setq inhibit-startup-message t)
;;画面の下のバーで、今どこの行、列にいるかを表示させる。ex)Top(35,73)など
(line-number-mode t)
(column-number-mode t)
;; reload buffer
(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)
;;下のバーに時間を表示(これはあってもなくても良い)
(display-time)
;;リージョンに色をつける
(setq transient-mark-mode t)
;; 折り返し表示
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)
;;C-hでdeleteできるように設定
(global-set-key"\C-h" 'delete-backward-char)
;行番号を常に左端に表示させる(%の後の数字を変えることで左端からの幅が変更可能)
(global-linum-mode)
(setq linum-format "%4d ")
;;現在いる行を目立たせる
;;(global-hl-line-mode)
;;対応する括弧のハイライト
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(set-face-attribute 'show-paren-match nil
      :background "gray"
      :underline 'unspecified)
;;上に書いた対応する括弧のハイライト設定のオプション(重複して設定はできないので注意)
;;画面内に対応する括弧がある場合は括弧だけを、ない場合は括弧で囲まれた部分をハイライト
(setq show-paren-style 'mixed)
;;対応する括弧だけをハイライト(setq show-paren-style 'parenthesis)
;;括弧で囲まれた部分をハイライト(setq show-paren-style 'expression)
;;バックグラウンドの色を変える
(set-face-background 'default "#303030")
;;色は#303030の部分を変えることで他の色に変更可能。
;;バックグラウンドの透過率の設定
(add-to-list 'default-frame-alist '(alpha . (1.0 1.0)))
;アルファ値(0.0 = 完全透明、1.0 = 不透明)で指定できる。
;;Ctrl-jで、日本語入力を可能にする(takadaqのみ)
(global-set-key (kbd "C-j") 'toggle-input-method)
;;日本語を使えるようにする(上の設定とセットでするべき？)
(set-language-environment "Japanese")
;;~のバックアップファアイルを作らない
(setq make-backup-files nil)
;;#のバックアップファアイルを作らない
(setq auto-save-default nil)

(set-face-foreground 'default "#f5f5f5")

;(require 'smartparens)
;(smartparens-global-mode t)
;(put 'upcase-region 'disabled nil)

(prog1 "prepare leaf"
  (prog1 "package"
    (custom-set-variables
     '(package-archives '(("org"   . "https://orgmode.org/elpa/")
                          ("melpa" . "https://melpa.org/packages/")
                          ("gnu"   . "https://elpa.gnu.org/packages/"))))
    (package-initialize))

  (prog1 "leaf"
    (unless (package-installed-p 'leaf)
      (unless (assoc 'leaf package-archive-contents)
        (package-refresh-contents))
      (condition-case err
          (package-install 'leaf)
        (error
         (package-refresh-contents)       ; renew local melpa cache if fail
         (package-install 'leaf))))

    (leaf leaf-keywords
      :ensure t
      :config (leaf-keywords-init)))

  (prog1 "optional packages for leaf-keywords"
    ;; optional packages if you want to use :hydra, :el-get,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t
      :custom ((el-get-git-shallow-clone  . t)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-archives
   '(("org" . "https://orgmode.org/elpa/")
     ("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages '(el-get hydra leaf-keywords leaf)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;タブを可視化
(leaf whitespace
  :ensure t
  :custom
  ((whitespace-style . '(face
                         trailing
                         tabs
                         ;; spaces
                         ;; empty
                         space-mark
                         tab-mark))
   (whitespace-display-mappings . '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
   (global-whitespace-mode . t)))

;;自動補完
(leaf auto-complete
  :ensure t
  :leaf-defer nil
  :config
  (ac-config-default)
  :custom ((ac-use-menu-map . t)
           (ac-ignore-case . nil))
  :bind (:ac-mode-map
         ; ("M-TAB" . auto-complete))
         ("M-t" . auto-complete)))

;;ミニバッファ補完
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)
  
(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

;;ソースコードのチェック
(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode" "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

