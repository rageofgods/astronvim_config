return {
  colorscheme = "onedark",
  plugins = {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        window = {
          width = 60,
        },
      },
    },
    {
      "goolord/alpha-nvim",
      opts = function(_, opts)      -- override the options using lazy.nvim
        opts.section.header.val = { -- change the header section value
          [[                                                                       ]],
          [[  ██████   █████                   █████   █████  ███                  ]],
          [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
          [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
          [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
          [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
          [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
          [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
          [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
          [[                                                                       ]],
        }
      end,
    },
    {
      "navarasu/onedark.nvim",
      -- lazy = false,
      config = function()
        require("onedark").setup {
          style = "darker",
        }
      end,
    },
    {
      "aaronhallaert/advanced-git-search.nvim",
      config = function() require("telescope").load_extension "advanced_git_search" end,
      dependencies = {
        "nvim-telescope/telescope.nvim",
        -- to show diff splits and open commits in browser
        "tpope/vim-fugitive",
      },
    },
    {
      "petertriho/nvim-scrollbar",
      ft = "*",
      config = function()
        require("scrollbar").setup {
          handlers = {
            gitsigns = true,
          },
        }
      end,
    },
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require "astronvim.utils.status"

        opts.winbar = {
          -- create custom winbar
          static = {
            disabled = {
              -- set buffer and file types to disable winbar
              buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
              filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
            },
          },
          -- store the current buffer number
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false, -- pick the correct winbar based on condition
          {
            -- disabled buffer/file winbar
            condition = function(self)
              return vim.opt.diff:get() or status.condition.buffer_matches(self.disabled or {})
            end,
            init = function() vim.opt_local.winbar = nil end,
          },
          {
            -- inactive winbar
            condition = function() return not status.condition.is_active() end,
            -- show the path to the file relative to the working directory
            status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
            -- add the file name and icon
            status.component.file_info {
              file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
              file_modified = false,
              file_read_only = false,
              hl = status.hl.get_attributes("winbarnc", true),
              surround = false,
              update = "BufEnter",
            },
          },
          { -- active winbar
            -- show the path to the file relative to the working directory
            status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
            -- add the file name and icon
            status.component.file_info { -- add file_info to breadcrumbs
              file_icon = { hl = status.hl.filetype_color, padding = { left = 0 } },
              file_modified = false,
              file_read_only = false,
              hl = status.hl.get_attributes("winbar", true),
              surround = false,
              update = "BufEnter",
            },
            -- show the breadcrumbs
            status.component.breadcrumbs {
              icon = { hl = true },
              hl = status.hl.get_attributes("winbar", true),
              prefix = true,
              padding = { left = 0 },
            },
          },
        }

        return opts
      end,
    },
    {
      "folke/twilight.nvim",
      config = function()
        require("twilight").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end,
    },
    {
      "folke/zen-mode.nvim",
      cmd = { "ZenMode" },
      opts = {
        window = {
          backdrop = 0.90, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
          -- height and width can be:
          -- * an absolute number of cells when > 1
          -- * a percentage of the width / height of the editor when <= 1
          -- * a function that returns the width or the height
          width = 120, -- width of the Zen window
          height = 1,  -- height of the Zen window
          -- by default, no options are changed for the Zen window
          -- uncomment any of the options below, or add other vim.wo options you want to apply
          options = {
            -- signcolumn = "no", -- disable signcolumn
            -- number = false, -- disable number column
            -- relativenumber = false, -- disable relative numbers
            -- cursorline = false, -- disable cursorline
            -- cursorcolumn = false, -- disable cursor column
            -- foldcolumn = "0", -- disable fold column
            -- list = false, -- disable whitespace characters
          },
        },
        plugins = {
          -- disable some global vim options (vim.o...)
          -- comment the lines to not apply the options
          options = {
            enabled = true,
            ruler = false,                -- disables the ruler text in the cmd line area
            showcmd = false,              -- disables the command in the last line of the screen
          },
          twilight = { enabled = true },  -- enable to start Twilight when zen mode opens
          gitsigns = { enabled = false }, -- disables git signs
          tmux = { enabled = true },      -- disables the tmux statusline
          -- this will change the font size on kitty when in zen mode
          -- to make this work, you need to set the following kitty options:
          -- - allow_remote_control socket-only
          -- - listen_on unix:/tmp/kitty
          kitty = {
            enabled = false,
            font = "+4", -- font size increment
          },             -- this will change the font size on alacritty when in zen mode
          -- requires  Alacritty Version 0.10.0 or higher
          -- uses `alacritty msg` subcommand to change font size
          alacritty = {
            enabled = false,
            font = "16", -- font size
          },
        },
      },
    },
  },
}
