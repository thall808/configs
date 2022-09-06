source ~/.config/nvim/plugins.vim
source ~/.config/nvim/sets.vim
source ~/.config/nvim/lets.vim
source ~/.config/nvim/keymaps.vim

colorscheme gruvbox
highlight Normal guibg=none

filetype plugin indent on

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

lua require'lspconfig'.bashls.setup{}
lua require'lspconfig'.gopls.setup{}
lua require'lspconfig'.yamlls.setup{}

autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
