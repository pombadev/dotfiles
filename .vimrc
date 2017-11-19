set nocompatible

filetype plugin on

call plug#begin('~/.vim/plugged')
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'joshdick/onedark.vim'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
call plug#end()

" custom keybinding
:map <C-/> :echo 'Current time is ' . strftime('%c')<CR>

"
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1

" NERDComment
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" ale linter
let g:ale_linters = {
\   'javascript': ['eslint'],
\}
