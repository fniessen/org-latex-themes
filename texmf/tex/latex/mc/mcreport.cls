%% mcreport.cls -- LaTeX2e MC report class
%
% Copyright (C) 2008-2026 Fabrice Niessen. All rights reserved.

%* TODO
%
% - [ ] Review the (XXX) code
% - [ ] Check whether `quote' environment should be replaced by the `mcquote' one
% - [ ] Check whether `mc-bg-color' environment is still needed


%* Identification

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mcreport}[2023/05/23 v1.5 Mission Critical IT report class]


% * --[ Documentation

% See http://en.wikibooks.org/wiki/LaTeX  (= excellent!)


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
%       + `report' (= default),
%       + `book' or
%       + `commercial' (for commercial style documents)
%       + `whitepaper' (for white papers)
%
%   - `final', for removing the DRAFT mentions
%   - `black', for colorizing all titles and links in black only
%   - `nocopyright', for removing the copyright symbol next to MC in the footer
%   - `hidemccomment, do not print mccomments
%   - `anonym', do not print the MC logo and MC in the footer
%   - `minitoc', add a minitoc at each chapter, works only with book style
%   - `french', sets the default document language to French (babel)


%* Declarations

% Check the `ifthen' Package. I use constructs like the following to blend
% in/out certain parts:
% \newboolean{grades}
% \setboolean{grades}{true}
% \ifthenelse{\boolean{grades}}{truepart}{falsepart}

% create new conditionals
\newif\if@article
\newif\if@report
\newif\if@draft
\newif\if@black
\newif\if@commercial
\newif\if@whitepaper
\newif\if@book
\newif\if@nocopyright
\newif\if@mccomment
\newif\if@anonym
\newif\if@minitoc
\newif\if@french
\newif\if@logointhemargin

% new conditionals are let equal to `\iffalse' initially
\@reporttrue
\@drafttrue
\@mccommenttrue

