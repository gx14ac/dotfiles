" vim Settings
filetype off
syntax on
hi Comment ctermfg=3
set virtualedit=block
set ignorecase
set smartcase
set hlsearch
set noerrorbells
set showmatch matchtime=1
set laststatus=2
set listchars=tab:^\ ,trail:~
set history=10000
set shiftwidth=2
set guioptions+=a
set title
set number
set mouse=a
set encoding=utf-8
set fileencodings=utf-8,euc-jp,sjis,cp932,iso-2022-jp
set fileformats=unix,dos,mac
set noswapfile

" vim-go completion
let g:go_gocode_propose_source = 0

" vim Color Scheme
colorscheme antares

" vimrc Plugins
if has('vim_starting')
  set nocompatible               " Be iMproved
 
  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

function! s:clang_format()
  let now_line = line(".")
  exec ":%! clang-format"
  exec ":" . now_line
endfunction

if executable('clang-format')
  augroup cpp_clang_format
    autocmd!
    autocmd BufWrite,FileWritePre,FileAppendPre *.[ch]pp call s:clang_format()
  augroup END
endif

" NERDTree ShortCut
autocmd vimenter * NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDTree Options
let g:NERDTreeShowHidden=1

" augroup
augroup source-vimrc
  autocmd!
  autocmd BufWritePost *vimrc source $MYVIMRC | set foldmethod=marker
  autocmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
augroup END

augroup auto_comment_off
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=r
  autocmd BufEnter * setlocal formatoptions-=o
augroup END


" Required:
call neobundle#begin(expand('~/.vim/bundle/'))
 
" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
 
" My Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'fatih/vim-go'
NeoBundle 'cohama/lexima.vim'
 
" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }
 
call neobundle#end()
 
" Required:
filetype plugin indent on
 
" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck