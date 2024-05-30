vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.scrolloff = 5

vim.g.mapleader = " "

vim.cmd([[
  autocmd FileType javascript setlocal softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType javascript.jsx setlocal softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType c setlocal softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType cpp setlocal softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType make setlocal softtabstop=4 shiftwidth=4 tabstop=4 noexpandtab
  autocmd FileType yaml setlocal softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType lua setlocal softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd FileType jenkinsfile setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  autocmd BufNewFile,BufReadPost *.imd set filetype=markdown
  autocmd BufNewFile,BufReadPost .babelrc set filetype=json
  autocmd BufNewFile,BufReadPost *.gyp set filetype=json
  autocmd BufNewFile,BufReadPost .gitlab-ci set filetype=yaml
  autocmd BufNewFile,BufReadPost *.tpl set filetype=gotexttmpl
  autocmd FileType markdown set colorcolumn=120
]])
