%% boostarticle.cls -- LaTeX2e Boost article class
%
% Copyright (C) 2008-2009 Francesco Pizzolante

%* --[ Identification

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{boostarticle}[2009/12/08 v1.0 Pirilampo article class]

%* --[ Requires
%   - boostreport

%* --[ Options
%   - see the boostreport class for the complete list of options.

\DeclareOption*{
    \PassOptionsToClass{\CurrentOption}{boostreport}}
\ProcessOptions


%* --[ Document Classes (some of the various classes available)

\LoadClass[article]{boostreport}

%% End of package
\endinput % very last line

% This is for the sake of Emacs.
% Local Variables:
% mode: outline-minor
% ispell-local-dictionary: "en_US"
% time-stamp-format: "%:y/%02m/%02d"
% time-stamp-start: "Provides\\(Class\\|Package\\){[a-zA-Z-]+}\\["
% time-stamp-end: " "
% End:

%% boostarticle.cls ends here
