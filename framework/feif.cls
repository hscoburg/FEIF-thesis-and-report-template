\def\fileversion{1.0}
\def\filedate{2025/01/28}
\def\docdate {2025/01/28}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{feif}[\filedate \space FEIF Document Class v\fileversion]

\newcommand{\praxisbericht}{false}
\DeclareOption{praxis}{\renewcommand{\praxisbericht}[0]{true}}
\ProcessOptions\relax

\newcommand{\lang}{english}
\DeclareOption{english}{\renewcommand{\lang}{english}}
\DeclareOption{ngerman}{\renewcommand{\lang}{ngerman}}
\ProcessOptions\relax

\LoadClass[a4paper, 12pt]{article}
\RequirePackage{fix-cm}                           % Fix sizes at which CM and EC fonts can be used
\RequirePackage[english, ngerman]{babel, translator}       % German LaTeX-intern descriptors (Abbildungen, ...)
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{mathptmx}
\RequirePackage{courier}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{caption}
\RequirePackage{float}
\RequirePackage{hyperref}
\RequirePackage{microtype}
\RequirePackage[onehalfspacing]{setspace}         % Set line spacing to be 1.5x the default
\RequirePackage[titles]{tocloft}                  % More options to modify list of figures & tables
\RequirePackage[ddmmyyyy]{datetime}               % Reformat times from LaTeX commands like \today
\RequirePackage{listings}
\RequirePackage{pdfpages}                         % Include existing PDFs into the work
\RequirePackage{ifthen}                           % Include existing PDFs into the work
\RequirePackage{nomencl}                          % Support for nomenclatures ("List of Symbols")
\RequirePackage{etoolbox}                         % Easily patch commands
\RequirePackage{amsmath}                          % Includes a plethora of mathematical packages 
\RequirePackage{amssymb}                          % Source mathematical symbols like \sin
\RequirePackage{amsthm}                           % Better theorems
% Track the total count of different environments
% Needs to be imported because LaTeX resets these counter on a chapter basis
\RequirePackage[figure,table,lstlisting,xspace]{totalcount}
\RequirePackage{siunitx}
\RequirePackage[toc, nogroupskip, nonumberlist, nopostdot, acronyms, shortcuts, translate=babel]{glossaries}
\RequirePackage{graphicx}
\RequirePackage{tabularray}
\UseTblrLibrary{booktabs}
\RequirePackage{glossaries-extra}

% Set the graphics path relative to the .cls file
\makeatletter
\def\input@path{{./}}
\makeatother