\DeclareOption{article}{%
    \@articletrue%
    \@reportfalse%
    \ClassInfo{mcreport}{Saw option `article'}}
\DeclareOption{report}{%
    \@articlefalse%
    \@reporttrue%
    \ClassInfo{mcreport}{Saw option `report'}}
\DeclareOption{book}{%
    \@articlefalse%
    \@reportfalse%
    \@booktrue%
    \ClassInfo{mcreport}{Saw option `book'}}
\DeclareOption{commercial}{%
    \@commercialtrue%
    \@whitepaperfalse%
    \@articlefalse%
    \@reportfalse%
    \@bookfalse%
    \@logointhemargintrue%
    \ClassInfo{mcreport}{Saw option `commercial'}}
\DeclareOption{whitepaper}{%
    \@whitepapertrue%
    \@commercialfalse%
    \@articlefalse%
    \@reportfalse%
    \@bookfalse%
    \@logointhemargintrue%
    \ClassInfo{mcreport}{Saw option `whitepaper'}}
\DeclareOption{nocopyright}{%
    \@nocopyrighttrue%
    \ClassInfo{mcreport}{Saw option `nocopyright'}}
\DeclareOption{hidemccomment}{%
    \@mccommentfalse%
    \ClassInfo{mcreport}{Saw option `hidemccomment'}}
\DeclareOption{final}{%
    \@draftfalse%
    \ClassInfo{mcreport}{Saw option `final'}}
\DeclareOption{black}{%
    \@blacktrue%
    \ClassInfo{mcreport}{Saw option `black'}}
\DeclareOption{anonym}{%
    \@anonymtrue%
    \@nocopyrighttrue%
    \ClassInfo{mcreport}{Saw option `anonym'}}
\DeclareOption{minitoc}{%
    \if@book%
        \@minitoctrue%
        \ClassInfo{mcreport}{Saw option `minitoc'}
    \else%
        \ClassWarning{mcreport}{the `minitoc' option is ignored because it is only available in book style}%
    \fi}
\DeclareOption{french}{%
    \@frenchtrue%
    \ClassInfo{mcreport}{Saw option `french'}}
\DeclareOption*{% code to be executed for every unknown option
    \PassOptionsToClass{\CurrentOption}{article}%
    \PassOptionsToClass{\CurrentOption}{report}%
    \PassOptionsToClass{\CurrentOption}{book}%
}

\ProcessOptions\relax% execute the options




%** 2.3. Sections

%** 2.4. TOC

%** 2.5. References

%** 3.2. Lists

%** 3.3. Verbatim-like

%** 3.4. Footnotes and marginal notes

%** 3.5. Multiple columns

%* 4. Page layout

%* 5. Tabular

%* 6. Floats

%* 7. Fonts

%* 8. Mathematics

%* 9. Multilingual

%* 10. Graphics

%* 12. Index

%* 13. Bibliography

%* 14. Documentation tools





%* Document Classes (some of the various classes available)

\if@commercial
    \LoadClass[a4paper,oneside,9pt]{article}
\else \if@whitepaper
    \LoadClass[a4paper,oneside,10pt]{article}
\else \if@article
    \LoadClass[a4paper,oneside,11pt]{article}
\else \if@report
    \LoadClass[a4paper,oneside,11pt]{report}
\else
    \LoadClass[a4paper,oneside,11pt]{book}
\fi \fi \fi \fi

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
\if@commercial
    \RequirePackage[%
        a4paper,%
        dvips,% will set `\pdfpagewidth/height' when run with `pdflatex'
        left=3.3cm,%
        right=2.0cm,%
        top=2.0cm,%
        headsep=1.0cm,%
        bottom=2.2cm,%
        bindingoffset=0cm,%
        footnotesep=24pt plus 5pt minus 5pt,
        % showframe,%  --> use showframe package instead?
        % marginparwidth=65pt,%
        % marginratio=1:1,%
        % tmargin=126pt,%
        % height=550pt,%
        % width=400pt,%
    ]{geometry}
    \RequirePackage[nofligs]{verdana}
\else \if@whitepaper
    \RequirePackage[%
        a4paper,%
        dvips,% will set `\pdfpagewidth/height' when run with `pdflatex'
        left=2.3cm,%
        right=1.5cm,%
        top=1.8cm,%
        headsep=1.0cm,%
        bottom=2.2cm,%
        bindingoffset=0cm,%
        footnotesep=24pt plus 5pt minus 5pt,
        % showframe,%  --> use showframe package instead?
        % marginparwidth=65pt,%
        % marginratio=1:1,%
        % tmargin=126pt,%
        % height=550pt,%
        % width=400pt,%
    ]{geometry}
\else
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
        % showframe,%  --> use showframe package instead?
        % marginparwidth=65pt,%
        % marginratio=1:1,%
        % tmargin=126pt,%
        % height=550pt,%
        % width=400pt,%
    ]{geometry}
\fi \fi

% driver-independent color extensions
\RequirePackage[table]{xcolor}

\definecolor{mc-color-brand}{HTML}{1968BA} % blue

\if@black
    \definecolor{mc-color-document-title}{HTML}{000000}
    \definecolor{mc-color-section-heading}{HTML}{000000}
    \definecolor{mc-color-section-in-page-heading}{HTML}{000000}
    \definecolor{mc-color-link}{HTML}{000000}
    \definecolor{mc-color-cite}{HTML}{000000}
    \definecolor{mc-color-file}{HTML}{000000}
    \definecolor{mc-color-url}{HTML}{000000}
\else \if@commercial
    \definecolor{mc-color-document-title}{HTML}{1968BA} % blue
    \definecolor{mc-color-section-heading}{HTML}{000000}
    \definecolor{mc-color-section-in-page-heading}{HTML}{000000}
    \definecolor{mc-color-link}{HTML}{000000}
    \definecolor{mc-color-cite}{HTML}{000000}
    \definecolor{mc-color-file}{HTML}{000000}
    \definecolor{mc-color-url}{HTML}{003399} % darker blue
\else \if@whitepaper
    \definecolor{mc-color-document-title}{HTML}{1968BA} % blue
    \definecolor{mc-color-section-heading}{HTML}{1968BA} % blue
    \definecolor{mc-color-section-in-page-heading}{HTML}{000000}
    \definecolor{mc-color-link}{HTML}{000000}
    \definecolor{mc-color-cite}{HTML}{000000}
    \definecolor{mc-color-file}{HTML}{000000}
    \definecolor{mc-color-url}{HTML}{003399} % darker blue
\else
    \definecolor{mc-color-document-title}{HTML}{1968BA} % blue (XXX)
    \definecolor{mc-color-section-heading}{HTML}{1968BA} % blue (XXX)
    \definecolor{mc-color-section-in-page-heading}{HTML}{000000} % black
    \definecolor{mc-color-link}{HTML}{1968BA} % blue (TOC and intern links) (XXX)
    \definecolor{mc-color-cite}{HTML}{1968BA} % blue
    \definecolor{mc-color-file}{HTML}{003399} % darker blue
    \definecolor{mc-color-url}{HTML}{003399} % darker blue
\fi \fi \fi

\definecolor{shadecolor}{HTML}{33D1FF} % light blue for comments?
\definecolor{darkred}{HTML}{800000}
\definecolor{darkgreen}{HTML}{008000}
\definecolor{darkblue}{HTML}{000080}


%* Definitions (define your own commands etc.)

% Define the author's name for the copyright in the footer.
\newcommand{\mctextlogo}[1]{\def\@mctextlogo{#1}}

% Check if the author's name should be displayed or hidden.
\newcommand{\authorName}{\textsf{\color{black}Fabrice Niessen}}
\if@anonym%
    \mctextlogo{}%
\else%
    \mctextlogo{\authorName}
\fi

\newcommand{\mcbold}[1]{\textbf{#1}}
\newcommand{\mcred}[1]{{\color{mc-color-brand}\mcbold{#1}}}


%* Environments (such as enumerate & itemize)

\newcommand{\mcsquare}{\rule[.35ex]{.5ex}{.5ex}}

% control layout of `itemize', `enumerate', `description'
\RequirePackage{enumitem}% (not in medium TeX Live installation)
\setlist{leftmargin=*,%
    labelsep=1.25cm,%
    itemindent=0pt,%
    topsep=5pt,%
    parsep=3pt}
\setitemize[1]{label=\mcsquare}
\setdescription{%
%     style=nextline,
    font=\sffamily\bfseries,%
    labelwidth=0pt,
    labelsep=0.5em,
    leftmargin=1.45cm}

% In the commercial style, override some labelsep
\if@commercial
    \setitemize{labelsep=6mm}
    \setenumerate{labelsep=5mm}
\fi

\if@whitepaper
    \setitemize{labelsep=6mm}
    \setenumerate{labelsep=5mm}
\fi


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

% verb/verbatim in footnotesize (and darkgreen)
\renewcommand{\verbatim@font}{%
    \ttfamily
    % \scriptsize
%     \color{darkgreen}
    }

% allow wrapping of source table in LaTeX (see Emacs Org-mode's table editor)
\usepackage{comment}% (not in medium TeX Live installation)

% smaller font size and colored background for quotes
\renewenvironment{quote}
{\list{}{\rightmargin\leftmargin}%
\item\relax\small\begin{mc-bg-color}}
    {\end{mc-bg-color}\endlist}

\newsavebox{\mcquotationauthor}
\newenvironment{mcquotation}[1]{
    \ifstrempty{#1}{}{\sbox{\mcquotationauthor}{\parbox[b]{0.85\linewidth}{\raggedleft\footnotesize#1}}}%
    \vskip 5mm
    \begin{center}
        \begin{minipage}{0.85\linewidth}
            \em
}{
            \vskip 4mm
            \usebox{\mcquotationauthor}
        \end{minipage}
    \end{center}
    \vskip 5mm
}

% `\textcolor' chokes when it wraps multiple paragraphs
\definecolor{myblue}{HTML}{CCCCFF}

\newenvironment{mc-bg-color}
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

\newenvironment{mc-fg-color}[1]%
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
% instead of:
%     \setlength{\parskip}{12pt}
%     \setlength{\parindent}{0in}


%* Margin Notes (putting remarks in the margin)

\RequirePackage{framed}% for `shaded' environment
\RequirePackage{fancybox}

\reversemarginpar
\setlength\marginparwidth{115pt}
\setlength\marginparsep{20pt}

\newenvironment{mcnote}
    {\begin{list}{}{%
    \setlength{\leftmargin}{.15\linewidth}%
    \setlength{\rightmargin}{\leftmargin}}%
    \small\sffamily\item}
    {\end{list}}

% note | important| warning | caution | tip


%* Page Styles (various styles of page layout)

% make the title appear in sans serif font and in color
\let\orig@title\title

\if@commercial%
    \renewcommand{\title}[1]{%
        \orig@title{\fontfamily{verdana}\selectfont#1}}
\else%
    \renewcommand{\title}[1]{%
        \orig@title{\textsf{#1}}}
\fi%

% Define subtitle

% Properly clear the global variables and commands
% (is is more a convention to prevent confusion with
% symbols defined at other scopes)
\global\let\@subtitle\@empty
\global\let\subtitle\relax

% Define the subtitle variable and initialize it
\newcommand{\subtitle}[1]{\def\@subtitle{#1}}
\subtitle{}

% To customize the MC logo displayed in the title page, simply call the
% \mctitlegraphic{XXX} command.
%\DeclareRobustCommand{\mctitlegraphic}[1]{\def\@mctitlegraphic{#1}}
\newcommand{\mctitlegraphic}[1]{\def\@mctitlegraphic{#1}}
\if@anonym%
    \mctitlegraphic{}
\else \if@commercial%
    \mctitlegraphic{}
\else%
    \mctitlegraphic{}
\fi \fi%

% \logo and \titlegraphic define client logo and title graphics.
% By default, \logo also defines the titlegraphic.
\newcommand{\logo}[1]{\def\@logo{#1}\def\@titlegraphic{#1}}
\logo{}

\newcommand{\titlegraphic}[1]{\def\@titlegraphic{#1}}
\titlegraphic{}

% To customize the small MC logo (displayed in the left margin in the
% commercial style), simply call the \mclogo{XXX} command.
\newcommand{\mclogo}[1]{\def\@mclogo{#1}}
\if@anonym%
    \mclogo{}
\else%
    \mclogo{\includegraphics[width=1cm]{MC}}
\fi%

% changing margins "on the fly" (in mid document)
\newenvironment{mcchangemargin}[2]%
    {\begin{list}{}{%
        \setlength{\topsep}{0pt}%
        \setlength{\leftmargin}{#1}%
        \setlength{\rightmargin}{#2}%
        \setlength{\listparindent}{\parindent}%
        \setlength{\itemindent}{\parindent}%
        \setlength{\parsep}{\parskip}%
    }\item[]}%
    {\end{list}}

% TODO Plutôt que la commande \maketitle, qui est assez peu "customisable",
% utiliser l'environnement titlepage...
%
\if@commercial
    \renewcommand{\maketitle}{%
        \thispagestyle{plain}%
        \begin{center}
            \@mctitlegraphic
            \vskip 5mm
            {\huge \color{mc-color-document-title}\textbf{\@title}\par}%
            \ifx \@subtitle \@empty%
                \relax
            \else%
                {\normalsize\bfseries\@subtitle}
            \fi%
            \vskip 1cm
        \end{center}%
}
\else \if@whitepaper
    \renewcommand{\maketitle}{%
        \thispagestyle{plain}%
        \\
        \textbf{For more information, contact:} \\
        Michel Vanden Bossche-Marquette, Co-Founder \& CEO \\
        Mission Critical IT \\
        \url{mailto:mvb@missioncriticalit.com} or +32 2-757.10.15

        \textbf{For Immediate Release}
        \begin{center}
            \vskip 5mm
            {\LARGE \color{mc-color-document-title}\textbf{\@title}\par}%
            \ifx \@subtitle \@empty%
                \relax
            \else%
                {\small\@subtitle}
            \fi%
            \vskip 1cm
        \end{center}%
}
\else \if@article
    \renewcommand{\maketitle}{%
        \thispagestyle{plain}
         \begin{center}
             \@titlegraphic\par
             {\Huge \color{mc-color-document-title}\textbf{\@title}\par}%
             \vskip 5mm
             {\large \@author\par}%
             {\large \@date\par}%
         \end{center}
     }
\else
\renewcommand{\maketitle}{%
    \thispagestyle{empty}%
    \begin{mcchangemargin}{-3.5cm}{0cm}% TODO Abstract it: add to mc lengths!
        % amounts added to left and right margins:
        % \newlength{\mylen}
	% \setlength{\mylen}{1em plus 0.5em minus 0.5em}
        % \addtolength{\mylen}{-3.5cm}

        % \newlength{\colonnegauche}
        % \newlength{\colonnedroite}
        % \newlength{\milieu}
        % \newlength{\margegauche}
        % \newlength{\margedroite} % ne sert que pour les calculs

        % \begin{document}
        %% Les \setlength doivent figurer après le \begin{document} pour que
        %% \linewidth ait sa vraie valeur. calc permet de donner facilement des
        %% dimensions qui répondent à des critères complexes. Par exemple,
        %% ici, je voulais que la reliure fasse la somme des marges et que la
        %% colonne de droite prenne 60% de l'espace restant. Il ne reste donc
        %% plus qu'à fixer en dur les deux marges.
        %     \setlength{\margegauche}{1cm}%
        % \setlength{\margedroite}{1cm}%
        % \setlength{\milieu}{\margegauche+\margedroite}%
        % \setlength{\colonnegauche}{%
        % (\linewidth-\margedroite-\margegauche-\milieu)*\real{0.6}}
        % \setlength{\colonnedroite}{%
        % \linewidth-\margedroite-\margegauche-\milieu-\colonnegauche}

        \begin{center}
            \leavevmode
            \@titlegraphic\par
            \vspace{\stretch{2}}
            \normalfont
            {\Huge \color{mc-color-document-title}\textbf{\@title}\par}%
            \vskip 5mm
            \if@book
            \else
                {\large \@author\par}%
            \fi
            \vskip 2mm
            {\large \@date\par}%
            \vspace{\stretch{3}}
            \@mctitlegraphic
        \end{center}%
        % {\tiny
        % Author: svnauthor \\
        % Revision: svnrev \\
        % Last changed on: svndate \\
        % URL: \url{svnkw{HeadURL}}
        % }
    \end{mcchangemargin}
    \null
    \clearpage
}
\fi \fi \fi
% TODO Put a document log in every report...


% extensive control of page headers and footers
\RequirePackage{fancyhdr} % must be loaded after `geometry'
\ClassInfo{mcreport}{Using fancier footers than usual}

\newcommand{\footfont}{
\if@commercial
    \fontsize{7pt}{0pt}\fontfamily{verdana}\selectfont
\else
    \fontsize{7pt}{0pt}\sffamily\selectfont
\fi
}
\newcommand{\headfont}{
\if@commercial
    \fontsize{8pt}{8pt}\fontfamily{verdana}\selectfont
\else
    \fontsize{8pt}{8pt}\sffamily\selectfont
\fi
}

% MC page headers definition
\newcommand{\mcheadl}{
    \if@logointhemargin
        \hskip -2cm
        \raisebox{-7mm}[0mm][-7mm]{\@mclogo}\hskip 1cm
    \else
        \headfont\textsc{\@title}
    \fi}
\newcommand{\mcheadr}{\headfont%
    \if@commercial
        \textsc{\@title}%
    \else \if@whitepaper
        \@title%
    \else \if@article
        \@subtitle%
    \else
        \leftmark%
    \fi \fi \fi}
\newcommand{\mcheadc}{}

\newcommand{\mccopyright}{%
    \if@nocopyright
        \relax
    \else
        \copyright~
    \fi
}

% MC page footers definition
\if@whitepaper
    \newcommand{\mcfootl}{}
    \newcommand{\mcfootc}{\footfont%
        \color{mc-color-section-heading}%
        \textbf{Mission Critical IT \textbullet} \url{www.missioncriticalit.com}\\
        a division of Information Systems Consult S.A. 0425.189.602\\
        \textbf{Corporate Office Belgium --} Square de Mee\^us, 38-40 B-1000 Brussels \textbullet\, Phone +32 2 757 10 15\\
        \textbf{Development Office Australia --} 208 Capel Street, North Melbourne, 3051 Victoria \textbullet\, Phone +61 424 651 834}
    \newcommand{\mcfootr}{}
\else
    \newcommand{\mcfootl}{\footfont\raisebox{0.25mm}[0mm][-0.25mm]{\mccopyright}\@mctextlogo}
    \newcommand{\mcfootc}{\footfont\@date
      \if@draft
      \\\bf -- DRAFT --
      \fi}
    \newcommand{\mcfootr}{\footfont\thepage}
\fi


\fancypagestyle{empty}{%
    \fancyhf{} % clear all header and footer fields
    \renewcommand{\headrulewidth}{0.0pt}
    \renewcommand{\footrulewidth}{0.0pt}
}

\fancypagestyle{plain}{%
    \fancyhf{} % clear all header and footer fields
    \if@commercial
    \else \if@whitepaper
    \else
        \fancyhfoffset[L]{2.5cm} % offset to be applied to the header/footer
    \fi \fi
    \renewcommand{\headrulewidth}{0.0pt}
    \fancyfoot[L]{\mcfootl{}}
    \fancyfoot[C]{\mcfootc{}}
    \fancyfoot[R]{\mcfootr{}}
    \if@whitepaper
    \renewcommand{\footrulewidth}{0.0pt}
    \else
    \renewcommand{\footrulewidth}{0.4pt}
    \fi
}

% TODO Put the headers and footers in some gray (#BBC9C9)
\fancypagestyle{headings}{%
    \fancyhf{} % clear all header and footer fields
    \if@commercial
    \else \if@whitepaper
    \else
        \fancyhfoffset[L]{2.5cm} % offset to be applied to the header/footer
    \fi \fi
    \fancyhead[L]{\mcheadl{}}
    \fancyhead[R]{\mcheadr{}}
    \fancyhead[C]{\mcheadc{}}
    \renewcommand{\headrulewidth}{0.4pt}
    \fancyfoot[L]{\mcfootl{}}
    \if@whitepaper
        \fancyfoot[C]{\footfont\thepage}
    \else
        \fancyfoot[C]{\mcfootc{}}
    \fi
    \fancyfoot[R]{\mcfootr{}}
    \if@whitepaper
        \renewcommand{\footrulewidth}{0.0pt}
    \else
        \renewcommand{\footrulewidth}{0.4pt}
    \fi
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
    \color{mc-color-section-in-page-heading}\textsf{#1}}


%* Sectioning (how to section properly)

% \renewcommand\part{%
%     \if@openright
%     \cleardoublepage
%     \else
%     \clearpage
%     \fi
%     \thispagestyle{empty}% was `plain'
%     \if@twocolumn
%     \onecolumn
%     \@tempswatrue
%     \else
%     \@tempswafalse
%     \fi
%     \null\vfil
%     \secdef\@part\@spart}

%%     \newcommand{\partfont}{%
%%     \fontencoding{\encodingdefault}\fontfamily{phv}%
%%     \fontseries{bc}\fontshape{n}%
%%     \fontsize{32}{38}%
%%     \selectfont}

%%     \DeclareFixedFont{\partnumfont}{T1}{phv}{bc}{n}{80}%

%     \def\@part[#1]#2{%
%     \ifnum \c@secnumdepth >-2\relax
%     \refstepcounter{part}%
%     \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
%     \else
%     \addcontentsline{toc}{part}{#1}%
%     \fi
%     \markboth{}{}%
%     {\centering
%     \interlinepenalty \@M
%     \normalfont
%     \ifnum \c@secnumdepth >-2\relax
%     \fontsize{80}{96}\selectfont \thepart % juste le numéro de la partie
%     \par
%     \vskip 50\p@% 50 point au lieu de 20...
%     \fontsize{32}{38}\selectfont #2\par}% le titre avec une fonte personnalisée
%     \@endpart}

%     \def\@spart[#1]#2{%
%     \ifnum \c@secnumdepth >-2\relax
%     \refstepcounter{part}%
%     \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
%     \else
%     \addcontentsline{toc}{part}{#1}%
%     \fi
%     \markboth{}{}%
%     {\centering
%     \interlinepenalty \@M
%     \normalfont
%     \ifnum \c@secnumdepth >-2\relax
%     \fontsize{80}{96}\selectfont \thepart % juste le numéro de la partie
%     \par
%     \vskip 50\p@% 50 point au lieu de 20...
%     \fontsize{32}{38}\selectfont #2\par}% le titre avec une fonte personnalisée
%     \@endpart}


% control sectional headers
\RequirePackage{sectsty}% (not in medium TeX Live installation)
% redefine the font used for all section headings
\if@commercial
    \allsectionsfont{\usefont{T1}{verdana}{b}{n}\selectfont% Verdana Bold
        \color{mc-color-section-heading}% make all section headings colored
        \nobreak}% because `\color' inserts a breakpoint
\else
    \allsectionsfont{\usefont{T1}{phv}{b}{n}\selectfont% Helvetica-Narrow Bold
        \color{mc-color-section-heading}% make all section headings colored
        \nobreak}% because `\color' inserts a breakpoint
\fi

% select alternative section titles
\RequirePackage[compact]{titlesec}% (not in medium TeX Live installation)
\if@commercial
    \titlespacing{\section}{-0.8cm}{10pt}{*0} % left, beforesep, aftersep
    \titlespacing{\subsection}{-0.8cm}{10pt}{*0}
    \titlespacing{\subsubsection}{-0.8cm}{10pt}{*0}
    \titleformat{\section}
        {\fontsize{12pt}{14pt}\selectfont\bfseries}
        {\thesection.}
        {3mm}
        {}
    \titleformat{\subsection}
        {\fontsize{10pt}{10pt}\selectfont\bfseries}
        {\thesubsection.}
        {3mm}
        {}
    % redefine the sectioning commands to get rid of spurious space after them
    % caused by the `parskip' package
\else \if@whitepaper
        \titlespacing{\section}{-0.8cm}{10pt}{*0} % left, beforesep, aftersep
        \titlespacing{\subsection}{-0.8cm}{10pt}{*0}
        \titlespacing{\subsubsection}{-0.8cm}{10pt}{*0}
        \titleformat{\section}
        {\fontsize{15pt}{18pt}\selectfont\sffamily\bfseries\color{mc-color-section-heading}}
        {\thesection.}
        {3mm}
        {}
        \titleformat{\subsection}
        {\fontsize{12pt}{14.4pt}\selectfont\sffamily\bfseries\color{mc-color-section-heading}}
        {\thesubsection.}
        {1mm}
        {}
        % redefine the sectioning commands to get rid of spurious space after them
        % caused by the `parskip' package
\else % article, report or book
    \titlespacing{\section}      {-2.50cm}{12pt}{9pt} % left, beforesep, aftersep
    \titlespacing{\subsection}   {-1.38cm}{12pt}{6pt}
    \titlespacing{\subsubsection}{-0.5cm}{12pt}{4pt}
\fi \fi

% Use small, stepped title offsets inside landscape pages only.
\AddToHook{env/landscape/begin}[mcreport-landscape-title-spacing]{%
    \titlespacing*{\chapter}{-0.4cm}{50pt}{\ttl@chapafter}%
    \if@commercial
        \titlespacing{\section}{-0.3cm}{10pt}{*0}%
        \titlespacing{\subsection}{-0.2cm}{10pt}{*0}%
        \titlespacing{\subsubsection}{-0.1cm}{10pt}{*0}%
    \else \if@whitepaper
        \titlespacing{\section}{-0.3cm}{10pt}{*0}%
        \titlespacing{\subsection}{-0.2cm}{10pt}{*0}%
        \titlespacing{\subsubsection}{-0.1cm}{10pt}{*0}%
    \else
        \titlespacing{\section}{-0.3cm}{12pt}{9pt}%
        \titlespacing{\subsection}{-0.2cm}{12pt}{6pt}%
        \titlespacing{\subsubsection}{-0.1cm}{12pt}{4pt}%
    \fi \fi
}

% Defining the format of a paragraph heading (we want a line break).
% Note: needed to redifine the whole font as when using the titleformat
% command for the paragraph, the font selection done with allsectionsfont was
% lost.
\titleformat{\paragraph}[hang]
   {\usefont{T1}{phv}{b}{n}\selectfont\color{mc-color-section-heading}\nobreak\bfseries}
   {}
   {}
   {}
\titlespacing{\paragraph}{0pt}{0pt}{*0}

% Chapter header
\titleformat{\chapter}[hang]% shape
    {\fontsize{20pt}{24pt}\selectfont\sffamily\bfseries%
    \color{mc-color-section-heading}\vspace{30pt}}% fmt
    {\thechapter.}% label (heading number)
    {2mm}% sep
    {}% bef
    [{\titlerule[2.5pt]}]% aft

% How is 24pt chosen in `\fontsize{20pt}{24pt}\selectfont'?
% It is the baselineskip. A good value depends on the look of the font but
% 1.2 * size of the font is generally OK.

\if@commercial
\else \if@whitepaper
\else
\def\@seccntformat#1{%
    \expandafter%
    \ifx\csname#1\endcsname\section
        \thesection.\quad % new definition only for `\section'
    \else
        \csname the#1\endcsname\quad % new definition for the others
    \fi
}
\fi \fi

%% TODO Replace the previous by this?
% \titleformat{\section}
% {\normalfont\Large\bfseries}{\thesection.}{1em}{}

% discourage widows and orphans
\widowpenalty=10000 % no widow lines (default value: 150)
\clubpenalty=10000 % no orphan lines ("club lines" in LaTeX terminology, default value: 150)

% It also helps to have rubber band values for the space between paragraphs:
% \setlength{\parskip}{3ex plus 2ex minus 2ex}


%* Spaces & Boxes (all the associated commands)

% set space between lines
\RequirePackage{setspace}
\setstretch{1.2}

% customize footnotes
\usepackage[flushmargin]{footmisc}% (not in medium TeX Live installation)
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
%\RequirePackage[toc]{multitoc}

% Define TOC indentations
\newlength{\mctocindentlevelone}
\newlength{\mctocindentleveltwo}
\newlength{\mctocindentlevelthree}
\newlength{\mctocindentlevelfour}
\setlength{\mctocindentlevelone}{7mm}
\setlength{\mctocindentleveltwo}{19mm}
\setlength{\mctocindentlevelthree}{32mm}
\setlength{\mctocindentlevelfour}{41mm}

\newlength{\mctocbeforelevelone}
\newlength{\mctocbeforeleveltwo}
\newlength{\mctocbeforelevelthree}
\newlength{\mctocbeforelevelfour}
\setlength{\mctocbeforelevelone}{6mm}
\setlength{\mctocbeforeleveltwo}{3mm}
\setlength{\mctocbeforelevelthree}{0mm}
\setlength{\mctocbeforelevelfour}{0mm}

\newlength{\mctoclabelseplevelone}
\newlength{\mctoclabelsepleveltwo}
\newlength{\mctoclabelseplevelthree}
\newlength{\mctoclabelseplevelfour}
\setlength{\mctoclabelseplevelone}{7mm}
\setlength{\mctoclabelsepleveltwo}{11mm}
\setlength{\mctoclabelseplevelthree}{13mm}
\setlength{\mctoclabelseplevelfour}{13mm}

\newlength{\mctocindentchapter}
\newlength{\mctocindentsection}
\newlength{\mctocindentsubsection}
\newlength{\mctocindentsubsubsection}

\newlength{\mctocbeforechapter}
\newlength{\mctocbeforesection}
\newlength{\mctocbeforesubsection}
\newlength{\mctocbeforesubsubsection}

\newlength{\mctoclabelsepchapter}
\newlength{\mctoclabelsepsection}
\newlength{\mctoclabelsepsubsection}
\newlength{\mctoclabelsepsubsubsection}

% Define TOC formats
\newcommand{\mctocformatlevelone}{\sffamily\Large\bfseries}
\newcommand{\mctocformatleveltwo}{\sffamily\large}
\newcommand{\mctocformatlevelthree}{\sffamily}
\newcommand{\mctocformatlevelfour}{\sffamily}

\setlength{\mctocindentchapter}{\mctocindentlevelone}
\newcommand{\mctocformatchapter}{\mctocformatlevelone}
\setlength{\mctocbeforechapter}{\mctocbeforelevelone}
\setlength{\mctoclabelsepchapter}{\mctoclabelseplevelone}
\if@article
    \setlength{\mctocindentsection}{\mctocindentlevelone}
    \setlength{\mctocindentsubsection}{\mctocindentleveltwo}
    \setlength{\mctocindentsubsubsection}{\mctocindentlevelthree}
    \newcommand{\mctocformatsection}{\mctocformatlevelone}
    \newcommand{\mctocformatsubsection}{\mctocformatleveltwo}
    \newcommand{\mctocformatsubsubsection}{\mctocformatlevelthree}
    \setlength{\mctocbeforesection}{\mctocbeforelevelone}
    \setlength{\mctocbeforesubsection}{\mctocbeforeleveltwo}
    \setlength{\mctocbeforesubsubsection}{\mctocbeforelevelthree}
    \setlength{\mctoclabelsepsection}{\mctoclabelseplevelone}
    \setlength{\mctoclabelsepsubsection}{\mctoclabelsepleveltwo}
    \setlength{\mctoclabelsepsubsubsection}{\mctoclabelseplevelthree}
\else
    \setlength{\mctocindentsection}{\mctocindentleveltwo}
    \setlength{\mctocindentsubsection}{\mctocindentlevelthree}
    \setlength{\mctocindentsubsubsection}{\mctocindentlevelfour}
    \newcommand{\mctocformatsection}{\mctocformatleveltwo}
    \newcommand{\mctocformatsubsection}{\mctocformatlevelthree}
    \newcommand{\mctocformatsubsubsection}{\mctocformatlevelfour}
    \setlength{\mctocbeforesection}{\mctocbeforeleveltwo}
    \setlength{\mctocbeforesubsection}{\mctocbeforelevelthree}
    \setlength{\mctocbeforesubsubsection}{\mctocbeforelevelfour}
    \setlength{\mctoclabelsepsection}{\mctoclabelsepleveltwo}
    \setlength{\mctoclabelsepsubsection}{\mctoclabelseplevelthree}
    \setlength{\mctoclabelsepsubsubsection}{\mctoclabelseplevelfour}
\fi

\titlecontents{chapter} [\mctocindentchapter]% [left]
    {\addvspace{\mctocbeforechapter}}% {above}
    {\mctocformatchapter\color{mc-color-section-heading}\contentslabel{\mctoclabelsepchapter}}% {before with label}
    {\mctocformatchapter\hskip -\mctocindentchapter}% {before without label}
    {\mctocformatchapter\hskip 1mm\titlerule*[2mm]{.}\contentspage}% {filler and page}
    [\addvspace{0mm}]% [after]

\titlecontents{section} [\mctocindentsection]% [left]
    {\addvspace{\mctocbeforesection}}% {above}
    {\mctocformatsection\color{mc-color-section-heading}\contentslabel{\mctoclabelsepsection}}% {before with label}
    {\mctocformatsection\hskip -\mctocindentsection}% {before without label}
    {\mctocformatsection\hskip 1mm\titlerule*[2mm]{.}\contentspage}% {filler and page}
    [\addvspace{0mm}]% [after]

\titlecontents{subsection} [\mctocindentsubsection]
    {\addvspace{\mctocbeforesubsection}}
    {\mctocformatsubsection\color{mc-color-section-heading}\contentslabel{\mctoclabelsepsubsection}}
    {\mctocformatsubsection\hskip -\mctocindentsubsection}
    {\mctocformatsubsection\hskip 1mm\titlerule*[2mm]{.}\contentspage}

\titlecontents{subsubsection} [\mctocindentsubsubsection]
    {\addvspace{\mctocbeforesubsubsection}}
    {\mctocformatsubsubsection\color{mc-color-section-heading}\contentslabel{\mctoclabelsepsubsubsection}}
    {\mctocformatsubsubsection}
    {\mctocformatsubsubsection\hskip 1mm\titlerule*[2mm]{.}\contentspage}

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

% \RequirePackage[scaled=.90]{helvet}
% \RequirePackage{courier}

%% use regular Times at least (even if not Times New Roman)
% \RequirePackage{mathptmx} % supersedes `times' (sets the text font
%                           % to times *and* the math font to times)

\ifxetex
    \defaultfontfeatures{Mapping=tex-text} % To support LaTeX quoting style
    \setmainfont{Times New Roman}
    \setsansfont[Scale=MatchLowercase]{Tahoma}
    \setmonofont[Scale=MatchLowercase]{Courier New}
\else
    \if@whitepaper%
        \RequirePackage{lmodern}%
    \else%
        \RequirePackage{times}%
    \fi%
\fi%

\if@commercial%
    \AtBeginDocument{%
        \fontfamily{vnax}\fontsize{9pt}{2ex}\selectfont%
    }%
\fi%
% Is the purpose of a business plan to attract investors or convince a bank or
% something? If it was, I'd probably change the typeface selection so that it
% wasn't all in `Times'. Nothing radical, but maybe a slightly more flavorful
% sans serif for headings, and a serif body typeface with a tiny bit more
% character. Could be for example `Frutiger' and `Baskerville'. STILL PRETTY
% RESTRAINED, JUST NOT IDENTICAL TO MOST OF THE BUSINESS PLANS THEY SEE.

%% use scalable, PostScript Type 1 versions of the Computer Modern fonts
% \RequirePackage{type1cm}

%% replace the standard Computer Modern Typewriter font LaTeX uses for
%% monospace text with the PostScript font Adobe Courier
% \RequirePackage{courier}

%% enable dingbat lists and symbols
% \RequirePackage{pifont}


% character protrusion and font expansion
\ifxetex
\else
    \RequirePackage{microtype} % reduces amount of hyphens
\fi
% \RequirePackage[babel=true,kerning=true]{microtype}

% hyphenation in `texttt' mode (may not work in all situations)
\DeclareRobustCommand\ttfamily%
{\not@math@alphabet\ttfamily\mathtt%
\fontfamily\ttdefault\selectfont\hyphenchar\font=`\-}

% for Diamond symbol used by nuweb
% \RequirePackage{latexsym}
\RequirePackage{amsfonts}%

% XXX 2010-04-02 Already defined in marvosym.sty
% \RequirePackage{eurosym}
% \RequirePackage[full]{textcomp} % = solution Ulrike et Caignaert (`\EUR')


%* Cross References (automatic referencing)

% pour une url: \href{http://moi.com}{c'est moi} ou \url{http://perdu.com} Il
% faut le paquet hyperref

% verbatim with URL-sensitive line breaks (intended for email addresses,
% hypertext links, directories/paths, etc.)
\RequirePackage[obeyspaces,spaces]{url} % allows spaces as part of file names
% check out how to change the url font

\ifxetex
    \urlstyle{sf}
\else
% define a new `mc' style for the package that will use a smaller font
\def\url@mcstyle{%
\@ifundefined{selectfont}{\def\UrlFont{\sf}}{\def\UrlFont{\footnotesize\sffamily}}} % (XXX)
% now, actually use the newly defined style
\urlstyle{mc}%
\fi

%% adds an additional page reference to `\ref'
% \RequirePackage[french,english]{varioref}

% hyperref
\RequirePackage[pdfusetitle]{hyperref}%
\hypersetup{%
  % bookmarks=true,% make PDF bookmarks
  bookmarksnumbered,% include section numbers
  bookmarksopen=false,% subtrees not expanded
  breaklinks=true,% allow hyperlinks to wrap over lines
  citecolor=mc-color-cite,% color of links to bibliography
  colorlinks=true,% avoid the red boxed around cross-references
  filecolor=mc-color-file,% color of file links
  % hyperindex,% link index to text
  linkcolor=mc-color-link,% color of internal links
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
  urlcolor=mc-color-url,% color of external links
}%

%% We'll use the url{} command from the url package to typeset filenames
%% (unlike \texttt{}, it allows hyphenation and line breaks, which is good --
%% filenames can sometimes be long, and \texttt{alongfilename} = overfull
%% hboxes (eg. stuff sticking out in the margins).
% \RequirePackage[hyphens]{url}
%% But, since hyperref redefines \Url, let's make an opaque copy of the
%% command before loading hyperref
% \let\noHyperUrl\Url

% \let\orig@url\url
% \renewcommand{\url}[1]{%
% {\fontsize{10.7pt}{13.05pt}\orig@url{#1}}}

% Find solutions in nolbreaks.sty.

% allows the user to typeset a linkable and breakable URL
\newcommand*{\urlw}[1]{%
    \href{http://www.#1}{\nolinkurl{www.#1}}}%

% for literate programming
\IfFileExists{noweb.sty}{% then
    \RequirePackage{noweb}%
    \let\nowebsize=\scriptsize%
    %     \noweboptions{smallcode}

    % Noweb is set up never to break chunks across pages. You can get better
    % results by relaxing this constraint
    \def\nwendcode{\endtrivlist \endgroup}%
    \let\nwdocspar=\par%
}%
{% else
    \ClassWarning{mcreport}{`noweb' package not loaded -> some symbols will fail}%
}%


% mcdocument
\RequirePackage{mcdocument}%

% For commercial style keep original definition of href
\if@commercial%
    \renewcommand\href[2]{\orig@href{#1}{#2}}% href
\fi%

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
%     \sisetup{colorall,color=mc-color-section-heading}%
% \fi%

% % If french, use a dot as digit separator
% \if@french%
%     \sisetup{digitsep=fullstop}
% \fi%

% publishing quality tables
\RequirePackage{array, booktabs}%
\RequirePackage{caption}%

\RequirePackage{colortbl}%
% \rowcolor[HTML]{99CCFF} = light blue

% From the Visual FAQ:
% \RequirePackage{etex}
% \RequirePackage{lastpage}
% \RequirePackage{lettrine}
% \RequirePackage{tabularx}
% \RequirePackage{supertabular}
% \let\STtopcaption=\topcaption
% \let\topcaption=\relax
% \RequirePackage{topcapt}
% \RequirePackage{layout}
% \RequirePackage{wrapfig}
% \RequirePackage{amsmath}
% \RequirePackage{amssymb}
% \RequirePackage{mathrsfs}
% \RequirePackage{texnames}
% \RequirePackage{bold-extra}
% \RequirePackage{slashbox}
% \RequirePackage{multirow}
% \RequirePackage{afterpage}
% \RequirePackage{eso-pic}
% \RequirePackage{calc}
% \RequirePackage{multicol}
% \RequirePackage{rotating}
% \RequirePackage{fancyvrb}
% \RequirePackage{cancel}
% \RequirePackage{amsthm}
% \RequirePackage{cooltooltips}

% \RequirePackage{textpos} % placement of boxes at absolute positions (for posters)

% withpage
% I find `glossaries' to be the best by far

%% FIXME If book
\RequirePackage{makeidx}%
\makeindex % after compiling your LaTeX file, run `makeindex filename'
           % (without a file extension) and compile your LaTeX file again


% Sometimes TeX allows a line to extend past the right margin. This is an
% aesthetic decision on the part of TeX's author. The amount is determined by
% the \hfuzz parameter, which defaults to 0.1 pt. If the text does not fit
% within the line, the \tolerance parameter determines how TeX will handle the
% overfull \hbox. The default value of \tolerance is 200. Setting \tolerance
% to 1000 suppresses overfull \hbox warnings and the printing of slugs.


\if@french%
    \AtBeginDocument{\selectlanguage{french}}%
    \ClassInfo{mcreport}{Using french language}%
\else % This is a workaround as when you pass the 'english' option you get the
      % labels in french. This is due to the fact that babel will load the
      % english language first and thus, the french language will become the
      % default one.
    \AtBeginDocument{\selectlanguage{english}}%
    \ClassInfo{mcreport}{Using english language}%
\fi%

% > Je cherche à utiliser un nouveau package à savoir "dropping", qui
% > permet de produire la première lettre d'un nouveau paragraphe en
% > taille supérieure.
% Prends lettrine.

%% FIXME Beep at end of compilation
% \AtEndDocument{\typeout{$'\a'}}

%% End of package
\endinput % very last line

% This is for the sake of Emacs.
% Local Variables:
% comment-start: "%"
% ispell-local-dictionary: "en"
% time-stamp-format: "%:y/%02m/%02d"
% time-stamp-start: "Provides\\(Class\\|Package\\){[a-zA-Z-]+}\\["
% time-stamp-end: " "
% End:

%% mcreport.cls ends here
