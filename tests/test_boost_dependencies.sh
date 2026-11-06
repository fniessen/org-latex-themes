#!/usr/bin/env bash

set -Eeuo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
CLASS_DIR=$REPO_DIR/texmf/tex/latex/boost
WORK_DIR=$(mktemp -d "${TMPDIR:-/tmp}/boost-dependencies-test.XXXXXX")
trap 'rm -rf -- "$WORK_DIR"' EXIT

for command in lualatex pdftotext emacs; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$command" >&2
        exit 1
    fi
done

export TEXINPUTS="$CLASS_DIR//:$WORK_DIR//:${TEXINPUTS:-}"

cat > "$WORK_DIR/check-order.tex" <<'EOF'
\makeatletter
\AddToHook{package/listings/before}{%
    \@ifpackageloaded{babel}{}{%
        \errmessage{Expected babel before listings}}}
\AddToHook{package/hyperref/before}{%
    \@ifpackageloaded{babel}{}{%
        \errmessage{Expected babel before hyperref}}%
    \@ifpackageloaded{amsmath}{}{%
        \errmessage{Expected amsmath before hyperref}}%
    \@ifpackageloaded{longtable}{}{%
        \errmessage{Expected longtable before hyperref}}}
\AddToHook{package/todonotes/before}{%
    \@ifpackageloaded{hyperref}{}{%
        \errmessage{Expected hyperref before todonotes}}}
\makeatother
EOF

cat > "$WORK_DIR/content.tex" <<'EOF'
\title{Dependency regression}
\author{Boost}
\date{2026-11-06}
\makeatletter
\@ifpackagewith{hyperref}{pdfusetitle}{}{%
    \errmessage{Expected the class to preserve hyperref pdfusetitle}}
\@ifpackagewith{url}{obeyspaces,spaces}{}{%
    \errmessage{Expected the class to preserve URL space options}}
\ifHy@colorlinks\else
    \errmessage{Expected colored hyperlinks}
\fi
\makeatother
\begin{document}
\expandafter\iflanguage\expandafter{\expectedlanguage}{}{%
    \errmessage{Expected \expectedlanguage, got \languagename}}
\tableofcontents
\clearpage
\section{DependencyProbe}\label{sec:probe}
\begin{equation}\label{eq:probe}
    E = mc^2,\qquad x\in\mathbb{R}
\end{equation}
Equation reference: \eqref{eq:probe}.
Section reference: \ref{sec:probe}.
\href{https://example.org/boost}{LinkProbe}.
\begin{longtable}{ll}
\caption{TableProbe}\label{tab:probe}\\
\toprule
\rowcolor{blue!10} Name & Value\\
\midrule
TableRowProbe & 42\\
\bottomrule
\end{longtable}
Table reference: \ref{tab:probe}.
\begin{lstlisting}[language=C,caption={ListingProbe}]
int main(void) { return 0; }
\end{lstlisting}
\begin{note}
BoxProbe
\end{note}
\boosttodo{TodoProbe}
\begin{acronym}[API]
\acro{API}{Application Programming Interface}
\end{acronym}
\ac{API}.
\begin{itemize}
\item Square marker
    \begin{itemize}
    \item Filled marker
        \begin{itemize}
        \item Open marker
        \end{itemize}
    \end{itemize}
\end{itemize}
\end{document}
EOF

compile() {
    local name=$1
    local pass

    for pass in 1 2; do
        if ! lualatex -output-directory="$WORK_DIR" \
            -interaction=nonstopmode -halt-on-error \
            "$WORK_DIR/$name.tex" > "$WORK_DIR/$name-build.log" 2>&1; then
            printf 'Compilation failed for %s on pass %s.\n' "$name" "$pass" >&2
            tail -n 60 "$WORK_DIR/$name-build.log" >&2
            exit 1
        fi
    done
    if grep -Eq 'undefined references|destination with the same identifier|Option clash' \
        "$WORK_DIR/$name-build.log"; then
        grep -n -E -C 2 'undefined references|destination with the same identifier|Option clash' \
            "$WORK_DIR/$name-build.log" >&2
        exit 1
    fi
}

for class in boostarticle boostreport boostbook; do
    for language in default english french; do
        name=$class-$language
        options=final,anonym
        expectedlanguage=$language
        if [[ $language == default ]]; then
            expectedlanguage=english
        else
            options+=,$language
        fi
        printf '\\input{check-order}\n\\documentclass[%s]{%s}\n\\def\\expectedlanguage{%s}\n\\input{content}\n' \
            "$options" "$class" "$expectedlanguage" > "$WORK_DIR/$name.tex"
        compile "$name"
        pdftotext "$WORK_DIR/$name.pdf" "$WORK_DIR/$name.txt"
        for probe in DependencyProbe TableRowProbe ListingProbe BoxProbe TodoProbe \
            'https://example.org/boost' 'Application Programming Interface'; do
            if ! grep -Fq "$probe" "$WORK_DIR/$name.txt"; then
                printf 'Missing rendered content in %s: %s\n' "$name" "$probe" >&2
                exit 1
            fi
        done
        contents_title=Contents
        if [[ $language == french ]]; then
            contents_title='Table des matières'
        fi
        if ! grep -Fq "$contents_title" "$WORK_DIR/$name.txt"; then
            printf 'Expected TOC title in %s: %s\n' "$name" "$contents_title" >&2
            exit 1
        fi
    done
done

cat > "$WORK_DIR/standalone.tex" <<'EOF'
\documentclass{article}
\usepackage{boostlistings}
\usepackage{boostboxes}
\begin{document}
\begin{lstlisting}[language=C]
int main(void) { return 0; }
\end{lstlisting}
\begin{note}
Standalone box
\end{note}
\end{document}
EOF
compile standalone

for language in fr en; do
    class_language=english
    if [[ $language == fr ]]; then
        class_language=french
    fi
    for class in boostarticle boostreport boostbook; do
        name=org-$class-$language
        printf '#+TITLE: Org language check\n#+LANGUAGE: %s\n#+LATEX_CLASS: %s\n#+LATEX_CLASS_OPTIONS: [final,anonym,%s]\n* OrgProbe\nLanguage-specific table of contents.\n' \
            "$language" "$class" "$class_language" > "$WORK_DIR/$name.org"
        emacs --batch -Q -l "$REPO_DIR/lisp/org-boost-latex-classes.el" \
            "$WORK_DIR/$name.org" --eval '(org-latex-export-to-latex)'
        compile "$name"
        pdftotext "$WORK_DIR/$name.pdf" "$WORK_DIR/$name.txt"
        contents_title=Contents
        if [[ $language == fr ]]; then
            contents_title='Table des matières'
        fi
        if ! grep -Fq "$contents_title" "$WORK_DIR/$name.txt"; then
            printf 'Expected Org-exported TOC title in %s: %s\n' \
                "$name" "$contents_title" >&2
            exit 1
        fi
    done
done

printf 'Boost dependency order, class integration and standalone style tests passed.\n'