\newcommand{\ifgerman}[2]{\ifthenelse{\equal{\lang}{ngerman}}{#1}{#2}}
\newcommand{\FEIFCountEntriesFileName}{\jobname.feif}
\AtBeginDocument{\ifgerman{\selectlanguage{ngerman}}{\selectlanguage{english}}}
\AtEndDocument
{
  % Check if any glossary entry has been used
  \newwrite\myfile
  \newread\myfile
  \immediate\openout\myfile=\FEIFCountEntriesFileName
  \newif\ifanyglsused
  \anyglsusedfalse
  \forglsentries{\thisentry}{\ifglsused{\thisentry}{\anyglsusedtrue}{}}
  
  \ifanyglsused
    \immediate\write\myfile{\string\gdef\string\GlossaryEntriesUsed{1}}%
  \else
    \immediate\write\myfile{\string\gdef\string\GlossaryEntriesUsed{0}}%
  \fi

  % Check if any acronyms are entry has been used
  \newif\ifanyacronymsused
  \anyacronymsusedfalse    
  \forglsentries[\acronymtype]{\thislabel}{\ifglsused{\thislabel}{\anyacronymsusedtrue}{}}  
  
  \ifanyacronymsused
    \immediate\write\myfile{\string\gdef\string\AcronymsUsed{1}}%
  \else
    \immediate\write\myfile{\string\gdef\string\AcronymsUsed{0}}%          
  \fi      
  \immediate\closeout\myfile    
}

% Unit-related setup for siunitx
\ifgerman
{
  \sisetup{
    locale=DE,                   % Use German notation (comma instead of point delimiter for floats)
    per-mode=fraction,           % Switch display to use \frac instead of x^{-1}
    fraction-function=\tfrac     % Use amsmath's tfrac macro for unit fractions
  }
}
{
  \sisetup{
    locale=US,                   % Use German notation (comma instead of point delimiter for floats)
    per-mode=fraction,           % Switch display to use \frac instead of x^{-1}
    fraction-function=\tfrac     % Use amsmath's tfrac macro for unit fractions
  }
}

% -------------------------------------------------------------------
% Document Structure Settings
% -------------------------------------------------------------------
% Only allow nesting 3 layers (down to subsubsections)
\setcounter{secnumdepth}{3}

% -------------------------------------------------------------------
% Usability Settting
% -------------------------------------------------------------------
% Set toc sections to be clickable
\hypersetup{colorlinks, citecolor=black, filecolor=black, linkcolor=black}

% -------------------------------------------------------------------
% Visual Settings
% -------------------------------------------------------------------
% Align captions to the left (cut-off or "rag" right part of the 
% caption line.).
% This should also hold for single-line captions, which would otherwise be 
% centered.
\captionsetup{justification=raggedright, singlelinecheck=false}

% Disable single lines at the start of a paragraph (Schusterjungen)
\clubpenalty=10000

% Disable single lines at the end of a paragraph (Hurenkinder)
\widowpenalty=10000
\displaywidowpenalty=10000

% Page margins
\geometry{left=2.5cm, right=2.5cm, top=2.5cm, bottom=3cm}

% Create a better looking header and footer
\pagestyle{fancy}
\fancyhf{}
\lhead{\nouppercase{\leftmark}}
\rfoot{\thepage}

% New page after every section.
\AddToHook{cmd/section/before}{\clearpage}

% Insert one space after a sentence, not 2
\frenchspacing                                                 


% Don't indent start of paragraph
\setlength{\parindent}{0cm}
% Lines are separated by 6pt (0.2116666666666667cm)
\setlength{\parskip}{6pt}                               

\setlength{\headheight}{1.25cm}
\setlength{\footskip}{1cm}
\setlength{\headsep}{1cm}

% Don't display "a as ä etc.
\shorthandoff{"}

% -------------------------------------------------------------------
% Names
% -------------------------------------------------------------------
\newcommand*{\hscrefname}{Literaturverzeichnis}               % Bibliography
\newcommand*{\acknowledgementname}{Acknowledgements}          % Acknowledgement

\numberwithin{equation}{section}                               % Numbering of equations should be x.x (locally scoped to their respective section)
\renewcommand{\UrlFont}{\color{blue}\rmfamily\itshape}         % URLs should be displayed in blue
\renewcommand{\dateseparator}{.}                               % Dates are written like 01.01.1970, not 01-01-1970

\addto{\captionsngerman}{
  \renewcommand*{\figurename}{Abb.}                            % Figures should be displayed as "Abb. x"
  \renewcommand*{\tablename}{Tab.}                             % Tables  should be displayed as "Tab. x"
  \renewcommand*{\lstlistingname}{Code}                        % Code    should be displayed as "Code x"  
  \renewcommand*{\lstlistlistingname}{Codebeispielverzeichnis} % List of listings
  \renewcommand*{\nomname}{Symbolverzeichnis}                  % Nomenclature
  \renewcommand*{\acronymname}{Abkürzungsverzeichnis}          % List of acronyms
  \renewcommand*{\refname}{\hscrefname}                        % Bibliography  
  \renewcommand*{\abstractname}{Zusammenfassung}               % Abstract
  \renewcommand*{\acknowledgementname}{Dankesagung}            % Acknowledgement
  \providecommand{\declarationname}{}
  \renewcommand*{\declarationname}{Ehrenwörtliche Erklärung}   % Declaration of honor
}

\addto{\captionsenglish}{
  \renewcommand*{\figurename}{Fig.}                            % Figures should be displayed as "Abb. x"
  \renewcommand*{\tablename}{Tab.}                             % Tables  should be displayed as "Tab. x"
  \renewcommand*{\lstlistingname}{Code}                        % Code    should be displayed as "Code x"  
  \renewcommand*{\lstlistlistingname}{Listings}                % List of listings
  \renewcommand*{\nomname}{List of Symbols}                    % Nomenclature
  \renewcommand*{\acronymname}{Acronyms}                       % List of acronyms
  \renewcommand*{\refname}{\hscrefname}                        % Bibliography  
  \renewcommand*{\abstractname}{Abstract}                      % Abstract
  \renewcommand*{\acknowledgementname}{Acknowledgements}       % Acknowledgement
  \providecommand{\declarationname}{}
  \renewcommand*{\declarationname}{Declaration of Honor}   % Declaration of honor
}

\addto{\extrasngerman}{%
  \def\sectionautorefname{Kapitel}%                              1st level sections should be called "Kapitel"
  \def\subsectionautorefname{Abschnitt}%                         2nd level sections should be called "Abschnitt"
  \def\subsubsectionautorefname{Unterabschnitt}%                 3rd level sections should be called "Unterabschnitt"
}

\addto{\extrasenglish}{%
  \def\sectionautorefname{Chapter}%                              1st level sections should be called "Kapitel"
  \def\subsectionautorefname{Section}%                           2nd level sections should be called "Abschnitt"
  \def\subsubsectionautorefname{Subsection}%                     3rd level sections should be called "Unterabschnitt"
}

% -------------------------------------------------------------------
%                        Code listing setup
% -------------------------------------------------------------------
\lstset{
  basicstyle=\small\ttfamily\color{black},              % Font size used for the code
  commentstyle=\ttfamily\color{gray},                   % Comment style
  keywordstyle=\ttfamily\color{blue},                   % Keyword style
  stringstyle=\color{ForestGreen!30!LimeGreen},         % String literal style
  frame=single,                                         % Add a frame around the code
  showstringspaces=false,                               % Don't underline spaces within strings only
  captionpos=b,                                         % Set caption-position to bottom
  backgroundcolor=\color{white},                        % Background color
}

% Register Listings for list of codes.
% To style lstlistlisting like the lof, you first have to register it
% to tocloft, as mentioned in https://tex.stackexchange.com/a/27648/27635
\makeatletter
\begingroup\let\newcounter\@gobble\let\setcounter\@gobbletwo
  \globaldefs\@ne \let\c@loldepth\@ne
  \newlistof{listings}{lol}{\lstlistlistingname}
\endgroup
\let\l@lstlisting\l@listings
\makeatother

% -------------------------------------------------------------------
% Redefining geometry
% -------------------------------------------------------------------
% Automatically generate a box around figure environments
\floatstyle{boxed}
\restylefloat{figure}

% Figures
\renewcommand{\cftfigpresnum}{\figurename~}
\renewcommand{\cftfigaftersnum}{:}
\setlength{\cftfignumwidth}{2cm}
\setlength{\cftfigindent}{0cm}

\AtBeginEnvironment{figure}{\vspace{1em}}               % Increase spacing of images from the text above

% Tables
\renewcommand{\cfttabpresnum}{\tablename~}
\renewcommand{\cfttabaftersnum}{:}
\setlength{\cfttabnumwidth}{2cm}
\setlength{\cfttabindent}{0cm}

% Listings
\renewcommand*{\cftlistingspresnum}{\lstlistingname~}
\renewcommand*{\cftlistingsaftersnum}{:}
\settowidth{\cftlistingsnumwidth}{\cftlistingspresnum}
\addtolength{\cftlistingsnumwidth}{1cm}
\setlength{\cftlistingsindent}{0cm}

% -------------------------------------------------------------------
% Larger clickable references to page items
% -------------------------------------------------------------------
\ifgerman
{
\newcommand{\imgref} [1]{\hyperref[#1]{Abbildung~\getrefnumber{#1}}}
}
{
  \newcommand{\imgref} [1]{\hyperref[#1]{Figure~\getrefnumber{#1}}}  
}
\ifgerman
{
\newcommand{\tabref} [1]{\hyperref[#1]{Tabelle~\getrefnumber{#1}}}
}
{
\newcommand{\tabref} [1]{\hyperref[#1]{Table~\getrefnumber{#1}}}
}
\newcommand{\coderef}[1]{\hyperref[#1]{Code~\getrefnumber{#1}}}
\ifgerman
{
\newcommand{\mathref}[1]{\hyperref[#1]{Gleichung~\getrefnumber{#1}}}
}
{
  \newcommand{\mathref}[1]{\hyperref[#1]{Equation~\getrefnumber{#1}}}  
}
\newcommand{\secref} [1]{\autoref{#1}}

% -------------------------------------------------------------------
% Commands
% -------------------------------------------------------------------
\renewcommand\maketitle
{    
    \newgeometry{left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm}    
    \begin{titlepage}
        \ifthenelse{\equal{\praxisbericht}{true}}
          {
            \centering
            \ifgerman{
              \includegraphics[width=.8\textwidth]{logo_hscoburg_de_rot.pdf}%
            }
            {
              \includegraphics[width=.8\textwidth]{logo_hscoburg_en_rot.pdf}%
            }
            
            \begin{Large}
            \ifgerman{
              Hochschule für angewandte Wissenschaften Coburg\\
              Fakultät Elektrotechnik und Informatik\par
            }
            {
              Coburg University of Applied Sciences\\
              Faculty of Electrical Engineering and Computer Science\par
            }
            \end{Large}
            \vspace{1.5cm}

            \Large{\ifgerman{Studiengang: }{Degree Program: }\FEIFStudyProgram}
            \vspace{1.5cm}

            \Large{\ifgerman{Praxisbericht}{Internship Report}}
            
            \vspace{1cm}
            
            \huge{\FEIFAuthorsName}

            \vspace{1.0cm}
            
            \normalsize
            
            \begin{tblr}{colspec={|X[3]|X[11]|}}
            \hline
            \ifgerman{Unternehmen}{Company}      & \FEIFCompany        \\
                                                 & \FEIFCompanyDepartment          \\
                                                 & \FEIFCompanyStreetName            \\
                                                 & \FEIFCompanyCity                \\
            \hline
            % Use "through" because it includes the last date. If you use "until
            \ifgerman{Zeitraum}{Intership Period} & \FEIFBeginDate\ifgerman{ bis }{--}\FEIFEndDate \\
            \hline
            \end{tblr}           

            \large{\ifgerman{Abgabe des Berichts:}{Submission date:} \FEIFSubmissionDate}
            \normalsize            
            \begin{flushleft}
              \ifgerman
              {
                Freigabe zur Vorlage des Praxisberichts an der HS Coburg:
              }
              {
                Submission clearance of the internship report to Coburg University:
              }
            \end{flushleft}%            
            \begin{tblr}{|X[2.7]|X[5.3]|X[5.5]|}                
                \hline
                \ifgerman{Betreuungsperson}{Advisor} & \FEIFCompanyAdvisor & \\
                \hline
                \ifgerman{Funktion}{Role} & \FEIFCompanyAdvisorRole & \textbf{\textit{\ifgerman{Ort, Datum}{Place, Date}}}\\
                \hline
                \ifgerman{Telefon}{Phone} & \FEIFCompanyAdvisorPhone & \\
                \cline{1-2}
                E-Mail & \FEIFCompanyAdvisorEMail & \\
                \hline
                & & \textbf{\textit{\ifgerman{Unterschrift d. Betreuungsperson}{Signature of Advisor}}}\\
                \hline
            \end{tblr}            
          }
          {
            \centering
            \ifgerman{
              \includegraphics[width=.8\textwidth]{logo_hscoburg_de_rot.pdfpages}%
            }
            {
              \includegraphics[width=.8\textwidth]{logo_hscoburg_en_rot.pdf}%
            }

            \begin{Large}
              \ifgerman{
                Hochschule für angewandte Wissenschaften Coburg\\
                Fakultät Elektrotechnik und Informatik\par
                }
                {
                Coburg University of Applied Sciences\\
                Faculty of Electrical Engineering and Computer Science\par
                }            \end{Large}
            \vspace{1.5cm}

            \Large{\ifgerman{Studiengang: }{Degree program: }\FEIFStudyProgram}
            \vspace{1.5cm}

            \Large{\FEIFThesisType}
            \vspace{1cm}

            \Huge{\FEIFTitle}
            \vspace{2cm}

            \huge{\FEIFAuthorsName}
            \vspace{2cm}
            
            \Large{\ifgerman{Abgabe des Arbeit:}{Submission date:} \FEIFSubmissionDate}

            \Large{\ifgerman{Betreut durch:}{Advisor: }}

            \Large{\FEIFInstructor, \ifgerman{Hochschule Coburg}{Coburg University}}
          }
    \end{titlepage}    
    \restoregeometry    
    % Title page is considered the 1st page
    \addtocounter{page}{1}
}

% Declaration Of Honor
\newcommand\MakeDeclarationOfHonor
{    
  \clearpage
  \phantomsection
  \thispagestyle{empty}
  \addcontentsline{toc}{section}{\declarationname}    
  \includepdf[
    pages=-,
    pagecommand={},
    picturecommand*={
        \put(75,714){\large \FEIFAuthorsName}
        \put(75,683){\large \FEIFDateOfBirth}
        \put(75,652){\large \FEIFStudyProgram}
        \put(75,622){\large \FEIFMatriculationNumber}
        \put(75,81.5){\large \FEIFAuthorCity, den \today}
    }
  ]{declaration_of_honor.pdf}
}

\newtoggle{anySymbols}
\pretocmd{\nomenclature}{\toggletrue{anySymbols}}{}{}

\newtoggle{anyCitations}
\pretocmd{\cite}{\toggletrue{anyCitations}}{}{}

\newcommand*{\nomen}[2]{\nomenclature{#1}{#2}\stepcounter{countnomen}}
\newcommand{\nomunit}[1]{\renewcommand{\nomentryend}{\hspace*{\fill}#1}}
\newcommand{\nomsi}[1]{\nomunit{$\left[\si{#1}\right]$}}
% -------------------------------------------------------------------
% Document Structure
% -------------------------------------------------------------------
% Frontmatter
\newcommand\frontmatter
{  
  % Peripheral pages have to be numbered using roman numerals
  \pagenumbering{Roman}
}

% Mainmatter
\newcommand\mainmatter
{
  \clearpage 
  % Save page counter, used for consecutive numbering of peripherals following main content
  \newcounter{HSCPeripheralNumbering}
  \setcounter{HSCPeripheralNumbering}{\value{page}}  
  
  % Set numbering of pages to arabic for main content
  \pagenumbering{arabic}
}

% Backmatter
\newcommand\backmatter
{
  \clearpage 
  % Reset numbering to use roman numerals for rest of peripheral files
  \pagenumbering{Roman}
  \setcounter{page}{\value{HSCPeripheralNumbering}}
}

% List of Figures
\let\oldlistoffigures\listoffigures
\renewcommand{\listoffigures}
{
    \iftotalfigures
        \phantomsection
        \addcontentsline{toc}{section}{\listfigurename}
        \oldlistoffigures
    \fi
}

% List of Tables
\let\oldlistoftables\listoftables
\renewcommand{\listoftables}
{
    \iftotaltables
        \phantomsection
        \addcontentsline{toc}{section}{\listtablename}
        \oldlistoftables
    \fi
}

% List of Listings
\let\oldlstlistoflistings\listoflistings
\renewcommand{\lstlistoflistings}
{  
    \iftotallstlistings
      \clearpage
      \phantomsection
      \addcontentsline{toc}{section}{\lstlistlistingname}
      \oldlstlistoflistings
    \fi
}

% List of Symbols
\newcommand{\listofsymbols}
{    
  \iftoggle{anySymbols}{
    \clearpage
    \phantomsection
    \addcontentsline{toc}{section}{\nomname}
    \printnomenclature[2.5cm]
  }
  {}
}

% List of Acronyms
\newcommand{\listofacronyms}
{    
  \IfFileExists{\FEIFCountEntriesFileName}{\input{\FEIFCountEntriesFileName}}{}
  \ifdefined\AcronymsUsed
      \ifnum\AcronymsUsed=1    
        \clearpage
        \setglossarystyle{super}
        \printglossary[type=\acronymtype]
  
      \fi 
  \fi
}

% Glossary
\newcommand{\printfeifglossary}
{       
  \IfFileExists{\FEIFCountEntriesFileName}{\input{\FEIFCountEntriesFileName}}{}  
  \ifdefined\GlossaryEntriesUsed
    \ifnum\GlossaryEntriesUsed=1
        \clearpage
        \setglossarystyle{altlist}
        \printglossary
    \fi
  \fi
}

% Bibliography
\newcommand{\printfeifbibliography}
{
  \iftoggle{anyCitations}{        
        \clearpage
        \phantomsection
        \renewcommand*{\refname}{\hscrefname}
        \addcontentsline{toc}{section}{\refname}
        \bibliographystyle{alphadin}
  }{
    \renewcommand*{\refname}{}
  }  
}

% Abstracts
\renewenvironment{abstract}
{  
  \markboth{\abstractname}{\abstractname}
  \pagestyle{fancy}
  \fancypagestyle{abstract}{\fancyhead[L]{\abstractname}}
  \thispagestyle{abstract}
  \section*{\abstractname} 
  \addcontentsline{toc}{section}{\abstractname}
}
{  
}

% Acknowledgements
\newenvironment{acknowledgement}
{  
  \markboth{\acknowledgementname}{\acknowledgementname}
  \pagestyle{fancy}
  \clearpage
  \fancypagestyle{acknowledgement}{\fancyhead[L]{\acknowledgementname}}
  \thispagestyle{acknowledgement}  
  \addcontentsline{toc}{section}{\acknowledgementname}
}
{  
}
\endinput
