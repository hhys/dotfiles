filetype off

" NeoBundle {{{
if has('vim_starting')
  set nocompatible               " Be iMproved
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'itchyny/lightline.vim'        " ステータスバー
NeoBundle 'tyru/current-func-info.vim'   " ステータスバーに関数名を表示する
NeoBundle 'scrooloose/syntastic.git'     " シンタックスチェック

" コード補完
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'marcus/rsense'
NeoBundle 'supermomonga/neocomplete-rsense.vim'

NeoBundle 'Shougo/unite.vim'             " ファイルオープン
NeoBundle 'Shougo/neomru.vim'            " 最近開いたファイル

NeoBundle 'tomasr/molokai'               " colorscheme
NeoBundle 'bronson/vim-trailing-whitespace' " 行末のスペース

" FileType
NeoBundle 'hhys/yaml-vim'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'Keithbsmiley/rspec.vim'
NeoBundle '5t111111/neat-json.vim'       " JSON を整形して表示(:NeatJson)
NeoBundle 'elzr/vim-json'                " JSON filetype
NeoBundle 'kchmck/vim-coffee-script'     " CoffeeScript

NeoBundle 'AndrewRadev/switch.vim'       " 例えば true を false に変換する

NeoBundle 'tomtom/tcomment_vim'          " コメント・アンコメントをトグル(Ctrl+-, gcc)
NeoBundle 'nathanaelkane/vim-indent-guides'  " インデントに色を付ける

" Markdown syntax
NeoBundle "godlygeek/tabular"
NeoBundle "joker1007/vim-markdown-quote-syntax"
NeoBundle "rcmdnk/vim-markdown"

" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()


" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"}}}

" モードライン
set modeline
set modelines=3

" ヒストリー
set history=40

" 入力中のコマンドを表示
set showcmd

" 検索
set incsearch
set hlsearch

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

syntax enable

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" indent {{{
set autoindent
set smartindent

au BufNewFile,BufRead *.html set tabstop=2 shiftwidth=2 expandtab
au BufNewFile,BufRead *.htm set tabstop=2 shiftwidth=2 expandtab
au BufNewFile,BufRead *.php set tabstop=2 shiftwidth=2 expandtab
au BufNewFile,BufRead *.rake set tabstop=2 shiftwidth=2 expandtab
au BufNewFile,BufRead *.yml set tabstop=2 shiftwidth=2 expandtab
au FileType ruby,eruby set tabstop=2 shiftwidth=2 expandtab
au FileType javascript,coffee set tabstop=2 shiftwidth=2 expandtab
au FileType css,scss set tabstop=2 shiftwidth=2 expandtab
" }}}

" colorscheme {{{
set t_Co=256
"colorscheme elflord
autocmd colorscheme molokai highlight Visual ctermbg=6   " 反転を見やすく
colorscheme molokai
let g:molokai_original = 1
"let g:rehash256 = 1
set background=dark
" }}}

" 文字・改行コードの自動認識 {{{
" http://www.kawaz.jp/pukiwiki/?vim#content_1_7
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" }}}

" 全角スペースの表示 {{{
" http://inari.hatenablog.com/entry/2014/05/05/231307
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif
" }}}

" ステータスバー(LightLine) {{{
set laststatus=2
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ ['mode', 'paste'], ['readonly', 'filename', 'methodname', 'modified'] ],
  \   'right': [ [ 'syntastic', 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component_expand': {
  \   'methodname': 'cfi#get_func_name',
  \   'syntastic': 'SyntasticStatuslineFlag',
  \ },
  \ 'component_type': {
  \   'syntastic': 'error',
  \ }
\ }
" 関数名を表示する
" cfi#get_func_name を componet_expand で指定するとカーソル移動毎に
" 呼ばれるので vim の動作が遅くなってしまう。
" component_expand は call lightline#update() を実行すると更新される。
" CursorHold により、カーソル移動完了後、updatetime 経過後にステータス
" バーを更新する様にしている。
set updatetime=800
autocmd CursorHold,CursorHoldI * call lightline#update()

" 保存時にシンタックスチェックを行う
let g:syntastic_mode_map = { 'mode': 'passive' }
augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.rb call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction
"}}}

" Rsense {{{
" let g:rsenseHome = '/usr/local/lib/rsense-0.3'
" let g:rsenseUseOmniFunc = 1
"
" function! SetupRubySetting()
"   nmap <buffer>rj :RSenseJumpToDefinition<CR>
"   nmap <C-w> :RSenseWhereIs<CR>
"   nmap <buffer>rj :RSenseTypeHelp<CR>
" endfunction
" aug MyAutoCmd
"   au FileType ruby,eruby,ruby.rspec call SetupRubySetting()
" aug END
"}}}

" Unit.vim {{{
" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
" 入力モードで開始する
" let g:unite_enable_start_insert=1
" バッファ一覧
noremap <C-U><C-B> :Unite buffer<CR>
" ファイル一覧
noremap <C-U><C-F> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-U><C-R> :Unite file_mru<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap <C-U><C-D> :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
" }}}

" Markdown {{{
let g:vim_markdown_liquid=1
let g:vim_markdown_frontmatter=1
let g:vim_markdown_math=1
au BufRead,BufNewFile *.{txt,text} set filetype=markdown
" }}}

" switch.vim {{{
" - （ハイフン）でトグル
"nnoremap + :call switch#Switch(g:variable_style_switch_definitions)<cr>
nnoremap - :Switch<cr>
" }}}

" vim-indent-guides {{{
" let g:indent_guides_enable_on_vim_startup=1
" let g:indent_guides_start_level=2
" let g:indent_guides_auto_colors=0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=234
" let g:indent_guides_color_change_percent = 30
" let g:indent_guides_guide_size = 1
" }}}

filetype plugin indent on

" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0
