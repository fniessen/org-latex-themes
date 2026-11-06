%% boostbook.cls -- LaTeX2e Boost book class
%
% Copyright (C) 2008-2026 Fabrice Niessen. All rights reserved.

%* Identification

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{boostbook}[2026/11/06 v2.0 Pirilampo book class]

%* Requires

%   - boostreport

%* Options

%   - see the boostreport class for the complete list of options.

\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{boostreport}}
\ProcessOptions

%* Document Classes

\LoadClass[book]{boostreport}

%% End of class
\endinput % very last line

% This is for the sake of Emacs.
% Local Variables:
% mode: outline-minor
% ispell-local-dictionary: "en_US"
% time-stamp-format: "%:y/%02m/%02d"
% time-stamp-start: "Provides\\(Class\\|Package\\){[a-zA-Z-]+}\\["
% time-stamp-end: " "
% End:

%% boostbook.cls ends here
