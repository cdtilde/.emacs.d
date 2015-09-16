;;; wombat-theme.el --- Custom face theme for Emacs  -*-coding: utf-8 -*-

;; Copyright (C) 2011-2014 Free Software Foundation, Inc.

;; Author: Kristoffer Grönlund <krig@koru.se>

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(deftheme wombat2
  "Medium-contrast faces with a dark gray background.
Adapted, with permission, from a Vim color scheme by Lars H. Nielsen.
Basic, Font Lock, Isearch, Gnus, Message, and Ansi-Color faces
are included.")

(defvar textcolor   "#616161")
(defvar base1       "#3b3b3b")
(defvar base2       "#2f2f2f")
(defvar paper       "#f5f5f5")
(defvar paper-hl    "#e8e8e8")
(defvar lightblue1  "#529dff")
(defvar lightblue2  "#8bbdff")
(defvar grey1       "#999999")
(defvar green1      "#517d4f")
(defvar green2      "#829056")
(defvar red1        "#d35c5e")
(defvar red2        "#de8485")
(defvar blue1       "#4073b6")
(defvar blue2       "#325178")

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'wombat2
   `(default ((,class (:background "#242424" :foreground "#f6f3e8"))))
;;   `(default ((,class (:background "#000000" :foreground "#f6f3e8"))))
   `(cursor ((,class (:background "DarkOrange1"))))
   `(fringe ((,class (:background "#242424"))))
   `(highlight ((,class (:background "#454545" :foreground "#ffffff"))))
   `(region ((,class (:background "#444444" :foreground "#f6f3e8"))))
   `(anzu-mode-line ((,class (:foreground "yellow" :weight bold))))
   `(secondary-selection ((,class (:background "#333366" :foreground "#f6f3e8"))))
   `(isearch ((,class (:background "gold1" :foreground "black"))))
   `(lazy-highlight ((,class (:background "purple1" :foreground "white"))))
   `(vertical-border ((t (:foreground ,"white"))))
   `(hl-line ((t (:background ,"#e8e8e8"))))
   `(show-paren-match-face ((t (:background ,blue1))))
   `(show-paren-mismatch-face ((t (:background ,red1))))   
   `(mode-line
     ((t (:foreground ,"#f6f3e8" :background ,"#4073b6"  ;; #444444
                      :box nil))))
   `(mode-line-buffer-id ((t (:foreground ,"#f6f3e8"))))
   `(mode-line-inactive
     ((t (:foreground ,"#555555"  :background ,"#444444"
                      :box nil))))
   `(minibuffer-prompt ((,class (:foreground "#e5786d"))))
   `(escape-glyph ((,class (:foreground "#ddaa6f" :weight bold))))

   ;; Font lock faces
   `(font-lock-builtin-face ((,class (:foreground "#e5786d"))))
   `(font-lock-comment-face ((,class (:foreground "#99968b"))))
   `(font-lock-constant-face ((,class (:foreground "#e5786d"))))
   `(font-lock-function-name-face ((,class (:foreground "#cae682"))))
   `(font-lock-keyword-face ((,class (:foreground "#8ac6f2" :weight bold))))
   `(font-lock-string-face ((,class (:foreground "#95e454"))))
   `(font-lock-type-face ((,class (:foreground "#92a65e" :weight bold))))
   `(font-lock-variable-name-face ((,class (:foreground "#cae682"))))
   `(font-lock-fixme-face ((t (:foreground ,red1 :underline ,red1 :bold t))))   
   `(font-lock-warning-face ((,class (:foreground "#ccaa8f"))))

   ;; Button and link faces
   `(link ((,class (:foreground "#8ac6f2" :underline t))))
   `(link-visited ((,class (:foreground "#e5786d" :underline t))))
   `(button ((,class (:background "#333333" :foreground "#f6f3e8"))))
   `(header-line ((,class (:background "#303030" :foreground "#e7f6da"))))))


(custom-theme-set-variables
 'wombat2
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682"
			    "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"]))

(fringe-mode '(10 . 0))
(setq line-spacing nil)
(setq line-height nil)
(setq default-mode-line-format '(("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position
                                  (vc-mode vc-mode)
                                  "  " mode-line-modes mode-line-misc-info mode-line-end-spaces)))
(setq-default header-line-format nil)
(setq-default cursor-type 'box)
(provide-theme 'wombat2)




