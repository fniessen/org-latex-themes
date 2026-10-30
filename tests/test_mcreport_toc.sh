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
\usepackage{pdflscape}
\title{TOC regression}
\setcounter{secnumdepth}{3}
\AtBeginDocument{\setcounter{tocdepth}{3}}

\begin{document}
\tableofcontents
\chapter{Portrait chapter}
\section*{Portrait heading before landscape}
\section{Portrait heading}
\subsection{Subsection}
\subsubsection{Numbered level four}
\subsubsection*{Unnumbered level four}
\addcontentsline{toc}{subsubsection}{Unnumbered level four}
Content.
\clearpage
\begin{landscape}
\chapter*{ChapterProbe}
\section*{SectionProbe}
\subsection*{SubsectionProbe}
\subsubsection*{SubsubsectionProbe}
\section{Section heading in landscape}
\subsection{Subsection heading in landscape}
\subsubsection{Subsubsection heading in landscape}
\end{landscape}
\clearpage
\section*{Portrait heading after landscape}
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
   local file=$1
   local pattern=$2

   awk -v pattern="$pattern" '
   index($0, pattern) {
       if (match($0, /xMin="[0-9.]+"/)) {
           print substr($0, RSTART + 6, RLENGTH - 7)
           exit
       }
   }
' "$file"
}

subsection_number_x=$(word_xmin "$WORK_DIR/toc-regression.html" '>1.1.1.</word>')
numbered_level_four_x=$(word_xmin "$WORK_DIR/toc-regression.html" '>1.1.1.1.Numbered</word>')
unnumbered_level_four_x=$(word_xmin "$WORK_DIR/toc-regression.html" '>Unnumbered</word>')

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

pdftotext -bbox \
    "$WORK_DIR/toc-regression.pdf" \
    "$WORK_DIR/all-pages.html"

portrait_heading_x=$(word_xmin "$WORK_DIR/all-pages.html" '>before</word>')
portrait_after_x=$(word_xmin "$WORK_DIR/all-pages.html" '>after</word>')
landscape_chapter_x=$(word_xmin "$WORK_DIR/all-pages.html" '>ChapterProbe</word>')
landscape_section_x=$(word_xmin "$WORK_DIR/all-pages.html" '>SectionProbe</word>')
landscape_subsection_x=$(word_xmin "$WORK_DIR/all-pages.html" '>SubsectionProbe</word>')
landscape_subsubsection_x=$(word_xmin "$WORK_DIR/all-pages.html" '>SubsubsectionProbe</word>')

if [[ -z $landscape_chapter_x || -z $landscape_section_x ||
    -z $landscape_subsection_x || -z $landscape_subsubsection_x ]] ||
    ! awk -v chapter="$landscape_chapter_x" \
        -v section="$landscape_section_x" \
        -v subsection="$landscape_subsection_x" \
        -v subsubsection="$landscape_subsubsection_x" \
        'BEGIN { exit !(chapter > 30 && section > 30 && subsection > 30 && subsubsection > 30) }'; then
    printf 'Expected all heading levels to remain inside the landscape page margins (chapter x=%s, section x=%s, subsection x=%s, subsubsection x=%s).\n' \
        "${landscape_chapter_x:-missing}" \
        "${landscape_section_x:-missing}" \
        "${landscape_subsection_x:-missing}" \
        "${landscape_subsubsection_x:-missing}" >&2
    exit 1
fi

if ! awk -v chapter="$landscape_chapter_x" \
    -v section="$landscape_section_x" \
    -v subsection="$landscape_subsection_x" \
    -v subsubsection="$landscape_subsubsection_x" '
    BEGIN {
        first = section - chapter
        second = subsection - section
        third = subsubsection - subsection
        exit !(first > 0 && first < 10 &&
            second > 0 && second < 10 &&
            third > 0 && third < 10)
    }
'; then
    printf 'Expected chapter, section, subsection, and subsubsection offsets to step inward by about 0.1 cm per level (chapter x=%s, section x=%s, subsection x=%s, subsubsection x=%s).\n' \
        "${landscape_chapter_x:-missing}" \
        "${landscape_section_x:-missing}" \
        "${landscape_subsection_x:-missing}" \
        "${landscape_subsubsection_x:-missing}" >&2
    exit 1
fi

if [[ -z $portrait_heading_x || -z $portrait_after_x ]] ||
    ! awk -v before="$portrait_heading_x" -v after="$portrait_after_x" \
        'BEGIN { difference = before - after; if (difference < 0) difference = -difference; exit !(difference < 1) }'; then
    printf 'Expected portrait heading spacing to be restored after landscape (before x=%s, after x=%s).\n' \
        "${portrait_heading_x:-missing}" \
        "${portrait_after_x:-missing}" >&2
    exit 1
fi

printf 'mcreport TOC and landscape heading tests passed.\n'
