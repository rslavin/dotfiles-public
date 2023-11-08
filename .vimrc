set nocompatible
filetype plugin indent on

set rtp+=$HOME/.vim/bundle/Vundle.vim

call vundle#begin()


" #### PLUGINS #### "

" bundle manager
Bundle 'gmarik/Vundle.vim' 

" filesystem explorer
Bundle 'preservim/nerdtree' 

" status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" colors for light and dark backgrounds
Bundle 'altercation/vim-colors-solarized' 

" latex stuff
Plugin 'vim-latex/vim-latex'
"Plugin 'lervag/vimtex' " good plugin, but doesn't work well with cygwin
" specify a master file by creating an empty .tex.latexmain file
" e.g., for main.tex as a master file create main.tex.latexmain
" bibtex autocomplete works with <F9> 
"
" Placeholders (<++>) can be cycled through with ctrl+j while in insert mode.
" Snippets can automatically produce a template of something (like typign EFI
" will create a blank figure) with placeholders in it that you can jump
" between with ctrl+j so you can fill it in.
" See the following.
" https://vim-latex.sourceforge.net/documentation/latex-suite.html#place-holders

" syntax checking
Plugin 'vim-syntastic/syntastic'

"Plugin 'vim-php/tagbar-phpctags.vim'
" o = unfold item
" enter = go to item
" space = show prototype
" fix php indents (remember, 'gg=G' formats entire file)
" (gQG formats based on line length, gg=G fixes tabs for coding)

call vundle#end()

" #### GENERAL SETTINGS #### "

syntax enable
set omnifunc=syntaxcomplete#Complete
set number
set term=xterm-256color
set encoding=utf-8
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
set laststatus=2
set backspace=indent,eol,start
" " And set some nice chars to do it with
set listchars=tab:»\ ,eol:¬
" " automatically change window's cwd to file's dir
set autochdir
" " tabs 
set tabstop=4
set shiftwidth=4
" " changes tabs to spaces
set expandtab 
set hlsearch
" " disable stupid bell sound (make it visual)
set vb
" from insert mode, use ctrl+x+t for thesaurus
set thesaurus+=$HOME/.vim/mthesaur.txt
set grepprg=grep\ -nH\ \'$*\'

map <C-n> :NERDTreeToggle<CR>

" #### FILE TYPES #### "

" autocmd Filetype python setl ts=4 sw=4 et " python
autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.tex set textwidth=80
autocmd FileType tex syn spell toplevel
autocmd BufRead,BufNewFile *.txt set textwidth=80
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.md set textwidth=80


" #### THEME #### "

let g:solarized_termcolors=256
set background=dark
colorscheme solarized


" #### POWERLINE #### "
let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1


" #### LATEX #### "

" http://vim-latex.sourceforge.net/documentation/latex-suite-quickstart.html
" latex compilation: use \lv to view the tex in pdf and \ll to compile 
" in INSERT mode, use F9 to autocomplete citations
let g:Tex_ViewRule_pdf = "sumatrapdf"
let g:tex_flavor = "latex"
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats='pdf'
let g:Tex_CompileRule_pdf = 'pdflatex -file-line-error -max-print-line=120'

" disable folding
let Tex_FoldedSections=""
let Tex_FoldedEnvironments=""
let Tex_FoldedMisc=""
" disable python because it is causing cite completion to stop working
" NOTE that this seems to break other things like Tex_MultipleCompileFormats
"let g:Tex_UsePython=0
"let g:Tex_Debug = 1
"let g:Tex_DebugLog = "vim-latex-suite.log"

" disable syntax highlighting inside listings
au filetype tex syntax region texZone start='\\begin{lstlisting}' end='\\end{lstlisting}'

" make sure to do 'apt-cyg download procps' and 'apt-cyg install procps'
" also make sure sumatrapdf is in your path
let g:vimtex_view_general_viewer = "sumatrapdf"
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_compiler_progname = v:progname


" #### SPELLCHECK #### "

" use ']s' or '[s' to move through spelling errors
set spelllang=en_us
" undercurl characters
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"
" must go after colorscheme command
hi SpellBad ctermfg=red cterm=undercurl

let g:Tex_MultipleCompileFormats='pdf,bib,pdf'

