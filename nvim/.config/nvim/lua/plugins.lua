local cmd = vim.cmd -- to execute vim commands without any output
local fn = vim.fn -- to execute vim functions

-- Install packer.nvim, if it is not yet installed {{{1
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  if
    fn.input("Packer not installed! Download and install packer.nvim? [Y/n] ")
    == "n"
  then
    return
  end
  print(" ")
  local out = fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print(out)
  cmd([[packadd packer.nvim]])
  print(
    "Installation of packer.nvim successfull. Run :PackerSync to download",
    "and install all plugins. In case of failures rerun :PackerSync until the",
    "the installation succeeeds."
  )
else
--	print("Packer is installed!")
end

-- Run PackerCompile automatically whenever plugins.lua is updated
cmd([[autocmd BufWritePost plugins.lua PackerCompile]])

-- Plugin specification {{{1
require("packer").startup({
  function(use)
    -- Packer can manage itself
    use({ "wbthomason/packer.nvim" })
    -- Colors
    use({
      "delafthi/nord.nvim",
      branch = "devel",
      setup = require("config.nord").setup(),
      config = require("config.nord").config(),
    })

-- Markdown Preview
    use({
      "iamcco/markdown-preview.nvim",
      run = "cd app && yarn install",
      ft = { "markdown", "mkd" },
      setup = require("config.markdown-preview").setup(),
      config = require("config.markdown-preview").config(),
    })

-- Start screen
    use({
      "glepnir/dashboard-nvim",
      setup = require("config.dashboard").setup(),
    })

-- Fuzzy finder
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzy-native.nvim" },
      },
      config = require("config.telescope").config(),
    })

-- Syntax highlighting
    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "p00f/nvim-ts-rainbow",
      },
      run = ":TSUpdate",
      config = require("config.nvim-treesitter").config(),
    })
    use({
      "norcalli/nvim-colorizer.lua",
      config = require("config.nvim-colorizer").config(),
    })
    use({
      "lewis6991/spellsitter.nvim",
      run = ":set spell",
      config = require("config.spellsitter").config(),
    })
    use({
      "folke/todo-comments.nvim",
      config = require("config.todo-comments").config(),
    })

-- Statusline
--[[    
    use({
      "glepnir/galaxyline.nvim",
      branch = "main",
      requires = {
        { "kyazdani42/nvim-web-devicons", opt = true },
        "shaunsingh/nord.nvim",
      },
      config = require("config.galaxyline").config(),
    })
--]]

    end,
  config = { display = { open_fn = require("packer.util").float } },
})
