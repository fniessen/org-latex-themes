;;; test_org_boost_latex_classes.el --- Boost export tests -*- lexical-binding: t; -*-

(require 'ert)
(require 'org-boost-latex-classes)

(ert-deftest org-boost-registered-classes ()
  (dolist (group org-boost-latex-class-groups)
    (dolist (class (cdr group))
      (let ((entry (assoc class org-latex-classes)))
        (should entry)
        (should (string-prefix-p (format "\\documentclass{%s}\n" class)
                                 (cadr entry)))
        (should (equal (cddr entry) (car group)))))))

(ert-deftest org-boost-explicit-language-exported-header ()
  (dolist (class '("boostarticle" "boostreport" "boostbook"))
    (dolist (language '("fr" "en"))
      (let* ((org-export-show-temporary-export-buffer nil)
             (export (org-export-string-as
                      (format "#+LANGUAGE: %s\n#+LATEX_CLASS: %s\n#+LATEX_CLASS_OPTIONS: [final,%s]\n* Heading\nContent.\n"
                              language class
                              (if (equal language "fr") "french" "english"))
                      'latex))
             (babel-language (if (equal language "fr") "french" "english")))
        (should (string-match-p
                 (regexp-quote
                  (format "\\documentclass[final,%s]{%s}" babel-language class))
                 export))))))

(ert-deftest org-boost-default-class ()
  (let* ((org-export-show-temporary-export-buffer nil)
         (export (org-export-string-as
                  "Content.\n" 'latex)))
    (should (string-match-p
             (regexp-quote "\\documentclass{boostarticle}") export))))
