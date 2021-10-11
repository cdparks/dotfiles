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

  " Haskell plugins
  Plug 'neovimhaskell/haskell-vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}


  " PureScript plugins
  Plug 'purescript-contrib/purescript-vim'

  " Agda plugins
  Plug 'derekelkins/agda-vim'

  " PureScript plugins
  Plug 'purescript-contrib/purescript-vim'
  Plug 'frigoeu/psc-ide-vim'

  " TSX/React plugins
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'

  " Julia plugin for Ahorn
  Plug 'JuliaEditorSupport/julia-vim'

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

  " FZF
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

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

" Enable Solarized airline and don't display INSERT mode
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
set noshowmode

" Enable powerline fonts
" For installation, see https://github.com/powerline/fonts
let g:airline_powerline_fonts = 1

" Enable syntastic in airline
let g:airline#extensions#syntastic#enabled = 1

" Show tabline
let g:airline#extensions#tabline#enabled = 1

" Enable detection of whitespace errors
let g:airline#extensions#whitespace#enabled = 1

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
vnoremap <leader>y "+y
nnoremap <leader>y "+y

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

" ----- neoclide/coc.nvim -----

" TextEdit might fail if hidden is not set.
set hidden

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-\> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-\> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
" nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
"nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" ----- purescript-contrib/purescript-vim -----

let g:purescript_indent_if = 2
let g:purescript_indent_case = 2
let g:purescript_indent_let = 2
let g:purescript_indent_where = 2
let g:purescript_indent_do = 2
let g:purescript_indent_in = 1

" ----- junegunn/fzf.vim -----
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

nnoremap <Leader>f :Files<cr>
nnoremap <Leader>g :GGrep<cr>
nnoremap <Leader>b :Buffers<cr>

let g:fzf_action = {
      \ 'enter': 'vsplit',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *ts,*.tsx set filetype=typescript
