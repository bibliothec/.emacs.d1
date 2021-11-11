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

;;初期画面でwelcome画面の表示を消す方法
(setq inhibit-startup-message t)
;;画面の下のバーで、今どこの行、列にいるかを表示させる。ex)Top(35,73)など
(line-number-mode t)
(column-number-mode t)
;;下のバーに時間を表示(これはあってもなくても良い)
(display-time)
;;C-hでdeleteできるように設定
(global-set-key"\C-h" 'delete-backward-char)
;行番号を常に左端に表示させる(%の後の数字を変えることで左端からの幅が変更可能)
(global-linum-mode)
(setq linum-format "%4d ")
;;現在いる行を目立たせる
;;(global-hl-line-mode)
;;対応する括弧のハイライト
(show-paren-mode t)
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
