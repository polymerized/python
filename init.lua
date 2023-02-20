require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nyoom-engineering/oxocarbon.nvim'
  
  use {'neoclide/coc.nvim', branch = 'release'}

  vim.opt.background = "dark"
  vim.cmd.colorscheme "oxocarbon"

  vim.cmd [[ nmap <silent> gd :call CocAction('jumpDefinition', 'split')<CR> ]]
  vim.cmd [[ set splitbelow ]]
end)