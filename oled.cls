%% oled.cls — a pitch-black LaTeX class for OLED screens.
%%
%% Pure black page (#000000), white text. Every style decision lives in this
%% file, so a document only needs `\documentclass{oled}`.
%%
%% Options: everything is passed on to `article` (e.g. `11pt`, `letterpaper`,
%%          `twocolumn`). The default is A4 paper, 10pt.
%%
%% Palette (redefine with \colorlet after \documentclass if you like):
%%   oledbg oledfg oledmuted oledaccent oledgreen oledamber oledpurple oledred
%%
%% Environments: theorem, definition, example, remark   (optional [title])
%%               topic[<colour>]{<title>}              (general, title only)
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{oled}[2026/09/19 v1.0 Pitch-black class for OLED screens]

% ---------------------------------------------------------------- base class
\PassOptionsToClass{a4paper}{article}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

% --------------------------------------------------------------------- fonts
\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage[T1]{fontenc}
  \RequirePackage{lmodern}
\else
  \RequirePackage{fontspec}
\fi
\RequirePackage{microtype}

% ---------------------------------------------------------------------- math
\RequirePackage{amsmath, amssymb, mathtools}

% -------------------------------------------------------------------- colours
\RequirePackage{xcolor}
\definecolor{oledbg}{HTML}{000000}      % pure black: OLED pixels switched off
\definecolor{oledfg}{HTML}{FFFFFF}      % text
\definecolor{oledmuted}{HTML}{8C8C8C}   % rules, secondary text
\definecolor{oledaccent}{HTML}{5CC8FF}  % headings, links, bullets
\definecolor{oledgreen}{HTML}{7EE787}
\definecolor{oledamber}{HTML}{FFB454}
\definecolor{oledpurple}{HTML}{D2A8FF}
\definecolor{oledred}{HTML}{FF7B72}

% Set in the preamble so xcolor records white as the *default* colour; floats,
% footnotes and boxes reset to that default, not to whatever is current.
\pagecolor{oledbg}
\color{oledfg}

% ----------------------------------------------------------- page & paragraph
\RequirePackage[margin=7mm]{geometry}
\RequirePackage{multicol}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5em plus 1pt}

% ------------------------------------------------------------------ headings
\RequirePackage{titlesec}
\titleformat{\section}
  {\Large\bfseries\color{oledaccent}}{\thesection}{0.6em}{}
  [{\color{oledmuted}\titlerule[0.4pt]}]
\titleformat{\subsection}
  {\large\bfseries\color{oledaccent}}{\thesubsection}{0.6em}{}
\titleformat{\subsubsection}
  {\normalsize\bfseries\color{oledmuted}}{\thesubsubsection}{0.6em}{}

% --------------------------------------------------- lists, tables, captions
\renewcommand{\labelitemi}{\textcolor{oledaccent}{\textbullet}}
\renewcommand{\labelitemii}{\textcolor{oledaccent}{\textendash}}
\renewcommand{\labelenumi}{\textcolor{oledaccent}{\theenumi.}}

\RequirePackage{booktabs}
\RequirePackage{graphicx}
\RequirePackage[font=small, labelfont={bf, color=oledaccent}]{caption}

% ---------------------------------------------------------------- info boxes
% A run-in bold heading, and a coloured bar on the left. Black on black keeps
% the lit area of the screen small.
\RequirePackage{tcolorbox}
\tcbuselibrary{breakable}
\tcbset{
  oledbox/.style={
    breakable, sharp corners,
    colback=oledbg, colframe=#1, coltext=oledfg,
    boxrule=0pt, leftrule=1.6pt,
    left=7pt, right=4pt, top=3pt, bottom=3pt,
    before skip=6pt, after skip=6pt,
  },
}
% \oled@newbox{<env name>}{<heading>}{<colour>}
\newcommand{\oled@newbox}[3]{%
  \NewTColorBox{#1}{o}{%
    oledbox=#3,
    before upper={\textcolor{#3}{\bfseries #2\IfValueT{##1}{ (##1)}.}\ },
  }%
}
\oled@newbox{theorem}{Theorem}{oledaccent}
\oled@newbox{definition}{Definition}{oledgreen}
\oled@newbox{example}{Example}{oledamber}
\oled@newbox{remark}{Remark}{oledpurple}

% A general box with just a title, on its own line: \begin{topic}[<colour>]{<title>}
\NewTColorBox{topic}{O{oledaccent} m}{%
  oledbox=#1,
  before upper={\textcolor{#1}{\bfseries #2}\par},
}

% The same box as a sectioning command: \block[<colour>]{<title>} opens a box
% that runs until \endblock, the next \block, \section, \subsection or
% \end{document}.
\newif\ifoled@blockopen
\newcommand{\oled@closeblock}{%
  \ifoled@blockopen\expandafter\oled@doclose\fi
}
\newcommand{\oled@doclose}{\global\oled@blockopenfalse\end{topic}}
\NewDocumentCommand{\block}{O{oledaccent} m}{%
  \oled@closeblock
  \begin{topic}[#1]{#2}%
  \global\oled@blockopentrue
  \ignorespaces
}
% End the open block by hand, e.g. to write plain text after it.
\def\endblock{\oled@closeblock}
\AddToHook{cmd/section/before}{\oled@closeblock}
\AddToHook{cmd/subsection/before}{\oled@closeblock}
\AddToHook{enddocument}{\oled@closeblock}

% ---------------------------------------------------------------- hyperlinks
\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=oledaccent,
  citecolor=oledgreen,
  urlcolor=oledaccent,
  pdfborder={0 0 0},
}

\endinput
