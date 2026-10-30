#!/usr/bin/env bash

set -Eeuo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
CLASS_DIR=$REPO_DIR/texmf/tex/latex/mc
WORK_DIR=$(mktemp -d "${TMPDIR:-/tmp}/mcreport-toc-test.XXXXXX")
trap 'rm -rf -- "$WORK_DIR"' EXIT

for command in lualatex pdftotext awk; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$command" >&2
        exit 1
    fi
done

cat > "$WORK_DIR/toc-regression.tex" <<'EOF'
\documentclass{mcreport}
\setcounter{secnumdepth}{3}
\AtBeginDocument{\setcounter{tocdepth}{3}}

\begin{document}
\tableofcontents
\chapter{Chapter}
\section{Section}
\subsection{Subsection}
\subsubsection{Numbered level four}
\subsubsection*{Unnumbered level four}
\addcontentsline{toc}{subsubsection}{Unnumbered level four}
Content.
\end{document}
EOF

export TEXINPUTS="$CLASS_DIR//:${TEXINPUTS:-}"

for pass in 1 2; do
    if ! lualatex \
        -output-directory="$WORK_DIR" \
        -interaction=nonstopmode \
        -halt-on-error \
        "$WORK_DIR/toc-regression.tex" \
        > "$WORK_DIR/lualatex-$pass.log" 2>&1; then
        tail -n 50 "$WORK_DIR/lualatex-$pass.log" >&2
        exit 1
    fi
done

toc_file=$WORK_DIR/toc-regression.toc
if ! grep -Fq \
    '\contentsline {subsubsection}{\numberline {1.1.1.1}Numbered level four}' \
    "$toc_file"; then
    printf 'Expected the numbered level-four heading in the table of contents.\n' >&2
    exit 1
fi

if ! grep -Fq \
    '\contentsline {subsubsection}{Unnumbered level four}' \
    "$toc_file"; then
    printf 'Expected the unnumbered level-four heading in the table of contents.\n' >&2
    exit 1
fi

pdftotext -bbox -f 1 -l 1 \
    "$WORK_DIR/toc-regression.pdf" \
    "$WORK_DIR/toc-regression.html"

word_xmin() {
   local pattern=$1

   awk -v pattern="$pattern" '
   index($0, pattern) {
       if (match($0, /xMin="[0-9.]+"/)) {
           print substr($0, RSTART + 6, RLENGTH - 7)
           exit
       }
   }
' "$WORK_DIR/toc-regression.html"
}

subsection_number_x=$(word_xmin '>1.1.1.</word>')
numbered_level_four_x=$(word_xmin '>1.1.1.1.Numbered</word>')
unnumbered_level_four_x=$(word_xmin '>Unnumbered</word>')

if [[ -z $subsection_number_x || -z $numbered_level_four_x ]] ||
   ! awk -v parent="$subsection_number_x" -v child="$numbered_level_four_x" \
       'BEGIN { exit !(child > parent + 20) }'; then
   printf 'Expected numbered level-four entry to be indented relative to its parent (parent x=%s, entry x=%s).\n' \
       "${subsection_number_x:-missing}" \
       "${numbered_level_four_x:-missing}" >&2
   exit 1
fi

if [[ -z $numbered_level_four_x || -z $unnumbered_level_four_x ]] ||
   ! awk -v numbered="$numbered_level_four_x" \
       -v unnumbered="$unnumbered_level_four_x" \
       'BEGIN { distance = unnumbered - numbered; exit !(distance > 30 && distance < 45) }'; then
   printf 'Expected unnumbered entry to align with the title position of the numbered level-four entry (number x=%s, unnumbered x=%s).\n' \
       "${numbered_level_four_x:-missing}" \
       "${unnumbered_level_four_x:-missing}" >&2
   exit 1
fi

printf 'mcreport TOC indentation tests passed.\n'
