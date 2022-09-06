set expandtab
set shiftwidth=4
set smartindent
set tabstop=4 softtabstop=4

set exrc
set guicursor=
set relativenumber
set nu
set hidden
set nohlsearch
set noerrorbells
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

set incsearch
set termguicolors
set scrolloff=8

set colorcolumn=120
hi ColorColumn ctermbg=yellow guibg=yellow
set signcolumn=yes
set cmdheight=2
set updatetime=50

set smarttab
set showmatch
set encoding=utf-8
set hidden
set dir=~/tmp

set shortmess+=c

call plug#begin('~/.vim/plugged')
    Plug 'nvim-lua/plenary.nvim'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'gruvbox-community/gruvbox'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'neovim/nvim-lspconfig'
    Plug 'mbbill/undotree'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'preservim/nerdcommenter'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    Plug 'f-person/git-blame.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'ryanoasis/vim-devicons'
call plug#end()

colorscheme gruvbox
highlight Normal guibg=none

filetype plugin indent on

" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_def_mapping_enabled = 0

" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1

" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let mapleader=" "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>l <C-w>w
nnoremap <leader>h <C-w>W

autocmd FileType go nmap <leader>gob :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>gor  <Plug>(go-run)
autocmd FileType go nmap <leader>got  <Plug>(go-test)
autocmd FileType go nmap <leader>gtj :CocCommand go.tags.add json<cr>
autocmd FileType go nmap <leader>gty :CocCommand go.tags.add yaml<cr>
autocmd FileType go nmap <leader>gtx :CocCommand go.tags.clear<cr>

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()

function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

set guifont=DroidSansMono_Nerd_Font:h11
let g:airline_powerline_fonts = 1

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt

let g:coc_snippet_next = '<tab>'

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

lua require'lspconfig'.bashls.setup{}
lua require'lspconfig'.gopls.setup{}
lua require'lspconfig'.yamlls.setup{}

autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
