" copy the previous indentation on autoindenting
set copyindent
" highlight current line
set cursorline
" highlight search term
set hlsearch
" hide mode from statusbar
set noshowmode
" show line number
set number
" enable spell check
" set spell
" cursor will automatically jump to the matching brace briefly
" set showmatch
" mouse support
set mouse=a
set mousemodel=popup

set background=dark

" set relativenumber

" show render whitespaces
set list
set listchars=tab:▸\ ,space:·,nbsp:␣,trail:•,eol:¬,precedes:«,extends:»

" use tabs with 4 width
set shiftwidth=4
set tabstop=4

" set code folding optiona manually
" Eg: select a block of text and `zf` for folding and `zo` for opening fold
set foldmethod=manual

" https://github.com/neovim/neovim/wiki/FAQ
if has('nvim')
	set termguicolors
	set guicursor=
	" search & replace preview window
	set inccommand=split
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'prettier/vim-prettier', {'do': 'yarn install'}
Plug 'itchyny/vim-gitbranch'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kizza/actionmenu.nvim'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-startify'
Plug 'rhysd/git-messenger.vim'
Plug 'Townk/vim-autoclose'
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
" Plug 'chriskempson/base16-vim'

call plug#end()

colorscheme gruvbox

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use ripgrep and dmenu to create a drop-down to fuzzy filter files in
" the cwd and open the selected file in the current tab.
function! DmenuOpen()
	" git rev-parse --show-toplevel
	let fname = system("rg --files $(git rev-parse --show-toplevel &> || pwd) | dmenu -p 'Open: ' -i -l 20 -fn 'Droid Sans Mono-9' -w 700 -x 600 -y 300")

	if empty(fname)
		return
	endif

	exec 'tab drop' fname
endfunction

map <silent> <C-p> :call DmenuOpen()<CR>

noremap <C-l> :tabNext <CR>
noremap <C-h> :tabprevious <CR>
noremap <C-q> :q <CR>
noremap zz :Commentary<CR>

let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
let g:netrw_banner = 0
let g:netrw_list_hide = &wildignore
" Toggle Vexplore with Ctrl-\
function! ToggleVExplorer()
	if exists("t:expl_buf_num")
		let expl_win_num = bufwinnr(t:expl_buf_num)
		if expl_win_num != -1
			let cur_win_nr = winnr()
			exec expl_win_num . 'wincmd w'
			close
			exec cur_win_nr . 'wincmd w'
			unlet t:expl_buf_num
		else
			unlet t:expl_buf_num
		endif
	else
		exec '1wincmd w'
		Vexplore
	let t:expl_buf_num = bufnr("%")
endif
endfunction
map <silent> <C-\> :call ToggleVExplorer()<CR>

let g:lightline = {
	\ 'colorscheme': 'one',
	\ 'active': {'left': [[ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ]]},
	\ 'component_function': {
	\	'gitbranch': 'gitbranch#name'
	\ },
	\ }

function! OpenFilePicker()
	if executable('kdialog')
		let fname = system('kdialog --getopenfilename `pwd`')
		exec 'tab drop' fname
	elseif executable('zenity')
		let fname = system('zenity --file-selection `pwd`')
				exec 'tab drop' fname
		endif

endfunction
map <silent> <C-o> :call OpenFilePicker() <CR>

" Use <C-S-x> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-S-x> :nohlsearch<CR>

" nord colorscheme config
let g:nord_italic_comments=1
let g:nord_underline = 1
let g:nord_bold_vertical_split_line = 1

let g:fzf_command_prefix = 'Fzf'

function! PreviewColorSchemes()
	" !ls $VIMRUNTIME/colors
	let colorschemes = getcompletion('', 'color')
	echo colorschemes

	" system('echo ' . colorschemes)
	" for color_scheme in colorschemes
	" 	echo color_scheme
	" endfor
endfunction
