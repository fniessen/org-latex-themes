%% boostreport.cls -- LaTeX2e Boost report class
%
% Copyright (C) 2008-2026 Fabrice Niessen. All rights reserved.

%* TODO
%
% - [ ] Review the (XXX) code
% - [ ] Check whether `quote' environment should be replaced by the `boostquote' one
% - [ ] Check whether `boost-bg-color' environment is still needed


%* Identification

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{boostreport}[2026/11/06 v2.0 Pirilampo report class]


%* Documentation

% See https://en.wikibooks.org/wiki/LaTeX


%* Requires

% Medium TeX Live installation + the following packages:
%
% sudo tlmgr install enumitem
% sudo tlmgr install comment
% sudo tlmgr install isodate
% sudo tlmgr install substr
% sudo tlmgr install sectsty
% sudo tlmgr install titlesec
% sudo tlmgr install footmisc
% sudo tlmgr install etoolbox
% sudo tlmgr install numprint
% sudo tlmgr install soul
% sudo tlmgr install todonotes
% sudo tlmgr install acronym
% sudo tlmgr install bigfoot
% sudo tlmgr install ucs
% sudo tlmgr install wrapfig


%* Options

%   - standard class to rely on; one option between the three following (which
%     are mutually exclusive):
%       + `article',
%       + `report' (= default) or
%       + `book'
%
%   - `final', for removing the DRAFT mentions
%   - `black', for colorizing all titles and links in black only
%   - `nocopyright', for removing the copyright symbol next to Boost in the footer
%   - `hideboostcomment', do not print boostcomments
%   - `anonym', do not print the Pirilampo logo and Boost in the footer
%   - `minitoc', add a minitoc at each chapter, works only with book style
%   - `french', sets the default document language to French (babel)


%* Declarations

% create new conditionals
\newif\if@article
\newif\if@report
\newif\if@draft
\newif\if@black
\newif\if@book
\newif\if@nocopyright
\newif\if@boostcomment
\newif\if@anonym
\newif\if@minitoc
\newif\if@french

% new conditionals are let equal to `\iffalse' initially
\@reporttrue
\@drafttrue
\@boostcommenttrue

