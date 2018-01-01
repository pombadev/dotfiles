filetype plugin indent on

set autoindent					" always set autoindenting on
set background=dark
set backspace=indent,eol,start
set copyindent					" copy the previous indentation on autoindenting
set cursorline					" Highlight current line
set encoding=utf8
set hidden
set history=1000				" remember more commands and search history
set hlsearch  					" highlight search terms
set ignorecase					" ignore case when searching
set incsearch 					" show search matches as you type
set laststatus=2
set list
set listchars=tab:>\ 			" show invisible
set nocompatible
set noshowmode
set noswapfile
set number					" show line number
set shortmess+=c
set showmatch					" set show matching parenthesis
set spelllang=en
set smartcase					" ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab					" insert tabs on the start of a line according to shiftwidth, not tabstop
set termguicolors
set title					" change the terminal's title
set undolevels=1000				" use many muchos levels of undo
set updatetime=250				" update time in millisecond
" set guicursor=i:ver5-iCursor

if has('nvim')
  " select text object highlight view
  set inccommand=split
endif

syntax on

if has('gui_running')
    set lines=9999 columns=9999
endif

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'drmingdrmer/vim-tabbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'jiangmiao/auto-pairs'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'machakann/vim-highlightedyank'
Plug 'mhartington/oceanic-next'
Plug 'mhinz/vim-startify'
Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}
Plug 'roxma/nvim-completion-manager'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'skywind3000/asyncrun.vim'
Plug 'terryma/vim-multiple-cursors' 
Plug 'tomtom/tcomment_vim'
Plug 'tomasr/molokai'
Plug 'w0rp/ale'
" conditional load plugin
if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()

" colorscheme
colorscheme OceanicNext 

" --- custom keybinding --- "
map <C-\> :NERDTreeToggle<CR>
" comment
map <C-/> :TComment<CR>
" close current buffer
map <C-q> :q<CR>
imap <C-S-q> <esc> :qa<CR>
map <C-S-q> :qa<CR>
" toggle buffer
imap <S-Tab> :bnext<CR>
map <S-Tab> :bnext<CR>
" save current buffer
nmap <C-s> :w<CR>
imap <C-s> <esc> :w<CR>
" splitting view
map <C-S-Right> :vnew<CR>
map <C-S-Down> :snew<CR>
" Sublime like duplicate line
map <C-S-d> yy p
imap <C-S-d> <esc>yy p<Insert>
" ctrl-f search and replace in current buffer
map <C-f> :%s/
imap <C-f> :%s/
" --- Move single lines ---
" normal
nmap <C-Up> ddkP
nmap <C-Down> ddp
" insert
imap <C-Down> ddp
imap <C-Down> ddp
" visual
" Move multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]
" show spelling suggestions
imap <C-S-Space> <Esc>[sz=
" disable ctrl-` key
map <C-`> noup


" Autocommands
autocmd FileType text,markdown set spell
" Source the vimrc file after saving it
" autocmd bufwritepost .vimrc source ~/.vimrc

" ctrlp
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|build\|out\|docs\|coverage'
let NERDTreeHijackNetrw=1
" ale linter
let g:ale_linters = {
\ 'javascript': ['eslint'],
\ 'bash': ['shellcheck'],
\ 'text': ['write-good'],
\ 'markdown': ['write-good'],
\ }
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠'

" lightline
let g:airline#extensions#tabline#enabled = 1
let g:lightline = {
\ 'active': {
\   'left': [[ 'mode', 'paste'], ['readonly', 'filename', 'modified']],
\   'right': [[ 'lineinfo' ], [ 'gitbranch' ], [ 'ale_info' ]]
\ },
\ 'component_function': {
\  'gitbranch': 'gitbranch#name',
\  'ale_info': 'ALEInfo',
\ },
\ }
" always show NERDTree's bookmarks
let NERDTreeShowBookmarks=1

function! ALEInfo() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts.total == 0 ? '' : ale#statusline#Status()
endfunction

" -- asyncrun -- "
" Open quickfix window when text adds to it
augroup vimrc
    autocmd QuickFixCmdPost * botright copen 8
augroup END
" F7 to toggle quickfix window
:noremap <F7> :call asyncrun#quickfix_toggle(8)<cr>

" nvim-completion-manager
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" vim-highlightedyank
" let g:highlightedyank_highlight_duration = -1
if !has('nvim')
  map y <Plug>(highlightedyank)
endif

