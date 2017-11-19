filetype plugin indent on

set autoindent					" always set autoindenting on
set background=dark
set backspace=indent,eol,start
set copyindent					" copy the previous indentation on autoindenting
set encoding=utf8
set hidden
set history=1000				" remember more commands and search history
set hlsearch  					" highlight search terms
set ignorecase					" ignore case when searching
set incsearch 					" show search matches as you type
set laststatus=2
set list
set listchars=tab:\|\ 			" don't trim
set nocompatible
set noshowmode
set noswapfile
set number						" show line number
set showmatch					" set show matching parenthesis
set smartcase					" ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab					" insert tabs on the start of a line according to shiftwidth, not tabstop
set title						" change the terminal's title
set undolevels=1000				" use many muchos levels of undo
set updatetime=250				" update time in millisecond

syntax on

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-buftabline'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'jiangmiao/auto-pairs'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'lifepillar/vim-mucomplete'
Plug 'mhinz/vim-startify'
Plug 'NLKNguyen/papercolor-theme'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'skywind3000/asyncrun.vim'
Plug 'tomtom/tcomment_vim'
Plug 'w0rp/ale'
call plug#end()

" colorscheme
colorscheme PaperColor

" custom keybinding
map <C-\> :NERDTreeToggle<CR>
map <C-N> :bnext<CR>
map <C-/> :TComment<CR>

" ctrlp
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|build\|out\|docs\|coverage'

" mucomplete - all these to get auto complete menu
inoremap <expr> <c-e> mucomplete#popup_exit('\<c-e>')
inoremap <expr> <c-y> mucomplete#popup_exit('\<c-y>')
inoremap <expr>  <cr> mucomplete#popup_exit('\<cr>')
let g:mucomplete#enable_auto_at_startup = 1
set completeopt=preview
set completeopt+=noinsert,menuone,noselect
set noshowmode shortmess+=c

" ale linter
let g:ale_linters = {
\ 'javascript': ['eslint'],
\ 'bash': ['shellcheck'],
\ 'text': ['write-good'],
\ 'markdown': ['write-good'],
\ }
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠'
let g:ale_sign_column_always = 1

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
\ }
\ }

function! ALEInfo() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts.total == 0 ? '' : ale#statusline#Status()
endfunction

" -- asyncrun -- "
" Open quickfix window when text adds to it
augroup vimrc
    autocmd QuickFixCmdPost * botright copen 8
augroup END
" F8 to toggle quickfix window
:noremap <F8> :call asyncrun#quickfix_toggle(8)<cr>