\DeclareOption{article}{%
    \@articletrue%
    \@reportfalse%
    \ClassInfo{boostreport}{Saw option `article'}}
\DeclareOption{report}{%
    \@articlefalse%
    \@reporttrue%
    \ClassInfo{boostreport}{Saw option `report'}}
\DeclareOption{book}{%
    \@articlefalse%
    \@reportfalse%
    \@booktrue%
    \ClassInfo{boostreport}{Saw option `book'}}
\DeclareOption{nocopyright}{%
    \@nocopyrighttrue%
    \ClassInfo{boostreport}{Saw option `nocopyright'}}
\DeclareOption{hideboostcomment}{%
    \@boostcommentfalse%
    \ClassInfo{boostreport}{Saw option `hideboostcomment'}}
\DeclareOption{final}{%
    \@draftfalse%
    \ClassInfo{boostreport}{Saw option `final'}}
\DeclareOption{black}{%
    \@blacktrue%
    \ClassInfo{boostreport}{Saw option `black'}}
\DeclareOption{anonym}{%
    \@anonymtrue%
    \@nocopyrighttrue%
    \ClassInfo{boostreport}{Saw option `anonym'}}
\DeclareOption{minitoc}{%
    \if@book%
        \@minitoctrue%
        \ClassInfo{boostreport}{Saw option `minitoc'}
    \else%
        \ClassWarning{boostreport}{the `minitoc' option is ignored because it is only available in book style}%
    \fi}
\DeclareOption{french}{%
    \@frenchtrue%
    \ClassInfo{boostreport}{Saw option `french'}}
\DeclareOption*{% code to be executed for every unknown option
    \PassOptionsToClass{\CurrentOption}{article}%
    \PassOptionsToClass{\CurrentOption}{report}%
    \PassOptionsToClass{\CurrentOption}{book}%
}

\ProcessOptions\relax% execute the options

%* Document Classes

\if@article
    \LoadClass[a4paper,oneside,11pt]{article}
\else \if@report
    \LoadClass[a4paper,oneside,11pt]{report}
\else
    \LoadClass[a4paper,oneside,11pt]{book}
\fi \fi

% TODO Migrate...!
% Les packages les plus récents et, semble-t-il, les plus puissants
% proposant les watermarks sont draftmark et xwatermark :
% - http://tug.ctan.org/tex-archive/macros/latex/contrib/draftmark/
% - http://tug.ctan.org/tex-archive/macros/latex/contrib/xwatermark/
\if@draft
    \RequirePackage[firstpage]{draftwatermark}% (not in medium TeX Live installation)
    \SetWatermarkAngle{22.5}
    \SetWatermarkLightness{0.80}
    \SetWatermarkFontSize{2.5cm}
    \SetWatermarkScale{1.0}
\fi

\RequirePackage{float}


%* Layout (controlling the page layout)

% flexible and complete interface to document dimensions
\RequirePackage[%
    a4paper,%
    left=5.5cm,%
    right=2.0cm,%
    top=3.3cm,%
    headsep=2.0cm,%
    bottom=2.2cm,%
    bindingoffset=0cm,%
    footnotesep=24pt plus 5pt minus 5pt,
    head=27pt,% avoid "Package Fancyhdr Warning: \headheight is too small (12.0pt)"
]{geometry}

% driver-independent color extensions
\RequirePackage[table]{xcolor}

\definecolor{boost-color-brand}{HTML}{1968BA} % blue

\if@black
    \definecolor{boost-color-document-title}{HTML}{000000}
    \definecolor{boost-color-section-heading}{HTML}{000000}
    \definecolor{boost-color-section-in-page-heading}{HTML}{000000}
    \definecolor{boost-color-link}{HTML}{000000}
    \definecolor{boost-color-cite}{HTML}{000000}
    \definecolor{boost-color-file}{HTML}{000000}
    \definecolor{boost-color-url}{HTML}{000000}
\else
    \definecolor{boost-color-document-title}{HTML}{1968BA} % blue (XXX)
    \definecolor{boost-color-section-heading}{HTML}{1968BA} % blue (XXX)
    \definecolor{boost-color-section-in-page-heading}{HTML}{000000} % black
    \definecolor{boost-color-link}{HTML}{1968BA} % blue (TOC and intern links) (XXX)
    \definecolor{boost-color-cite}{HTML}{1968BA} % blue
    \definecolor{boost-color-file}{HTML}{003399} % darker blue
    \definecolor{boost-color-url}{HTML}{003399} % darker blue
\fi

\definecolor{shadecolor}{HTML}{33D1FF} % light blue for comments?
\definecolor{darkred}{HTML}{800000}
\definecolor{darkgreen}{HTML}{008000}
\definecolor{darkblue}{HTML}{000080}


%* Definitions (define your own commands etc.)

% Define the author's name for the copyright in the footer.
\newcommand{\boosttextlogo}[1]{\def\@boosttextlogo{#1}}

% Check if the author's name should be displayed or hidden.
\newcommand{\authorName}{\textsf{\color{black}Fabrice Niessen}}
\if@anonym%
    \boosttextlogo{}%
\else%
    \boosttextlogo{\authorName}
\fi

\newcommand{\boostbold}[1]{\textbf{#1}}
\newcommand{\boostred}[1]{{\color{boost-color-brand}\boostbold{#1}}}


%* Environments (such as enumerate & itemize)

\newcommand{\boostsquare}{\rule[.35ex]{.5ex}{.5ex}}

% control layout of `itemize', `enumerate', `description'
\RequirePackage{enumitem}% (not in medium TeX Live installation)
\setlist{%
    leftmargin=*,%
    labelsep=1.25cm,%
    itemindent=0pt,%
    topsep=5pt,%
    parsep=3pt}
\setlist[itemize]{%
    leftmargin=1.25em,%
    labelsep=0.75em,%
    itemsep=3pt,%
    topsep=4pt,%
    parsep=0pt}
\setitemize[1]{%
    label=\textcolor{boost-color-brand}{%
        \rule[.1ex]{1ex}{1ex}}}
\setitemize[2]{%
    label=\textcolor{boost-color-brand}{%
        \raisebox{.1ex}{%
            \tikz{\fill (0,0) circle[radius=.35ex];}}}}
\setitemize[3]{%
    label=\textcolor{boost-color-brand}{%
        \raisebox{.1ex}{%
            \tikz{\draw[line width=.06ex] (0,0) circle[radius=.27ex];}}}}
\setdescription{%
    font=\sffamily\bfseries,%
    labelwidth=0pt,%
    labelsep=0.5em,%
    leftmargin=1.45cm}

\RequirePackage[framemethod=tikz]{mdframed}

% single-spaced verbatim
\setlength\fboxsep{0pt} % border padding
\let\orig@verbatim\verbatim
\let\endorig@verbatim\endverbatim
\renewenvironment*{verbatim}
    {%
    \definecolor{shadecolor}{HTML}{F1F9EF}% light green
    \definecolor{linecolor}{HTML}{D4E8E3}% dark green
    \begin{mdframed}[linecolor=linecolor,backgroundcolor=shadecolor,innerleftmargin=3pt,innerrightmargin=3pt]% for verbatim background color
    \begin{orig@verbatim}%
    \begin{singlespace}}
    {%
    \end{singlespace}%
    \end{orig@verbatim}%
    \end{mdframed}}

% Verbatim font.
\renewcommand{\verbatim@font}{%
    \ttfamily
    % \scriptsize
%     \color{darkgreen}
    }

% allow wrapping of source table in LaTeX (see Emacs Org-mode's table editor)
\RequirePackage{comment}% (not in medium TeX Live installation)

% smaller font size and colored background for quotes
\renewenvironment{quote}
{\list{}{\rightmargin\leftmargin}%
\item\relax\small\begin{boost-bg-color}}
    {\end{boost-bg-color}\endlist}

\newsavebox{\boostquotationauthor}
\newenvironment{boostquotation}[1]{
    \ifstrempty{#1}{}{\sbox{\boostquotationauthor}{\parbox[b]{0.85\linewidth}{\raggedleft\footnotesize#1}}}%
    \vskip 5mm
    \begin{center}
        \begin{minipage}{0.85\linewidth}
            \em
}{
            \vskip 4mm
            \usebox{\boostquotationauthor}
        \end{minipage}
    \end{center}
    \vskip 5mm
}

% `\textcolor' chokes when it wraps multiple paragraphs
\definecolor{myblue}{HTML}{CCCCFF}

\newenvironment{boost-bg-color}
    {%
    \noindent\begin{lrbox}{\@tempboxa}%
    \begin{minipage}%
    {0.92\columnwidth}%\setlength{\parindent}{1em}
    \smallskip}
    {%
    \smallskip
    \end{minipage}%
    \end{lrbox}%
    \colorbox{myblue}{\usebox{\@tempboxa}}}

\newenvironment{boost-fg-color}[1]%
    {\color{#1}}
    {}

% for Org results
% XXX Must be customized properly!
\newenvironment{RESULT}[0]%
    {\color{green}}
    {}

%* Making Paragraphs (paragraph commands)

% paragraph layout with zero `\parindent' and non-zero `\parskip'
\RequirePackage{parskip}


%* Margin Notes (putting remarks in the margin)

\RequirePackage{framed}% for `shaded' environment
\RequirePackage{fancybox}

\reversemarginpar
\setlength\marginparwidth{115pt}
\setlength\marginparsep{20pt}

\newenvironment{boostnote}
    {\begin{list}{}{%
    \setlength{\leftmargin}{.15\linewidth}%
    \setlength{\rightmargin}{\leftmargin}}%
    \small\sffamily\item}
    {\end{list}}

% note | important| warning | caution | tip


%* Page Styles (various styles of page layout)

% make the title appear in sans serif font and in color
\let\orig@title\title
\renewcommand{\title}[1]{%
    \orig@title{\textsf{#1}}}

% Define subtitle

% Properly clear the global variables and commands
% (this is more a convention to prevent confusion with symbols defined at other
% scopes)
\global\let\@subtitle\@empty
\global\let\subtitle\relax

% Define the subtitle variable and initialize it
\newcommand{\subtitle}[1]{\def\@subtitle{#1}}
\subtitle{}

% To customize the Pirilampo logo displayed in the title page, simply call the
% \boosttitlegraphic{XXX} command.
\newcommand{\boosttitlegraphic}[1]{\def\@boosttitlegraphic{#1}}
\if@anonym%
    \boosttitlegraphic{}
\else%
    \boosttitlegraphic{}
\fi%

% \logo and \titlegraphic define client logo and title graphics.
% By default, \logo also defines the titlegraphic.
\newcommand{\logo}[1]{\def\@logo{#1}\def\@titlegraphic{#1}}
\logo{}

\newcommand{\titlegraphic}[1]{\def\@titlegraphic{#1}}
\titlegraphic{}

% changing margins "on the fly" (in mid document)
\newenvironment{boostchangemargin}[2]%
    {\begin{list}{}{%
        \setlength{\topsep}{0pt}%
        \setlength{\leftmargin}{#1}%
        \setlength{\rightmargin}{#2}%
        \setlength{\listparindent}{\parindent}%
        \setlength{\itemindent}{\parindent}%
        \setlength{\parsep}{\parskip}%
    }\item[]}%
    {\end{list}}

\if@article
    \renewcommand{\maketitle}{%
        \thispagestyle{plain}
        \begin{center}
            \@titlegraphic\par
            {\Huge \color{boost-color-document-title}\textbf{\@title}\par}%
            \vskip 5mm
            {\large \@author\par}%
            {\large \@date\par}%
        \end{center}
    }
\else
    \renewcommand{\maketitle}{%
        \thispagestyle{empty}%
        \begin{boostchangemargin}{-3.5cm}{0cm}% TODO Abstract it: add to boost lengths!

            \begin{center}
                \leavevmode
                \@titlegraphic\par
                \vspace{\stretch{2}}
                \normalfont
                {\Huge \color{boost-color-document-title}\textbf{\@title}\par}%
                \vskip 5mm
                \if@book
                \else
                    {\large \@author\par}%
                \fi
                \vskip 2mm
                {\large \@date\par}%
                \vspace{\stretch{3}}
                \@boosttitlegraphic
            \end{center}%
        \end{boostchangemargin}
        \null
        \clearpage
    }
\fi
% TODO Put a document log in every report...


% extensive control of page headers and footers
\RequirePackage{fancyhdr} % must be loaded after `geometry'
\ClassInfo{boostreport}{Using fancier footers than usual}

\newcommand{\footfont}{
    \fontsize{7pt}{0pt}\sffamily\selectfont
}
\newcommand{\headfont}{
    \fontsize{8pt}{8pt}\sffamily\selectfont
}

% Boost page headers definition
\newcommand{\boostheadl}{
    \headfont\textsc{\@title}}
\newcommand{\boostheadr}{\headfont%
    \if@article
        \@subtitle%
    \else
        \leftmark%
    \fi}
\newcommand{\boostheadc}{}

\newcommand{\boostcopyright}{%
    \if@nocopyright
        \relax
    \else
        \copyright~
    \fi
}

\newcommand{\boostfootl}{\footfont\raisebox{0.25mm}[0mm][-0.25mm]{\boostcopyright}\@boosttextlogo}
\newcommand{\boostfootc}{\footfont\@date
  \if@draft
  \\\bf -- DRAFT --
  \fi}
\newcommand{\boostfootr}{\footfont\thepage}


\fancypagestyle{empty}{%
    \fancyhf{} % clear all header and footer fields
    \renewcommand{\headrulewidth}{0.0pt}
    \renewcommand{\footrulewidth}{0.0pt}
}

\fancypagestyle{plain}{%
    \fancyhf{} % clear all header and footer fields
    \fancyhfoffset[L]{2.5cm} % offset to be applied to the header/footer
    \renewcommand{\headrulewidth}{0.0pt}
    \fancyfoot[L]{\boostfootl{}}
    \fancyfoot[C]{\boostfootc{}}
    \fancyfoot[R]{\boostfootr{}}
    \renewcommand{\footrulewidth}{0.4pt}
}

% TODO Put the headers and footers in some gray (#BBC9C9)
\fancypagestyle{headings}{%
    \fancyhf{} % clear all header and footer fields
    \fancyhfoffset[L]{2.5cm} % offset to be applied to the header/footer
    \fancyhead[L]{\boostheadl{}}
    \fancyhead[R]{\boostheadr{}}
    \fancyhead[C]{\boostheadc{}}
    \renewcommand{\headrulewidth}{0.4pt}
    \fancyfoot[L]{\boostfootl{}}
    \fancyfoot[C]{\boostfootc{}}
    \fancyfoot[R]{\boostfootr{}}
    \renewcommand{\footrulewidth}{0.4pt}
}

\pagestyle{headings}

% Redefine the chaptermark for the book and report classes.
% This must be put after the \pagestyle command call.
% (see fancyhdr documentation)
\ifdefined\chaptermark
    \renewcommand*{\chaptermark}[1]{\markboth{\thechapter. #1}{}}
\fi

% color page headings (very naughty)
\renewcommand{\MakeUppercase}[1]{%
    \color{boost-color-section-in-page-heading}\textsf{#1}}


%* Sectioning (how to section properly)

% control sectional headers
\RequirePackage{sectsty}% (not in medium TeX Live installation)
% redefine the font used for all section headings
\allsectionsfont{\usefont{T1}{phv}{b}{n}\selectfont% Helvetica-Narrow Bold
    \color{boost-color-section-heading}% make all section headings colored
    \nobreak}% because `\color' inserts a breakpoint

% select alternative section titles
\RequirePackage[compact]{titlesec}% (not in medium TeX Live installation)
\RequirePackage{needspace}
\titlespacing{\section}      {-2.50cm}{12pt}{9pt} % left, beforesep, aftersep
\titlespacing{\subsection}   {-1.38cm}{12pt}{6pt}
\titlespacing{\subsubsection}{-0.5cm}{12pt}{4pt}

% Keep section headings with at least a couple of lines of following content.
\AddToHook{cmd/chapter/before}{\Needspace{6\baselineskip}}
\AddToHook{cmd/section/before}{\Needspace{4\baselineskip}}
\AddToHook{cmd/subsection/before}{\Needspace{4\baselineskip}}
\AddToHook{cmd/subsubsection/before}{\Needspace{4\baselineskip}}
\AddToHook{cmd/paragraph/before}{\Needspace{4\baselineskip}}
\AddToHook{cmd/subparagraph/before}{\Needspace{4\baselineskip}}

% Use small, stepped title offsets inside landscape pages only.
\AddToHook{env/landscape/begin}[boostreport-landscape-title-spacing]{%
    \titlespacing*{\chapter}{-0.4cm}{50pt}{\ttl@chapafter}%
    \titlespacing{\section}{-0.3cm}{12pt}{9pt}%
    \titlespacing{\subsection}{-0.2cm}{12pt}{6pt}%
    \titlespacing{\subsubsection}{-0.1cm}{12pt}{4pt}%
}

% Defining the format of a paragraph heading (we want a line break).
% Note: needed to redefine the whole font as when using the titleformat
% command for the paragraph, the font selection done with allsectionsfont was
% lost.
\titleformat{\paragraph}[hang]
   {\usefont{T1}{phv}{b}{n}\selectfont\color{boost-color-section-heading}\nobreak\bfseries}
   {}
   {}
   {}
\titlespacing{\paragraph}{0pt}{0pt}{*0}

% Chapter header
\titleformat{\chapter}[hang]% shape
    {\fontsize{20pt}{24pt}\selectfont\sffamily\bfseries%
    \color{boost-color-section-heading}\vspace{30pt}}% fmt
    {\thechapter.}% label (heading number)
    {2mm}% sep
    {}% bef
    [{\titlerule[2.5pt]}]% aft

% How is 24pt chosen in `\fontsize{20pt}{24pt}\selectfont'?
% It is the baselineskip. A good value depends on the look of the font but
% 1.2 * size of the font is generally OK.

\def\@seccntformat#1{%
    \expandafter%
    \ifx\csname#1\endcsname\section
        \thesection.\quad % new definition only for `\section'
    \else
        \csname the#1\endcsname\quad % new definition for the others
    \fi
}

% discourage widows and orphans
\widowpenalty=10000 % no widow lines (default value: 150)
\clubpenalty=10000 % no orphan lines ("club lines" in LaTeX terminology, default value: 150)

%* Spaces & Boxes (all the associated commands)

% set space between lines
\RequirePackage{setspace}
\setstretch{1.2}

% customize footnotes
\RequirePackage[flushmargin]{footmisc}% (not in medium TeX Live installation)
% must be loaded after `setspace'

% standard graphics support
\RequirePackage{graphicx}
%\graphicspath{{~/texmf/tex/latex/images/}{images}{/}} % end dirs with `/'
\graphicspath{{images/}} % end dirs with `/'

\RequirePackage{wrapfig}

% include PDF pages as new pages (otherwise, use `includegraphics')
\RequirePackage{pdfpages}

% Alter some LaTeX defaults for better treatment of figures:
% See p.105 of "TeX Unbound" for suggested values.
% See pp. 199-200 of Lamport's "LaTeX" book for details.
% See http://www.tex.ac.uk/cgi-bin/texfaq2html?label=floats
%
% General parameters, for ALL pages:
\renewcommand{\topfraction}{0.85}% max fraction of page for floats at the top
\renewcommand{\bottomfraction}{0.7}% max fraction of page for floats at the bottom
%
% Parameters for TEXT pages (not float pages):
\setcounter{topnumber}{9}% total number of floats at the top of the page
\setcounter{bottomnumber}{9}% total number of floats at the bottom of the page
\setcounter{totalnumber}{20}% total number of floats on page
\setcounter{dbltopnumber}{9}% for 2-column pages
\renewcommand{\dbltopfraction}{0.66}% fit big float above 2-col. text
\renewcommand{\textfraction}{0.15}% min fraction of page for text
%
% Parameters for FLOAT pages (not text pages):
\renewcommand{\floatpagefraction}{0.66}% min fraction of `floatpage' that should
% have floats (MUST be less than `topfraction'!!)
\renewcommand{\dblfloatpagefraction}{0.66}% require fuller float pages


%* Table of Contents (how to create a table of contents)

\RequirePackage[dotinlabels]{titletoc}

% Define TOC indentations
\newlength{\boosttocindentlevelone}
\newlength{\boosttocindentleveltwo}
\newlength{\boosttocindentlevelthree}
\newlength{\boosttocindentlevelfour}
\setlength{\boosttocindentlevelone}{7mm}
\setlength{\boosttocindentleveltwo}{19mm}
\setlength{\boosttocindentlevelthree}{32mm}
\setlength{\boosttocindentlevelfour}{41mm}

\newlength{\boosttocbeforelevelone}
\newlength{\boosttocbeforeleveltwo}
\newlength{\boosttocbeforelevelthree}
\newlength{\boosttocbeforelevelfour}
\setlength{\boosttocbeforelevelone}{6mm}
\setlength{\boosttocbeforeleveltwo}{3mm}
\setlength{\boosttocbeforelevelthree}{0mm}
\setlength{\boosttocbeforelevelfour}{0mm}

\newlength{\boosttoclabelseplevelone}
\newlength{\boosttoclabelsepleveltwo}
\newlength{\boosttoclabelseplevelthree}
\newlength{\boosttoclabelseplevelfour}
\setlength{\boosttoclabelseplevelone}{7mm}
\setlength{\boosttoclabelsepleveltwo}{11mm}
\setlength{\boosttoclabelseplevelthree}{13mm}
\setlength{\boosttoclabelseplevelfour}{13mm}

\newlength{\boosttocindentchapter}
\newlength{\boosttocindentsection}
\newlength{\boosttocindentsubsection}
\newlength{\boosttocindentsubsubsection}

\newlength{\boosttocbeforechapter}
\newlength{\boosttocbeforesection}
\newlength{\boosttocbeforesubsection}
\newlength{\boosttocbeforesubsubsection}

\newlength{\boosttoclabelsepchapter}
\newlength{\boosttoclabelsepsection}
\newlength{\boosttoclabelsepsubsection}
\newlength{\boosttoclabelsepsubsubsection}

% Define TOC formats
\newcommand{\boosttocformatlevelone}{\sffamily\Large\bfseries}
\newcommand{\boosttocformatleveltwo}{\sffamily\large}
\newcommand{\boosttocformatlevelthree}{\sffamily}
\newcommand{\boosttocformatlevelfour}{\sffamily}

\setlength{\boosttocindentchapter}{\boosttocindentlevelone}
\newcommand{\boosttocformatchapter}{\boosttocformatlevelone}
\setlength{\boosttocbeforechapter}{\boosttocbeforelevelone}
\setlength{\boosttoclabelsepchapter}{\boosttoclabelseplevelone}
\if@article
    \setlength{\boosttocindentsection}{\boosttocindentlevelone}
    \setlength{\boosttocindentsubsection}{\boosttocindentleveltwo}
    \setlength{\boosttocindentsubsubsection}{\boosttocindentlevelthree}
    \newcommand{\boosttocformatsection}{\boosttocformatlevelone}
    \newcommand{\boosttocformatsubsection}{\boosttocformatleveltwo}
    \newcommand{\boosttocformatsubsubsection}{\boosttocformatlevelthree}
    \setlength{\boosttocbeforesection}{\boosttocbeforelevelone}
    \setlength{\boosttocbeforesubsection}{\boosttocbeforeleveltwo}
    \setlength{\boosttocbeforesubsubsection}{\boosttocbeforelevelthree}
    \setlength{\boosttoclabelsepsection}{\boosttoclabelseplevelone}
    \setlength{\boosttoclabelsepsubsection}{\boosttoclabelsepleveltwo}
    \setlength{\boosttoclabelsepsubsubsection}{\boosttoclabelseplevelthree}
\else
    \setlength{\boosttocindentsection}{\boosttocindentleveltwo}
    \setlength{\boosttocindentsubsection}{\boosttocindentlevelthree}
    \setlength{\boosttocindentsubsubsection}{\boosttocindentlevelfour}
    \newcommand{\boosttocformatsection}{\boosttocformatleveltwo}
    \newcommand{\boosttocformatsubsection}{\boosttocformatlevelthree}
    \newcommand{\boosttocformatsubsubsection}{\boosttocformatlevelfour}
    \setlength{\boosttocbeforesection}{\boosttocbeforeleveltwo}
    \setlength{\boosttocbeforesubsection}{\boosttocbeforelevelthree}
    \setlength{\boosttocbeforesubsubsection}{\boosttocbeforelevelfour}
    \setlength{\boosttoclabelsepsection}{\boosttoclabelsepleveltwo}
    \setlength{\boosttoclabelsepsubsection}{\boosttoclabelseplevelthree}
    \setlength{\boosttoclabelsepsubsubsection}{\boosttoclabelseplevelfour}
\fi

\titlecontents{chapter} [\boosttocindentchapter]% [left]
    {\addvspace{\boosttocbeforechapter}}% {above}
    {\boosttocformatchapter\color{boost-color-section-heading}\contentslabel{\boosttoclabelsepchapter}}% {before with label}
    {\boosttocformatchapter\hskip -\boosttocindentchapter}% {before without label}
    {\boosttocformatchapter\hskip 1mm\titlerule*[2mm]{.}\contentspage}% {filler and page}
    [\addvspace{0mm}]% [after]

\titlecontents{section} [\boosttocindentsection]% [left]
    {\addvspace{\boosttocbeforesection}}% {above}
    {\boosttocformatsection\color{boost-color-section-heading}\contentslabel{\boosttoclabelsepsection}}% {before with label}
    {\boosttocformatsection\hskip -\boosttocindentsection}% {before without label}
    {\boosttocformatsection\hskip 1mm\titlerule*[2mm]{.}\contentspage}% {filler and page}
    [\addvspace{0mm}]% [after]

\titlecontents{subsection} [\boosttocindentsubsection]
    {\addvspace{\boosttocbeforesubsection}}
    {\boosttocformatsubsection\color{boost-color-section-heading}\contentslabel{\boosttoclabelsepsubsection}}
    {\boosttocformatsubsection\hskip -\boosttocindentsubsection}
    {\boosttocformatsubsection\hskip 1mm\titlerule*[2mm]{.}\contentspage}

\titlecontents{subsubsection} [\boosttocindentsubsubsection]
    {\addvspace{\boosttocbeforesubsubsection}}
    {\boosttocformatsubsubsection\color{boost-color-section-heading}\contentslabel{\boosttoclabelsepsubsubsection}}
    {\boosttocformatsubsubsection}
    {\boosttocformatsubsubsection\hskip 1mm\titlerule*[2mm]{.}\contentspage}

% For tocdepth: part=level -1; chapter=level 0; section= level 1; etc.
\if@minitoc
    % FIXME Test if minitoc option is true
    \RequirePackage[tight]{minitoc}% (not in medium TeX Live installation)
    \AtBeginDocument{%
        \nomtcpagenumbers%
        \dominitoc%
        \setcounter{tocdepth}{1}
        \setcounter{minitocdepth}{2}%
        \mtcsetrules{*}{off}
        }
\else \if@article
    \AtBeginDocument{
        \setcounter{tocdepth}{3}
    }
\else
    \AtBeginDocument{
        \setcounter{tocdepth}{2}
    }
\fi \fi


%* Typefaces (such as bold, italics etc.)

% package for underlining/emphasizing multiple lines
\RequirePackage[normalem]{ulem}%

\RequirePackage{ifxetex}

\ifxetex
    \RequirePackage{fontspec}
\else
    \RequirePackage[T1]{fontenc}
\fi
\RequirePackage{textcomp}
\RequirePackage{newunicodechar}
\newunicodechar{”}{\textquotedblright}
\newunicodechar{’}{\textquoteright}

\ifxetex
    \defaultfontfeatures{Mapping=tex-text} % To support LaTeX quoting style
    \setmainfont{Times New Roman}
    \setsansfont[Scale=MatchLowercase]{Tahoma}
    \setmonofont[Scale=MatchLowercase]{Courier New}
\else
    \RequirePackage{times}%
\fi%

% character protrusion and font expansion
\ifxetex
\else
    \RequirePackage{microtype} % reduces amount of hyphens
\fi

% hyphenation in `texttt' mode (may not work in all situations)
\DeclareRobustCommand\ttfamily%
{\not@math@alphabet\ttfamily\mathtt%
\fontfamily\ttdefault\selectfont\hyphenchar\font=`\-}

% for Diamond symbol used by nuweb
\RequirePackage{amsfonts}%

% XXX 2010-04-02 Already defined in marvosym.sty
% \RequirePackage{eurosym}
% \RequirePackage[full]{textcomp} % = solution Ulrike et Caignaert (`\EUR')


%* Cross References (automatic referencing)

% verbatim with URL-sensitive line breaks (intended for email addresses,
% hypertext links, directories/paths, etc.)
\RequirePackage[obeyspaces,spaces]{url} % allows spaces as part of file names

\ifxetex
    \urlstyle{sf}
\else
    % Use smaller sans-serif text for URLs.
    \def\url@booststyle{%
        \@ifundefined{selectfont}{\def\UrlFont{\sf}}{\def\UrlFont{\footnotesize\sffamily}}}
    \urlstyle{boost}%
\fi

%% adds an additional page reference to `\ref'
% \RequirePackage[french,english]{varioref}

% Load shared dependencies before hyperref, preserving the class options.
\PassOptionsToPackage{pdfusetitle}{hyperref}
\RequirePackage{boostdocument}
\hypersetup{%
  % bookmarks=true,% make PDF bookmarks
  bookmarksnumbered,% include section numbers
  bookmarksopen=false,% subtrees not expanded
  breaklinks=true,% allow hyperlinks to wrap over lines
  citecolor=boost-color-cite,% color of links to bibliography
  colorlinks=true,% avoid the red boxed around cross-references
  filecolor=boost-color-file,% color of file links
  % hyperindex,% link index to text
  linkcolor=boost-color-link,% color of internal links
  pageanchor=true,% makes an anchor on every page (to be able to make links to pages)
  % pagebackref,% in bibliography: show page numbers where mentioned. backref: show sections
  pdffitwindow=true,% page fit to window when opened
  pdfmenubar=true,% show Acrobat's menu?
  pdfnewwindow=true,% links in new window
  % pdfpagelabels,% display e.g. ii (2 of 40)
  pdfpagemode=UseNone,% how file is opened (thumbnails, ...)
  pdfstartview=Fit,% FitH = fit horizontally -- Fit = whole page
  pdftoolbar=true,% show Acrobat's toolbar?
  plainpages=false,% anchors have formatted form, i.e. ii != 2
  unicode=false,% non-Latin characters in Acrobat's bookmarks
  urlcolor=boost-color-url,% color of external links
}%

% allows the user to typeset a linkable and breakable URL
\newcommand*{\urlw}[1]{%
    \href{http://www.#1}{\nolinkurl{www.#1}}}%

% for literate programming
\IfFileExists{noweb.sty}{% then
    \RequirePackage{noweb}%
    \let\nowebsize=\scriptsize%

    % Noweb is set up never to break chunks across pages. You can get better
    % results by relaxing this constraint
    \def\nwendcode{\endtrivlist \endgroup}%
    \let\nwdocspar=\par%
}%
{% else
    \ClassWarning{boostreport}{`noweb' package not loaded -> some symbols will fail}%
}%


% Define the numprint thousand separator.
% XXX This could be done by defining the correct style per language with
% \renewcommand*\npstyleenglish and \renewcommand*\npstylefrench and passing
% the autolanguage option to numprint, but it doesn't seem to work.
% TODO To be investigated.
\if@french%
    \npthousandsep{.}%
\fi%

% % Typeset SI numbers in color in draft mode
% \if@draft%
%     \sisetup{colorall,color=boost-color-section-heading}%
% \fi%

% % If french, use a dot as digit separator
% \if@french%
%     \sisetup{digitsep=fullstop}
% \fi%

% publishing quality tables
\RequirePackage{array, booktabs}%
\RequirePackage{caption}%

%% FIXME If book
\RequirePackage{makeidx}%
\makeindex % after compiling your LaTeX file, run `makeindex filename'
           % (without a file extension) and compile your LaTeX file again


% Apply the requested language after Babel's begin-document initialization.
\if@french%
    \AddToHook{begindocument/end}{\selectlanguage{french}}%
    \ClassInfo{boostreport}{Using french language}%
\else
    \AddToHook{begindocument/end}{\selectlanguage{english}}%
    \ClassInfo{boostreport}{Using english language}%
\fi%

%% End of class
\endinput % very last line

% This is for the sake of Emacs.
% Local Variables:
% comment-start: "%"
% ispell-local-dictionary: "en"
% time-stamp-format: "%:y/%02m/%02d"
% time-stamp-start: "Provides\\(Class\\|Package\\){[a-zA-Z-]+}\\["
% time-stamp-end: " "
% End:

%% boostreport.cls ends here
