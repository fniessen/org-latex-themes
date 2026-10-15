# -*- mode: perl; coding: utf-8; -*-

# =========================================================
# latexmk configuration
# =========================================================

# Generate the PDF directly using LuaLaTeX.
$pdf_mode = 4;

# ---------------------------------------------------------
# PDF engines
# ---------------------------------------------------------

# PDF mode 1: pdfLaTeX (kept for compatibility).
# $pdflatex = 'pdflatex -interaction=nonstopmode -file-line-error -halt-on-error %O %S';
$pdflatex = '';
# Kept invalid so an accidental `latexmk -pdf` invocation does fail with
# a configuration error.

# PDF mode 4: LuaLaTeX (project's standard engine).
$lualatex = 'lualatex -interaction=nonstopmode -file-line-error -halt-on-error %O %S';

# PDF mode 5: XeLaTeX (explicitly disabled).
$xelatex = '';

# ---------------------------------------------------------
# Index generation
# ---------------------------------------------------------

# Previous implementation using texindy:
# $makeindex = 'texindy -L french -C utf8 %O -o %D %S';

# Current implementation using xindex (French).
$makeindex = 'xindex -l fr %O %S';

# ---------------------------------------------------------
# General build settings
# ---------------------------------------------------------

# Maximum number of compilation runs performed to resolve cross-references,
# table of contents, bibliography, etc.
$max_repeat = 5;

# Set to 1 to suppress most output (quiet mode).
# Set to 0 to display full build output (default).
$silent = 0;

# ---------------------------------------------------------
# Generated intermediate file extensions
#
# Used by latexmk for dependency tracking and cleanup.
# ---------------------------------------------------------

@generated_exts = qw(
                      aux
                      auxlock
                      bbl
                      bcf
                      blg
                      dvi
                      fdb_latexmk
                      fls
                      idx
                      ilg
                      ind
                      log
                      nav
                      out
                      run.xml
                      snm
                      synctex.gz
                      toc
                      vrb
                   );

# ---------------------------------------------------------
# Cleaning behavior
#
#   Clean     (latexmk -c)
#     Delete generated intermediate files.
#
#   Clean All (latexmk -C)
#     Delete generated intermediate and output files.
# ---------------------------------------------------------

# Intermediate files removed by both Clean and Clean All.
$clean_ext = join ' ', @generated_exts;

# Additional files removed by Clean All.
$clean_full_ext = 'pdf';
