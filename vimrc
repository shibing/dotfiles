" General {{{
set nocompatible        " Disable vi compatibility
set hidden              " Open a new file using :e,
                        " without being forced to write or undo your changes first
set encoding=utf-8
set history=256         " Number of things to remember in history
set timeoutlen=250      " Time to wait after ESC (default causes an annoying delay)
set clipboard=unnamed   " Yanks go on clipboard instead
set t_Co=256
set lazyredraw          " Don't redraw while executing macros (good performance config)
" Match & search
set number
set hlsearch            " Highlight search
set ignorecase          " Do case in sensitive matching with
set smartcase           " be sensitive when there's a capital letter
set incsearch           " Do incremental searching
" Backup & undo
set nowritebackup
set nobackup

" Paste without replace
xnoremap p pgvy

autocmd! bufwritepost .vimrc source %
" }}}

" Vundle {{{
filetype off
filetype plugin indent off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'majutsushi/tagbar'

Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/neomru.vim'

Plugin 'Shougo/unite.vim'

" Unite setting {{{

let g:unite_source_history_yank_enable = 1
let g:unite_source_rec_max_cache_files = 5000

if executable('ag')
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt=''
endif

function! s:unite_settings()
    nmap <buffer> <esc> <plug>(unite_exit)
endfunction
autocmd FileType unite call s:unite_settings()

nmap <space> [unite]
nnoremap [unite] <Nop>

nnoremap <silent> [unite]<space> :<C-u>Unite -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr>
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file_rec/async:!<cr>
nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<cr>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> [unite]g :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>

" }}}

Plugin 'Lokaltog/vim-easymotion'
let g:EasyMotion_smartcase = 1

Plugin 'bling/vim-airline'
let g:airline_powerline_fonts = 1

Plugin 'christoomey/vim-tmux-navigator'

Plugin 'scrooloose/nerdtree'
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=0
let NERDTreeShowLineNumbers=1
let NERDTreeChDirMode=0
let NERDTreeIgnore=['\.git','\.hg']

Plugin 'Shougo/neocomplete.vim'
let g:neocomplete#enable_at_startup = 1

let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType make setlocal noexpandtab

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

Plugin 'Shougo/neosnippet.vim'
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

Plugin 'scrooloose/syntastic'
let g:syntastic_check_on_open=1
let g:syntastic_phpcs_conf = "--tab-width=4 --standard=CodeIgniter"

" Plugin 'mileszs/ack.vim'
" Plugin 'vim-scripts/nerdtree-ack'
Plugin 'epmatsw/ag.vim'
Plugin 'taiansu/nerdtree-ag'

" ISSUE: https://github.com/joedicastro/dotfiles/issues/12
" Plugin 'terryma/vim-multiple-cursors'
Plugin 'joedicastro/vim-multiple-cursors'

Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-commentary'

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'terryma/vim-expand-region'
Plugin 'jnwhiteh/vim-golang' 
Plugin 'wellle/targets.vim'
Plugin 'wting/rust.vim'
Plugin 'airblade/vim-gitgutter'
call vundle#end()
" }}}
call unite#filters#matcher_default#use(['mathcer_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('default', 'context', {
    \ 'start_insert' : 1,
    \ 'direction': 'botright'
    \ })

" Formatting {{{

set backspace=indent,eol,start

set tabstop=4     " Set the default tabstop

set softtabstop=4
set shiftwidth=4  " Set the default shift width for indents
set smarttab      " Smarter tab levels
set expandtab

" indent setting
set si
set formatoptions+=mM
set smartindent
set cindent
set cinoptions=:s,ps,ts,cs
set cinwords=if,else,while,do,for,switch,case

syntax on

filetype plugin indent on " Automatically detect file types
" }}}

" Visual {{{
set showcmd       " Display incomplete commands
set cursorline    " Highlight the current line
set laststatus=2

" list setting
set list
set listchars=tab:▸-,trail:⋅,extends:❯,precedes:❮
" }}}

" Key mappings {{{

nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :NERDTreeFind<CR>

nnoremap <silent> <F9> :TagbarToggle<CR>

" use left & right key to switch between buffers
noremap <silent> <Left> :bp<CR>
noremap <silent> <Right> :bn<CR>
" map up & down to gk & gj for convenient in wrap model
noremap <Up> gk
noremap <Down> gj
" }}}

" Omnifunc {{{
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
" }}}
