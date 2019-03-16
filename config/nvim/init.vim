" Ensure vim-plug is installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install plugins
call plug#begin('~/.config/nvim/plugged')

  " Solarized theme
  Plug 'altercation/vim-colors-solarized'

  " Python scripting support
  Plug 'roxma/python-support.nvim'

  " Haskell plugins
  Plug 'neovimhaskell/haskell-vim'

  " PureScript plugins
  Plug 'purescript-contrib/purescript-vim'

  " Agda plugins
  Plug 'derekelkins/agda-vim'

  " PureScript plugins
  Plug 'purescript-contrib/purescript-vim'
  Plug 'frigoeu/psc-ide-vim'

  " ALE
  Plug 'w0rp/ale'

  " Airline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Highlight trailing whitespace
  Plug 'ntpeters/vim-better-whitespace'

  " Git integration
  Plug 'jreybert/vimagit'
  Plug 'tpope/vim-fugitive'

  " Hybrid line numbers
  Plug 'jeffkreeftmeijer/vim-numbertoggle'

  " Neoformat for prettier
  Plug 'sbdchd/neoformat'

  " FZF
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

  " Digraphs
  Plug 'chrisbra/unicode.vim'

call plug#end()

" Show matching brackets
set showmatch

" Enable hybrid line numbering
set number relativenumber

" Highlight current line
set cursorline

" Show at least 8 lines of context
set scrolloff=8

" Continue comment marker in new lines
set formatoptions+=o

" Wrap long lines as you type them
set textwidth=100

" Insert 2 spaces when TAB is pressed
set expandtab
set tabstop=2

" Real tabs for Makefiles though
autocmd FileType make set noexpandtab

" Indentation amount for < and > commands
set shiftwidth=2

" Highlight whitespace characters
set list listchars=tab:•\ ,extends:»,precedes:«,trail:·

" Prevents inserting two spaces after punctuation on a join (J)
set nojoinspaces

" Use Esc to exit insert mode in terminal
tnoremap <Esc> <C-\><C-n>

" Use a reasonable file encoding
set encoding=utf-8

" Use homerow movement keys to move between panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Open panes to right and bottom
set splitbelow
set splitright

" Disable guicursor
set guicursor=

" Highlight searches, search incrementally
set hlsearch
set incsearch

" Ignore case unless capital letters are used
set ignorecase
set smartcase

" Ignore files ending with these extensions
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu

if has('gui_running')
  " Remove the toolbar
  set guioptions-=T
else
  " Do this if your emulator won't set xterm-256color
  let g:solarized_termtrans=1
endif

" Enable Solarized color scheme
colorscheme solarized
set background=dark

" Disable python3
let g:python_support_python3_require = 0

" Enable Solarized airline and don't display INSERT mode
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
set noshowmode

" Enable powerline fonts
" For installation, see https://github.com/powerline/fonts
let g:airline_powerline_fonts = 1

" Enable ale in airline
let g:airline#extensions#ale#enabled = 1

" Enable syntastic in airline
let g:airline#extensions#syntastic#enabled = 1

" Show tabline
let g:airline#extensions#tabline#enabled = 1

" Enable detection of whitespace errors
let g:airline#extensions#whitespace#enabled = 1

" Remove extra whitespace on write
autocmd BufEnter * EnableStripWhitespaceOnSave

" Enable vimagit in airline
let g:airline#extensions#vimagit#enabled = 1

" Show branch in airline
let g:airline#extensions#branch#enabled = 1

" Open terminals in a new pane
fun! s:openTerm(args, vertical)
  exe a:vertical ? 'vnew' : 'new'
  exe 'terminal' a:args
endf

" :Term => :new term://<args>
" :VTerm => :vnew term://<args>
" :Watch => :10new :term://stack build --fast --pedantic --test --no-run-tests --file-watch .
command! -nargs=* Term call s:openTerm(<q-args>, 0)
command! -nargs=* VTerm call s:openTerm(<q-args>, 1)
command! Watch exec '10new term://stack build --fast --pedantic --test --no-run-tests --file-watch .'

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" ----- neovimhaskell/haskell-vim -----

" Align 'then' two spaces after 'if'
let g:haskell_indent_if = 2

" Allow a second case indent style (see haskell-vim README)
let g:haskell_indent_case_alternative = 1

" Enable highlighting of forall
let g:haskell_enable_quantification = 1

" Enable highlighting of mdo and rec
let g:haskell_enable_recursivedo = 1

" Enable highlighting of pattern
let g:haskell_enable_pattern_synonyms = 1

" Enable highlighting of type roles
let g:haskell_enable_typeroles = 1

" Indent 'where' block one space under previous body
let g:haskell_indent_before_where = 1

" Indent bindings under 'where' one more space
let g:haskell_indent_after_bare_where = 2

" Don't indent 'in' for 'let-in'
let g:haskell_indent_in = 0

" Only next under 'let' if there's an equals sign
let g:haskell_indent_let_no_in = 0

" ----- purescript-contrib/purescript-vim -----

let g:purescript_indent_if = 2
let g:purescript_indent_case = 2
let g:purescript_indent_let = 2
let g:purescript_indent_where = 2
let g:purescript_indent_do = 2
let g:purescript_indent_in = 1

" ----- w0rp/ale -----

let g:ale_linters = {
      \ 'haskell': ['hlint'],
      \ }

let g:ale_fixers = {
      \ 'haskell': ['hlint', 'brittany', 'stylish-haskell'],
      \ }

let g:ale_haskell_hlint_executable='stack'
let g:ale_haskell_brittany_executable='stack'
let g:ale_haskell_stylish_haskell_executable='stack'

" flow likes to take my machine down
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1

" ----- sbdchd/neoformat -----

let g:neoformat_javascript_prettier = {
      \ 'exe': expand('~/code/megarepo/frontend/frontend-entities/node_modules/.bin/prettier'),
      \ 'args': ['--stdin', '--stdin-filepath', '%:p'],
      \ 'stdin': 1,
      \ }

" ----- junegunn/fzf -----
nnoremap <Leader>f :FZF<cr>

let g:fzf_action = {
      \ 'enter': 'split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

