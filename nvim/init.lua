vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable relative line numbers
vim.opt.relativenumber = true

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  { "FabijanZulj/blame.nvim" },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox-material',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    opts = {
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',        opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      }
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  { 'mrjones2014/smart-splits.nvim' },
  { 'sainnhe/gruvbox-material' },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies =
    'nvim-tree/nvim-web-devicons'
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
  },
  { 'cormacrelf/dark-notify' },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true,   -- enables the Noice cmdline UI
        view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = {},        -- global options for the cmdline. See section on views
        ---@type table<string, CmdlineFormat>
        format = {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          -- title: set to anything or empty string to hide
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          input = {}, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
        },
      },
      messages = {
        enabled = false,
      },
      popupmenu = {
        enabled = false, -- enables the Noice popupmenu UI
      },
      -- You can add any custom commands below that will be available with `:Noice command`
      ---@type table<string, NoiceCommand>
      notify = {
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
        message = {
          enabled = false,
        },
      },
      health = {
        checker = false,
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },

  { 'nvim-telescope/telescope-ui-select.nvim' },
  {
    'folke/trouble.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require(
        'trouble').setup()
    end
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function() require("bufferline").setup({}) end
  },
  { 'fedepujol/move.nvim' },
  {
    'simrat39/inlay-hints.nvim',
    config = function()
      require('inlay-hints').setup()
    end
  },
  { 'simrat39/rust-tools.nvim' },
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup({
        floating_window = true,
        handler_opts = {
          border = "none"
        },
        hint_prefix = '',
        max_height = 30,
        max_width = 140,
        doc_lines = 15,
        hint_enable = false,
        toggle_key = '<M-x>',
        toggle_key_flip_floatwin_setting = true
      })
    end
  },
  { 'rust-lang/rust.vim' },
  {
    'folke/lsp-colors.nvim',
    config = function()
      require('lsp-colors').setup()
    end
  },
  {
    'SmiteshP/nvim-navic',
    requires = 'neovim/nvim-lspconfig',
    config = function()
      require('nvim-navic').setup {
        icons = {
          File = ' ',
          Module = ' ',
          Namespace = ' ',
          Package = ' ',
          Class = ' ',
          Method = ' ',
          Property = ' ',
          Field = ' ',
          Constructor = ' ',
          Enum = ' ',
          Interface = ' ',
          Function = ' ',
          Variable = ' ',
          Constant = ' ',
          String = ' ',
          Number = ' ',
          Boolean = ' ',
          Array = ' ',
          Object = ' ',
          Key = ' ',
          Null = ' ',
          EnumMember = ' ',
          Struct = ' ',
          Event = ' ',
          Operator = ' ',
          TypeParameter = ' '
        },

        highlight = false,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true
      }
    end
  },

  {
    'lvimuser/lsp-inlayhints.nvim',
    config = function()
      require("lsp-inlayhints").setup({
        inlay_hints = {
          parameter_hints = {
            show = true,
            prefix = "<- ",
            separator = ", ",
            remove_colon_start = true,
            remove_colon_end = true,
          },
          type_hints = {
            -- type and other hints
            show = true,
            prefix = "  ",
            separator = ", ",
            remove_colon_start = true,
            remove_colon_end = true,
          },
          only_current_line = false,
          -- separator between types and parameter hints. Note that type hints are
          -- shown before parameter
          labels_separator = "  ",
          -- whether to align to the length of the longest line in the file
          max_len_align = false,
          -- padding from the left if max_len_align is true
          max_len_align_padding = 1,
          -- highlight group
          highlight = "Comment",
          -- virt_text priority
          priority = 0,
        },
        enabled_at_startup = true,
        debug_mode = false,
      })
    end
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          -- accept = false, -- disable built-in keymapping
        },
      })

      -- hide copilot suggestions when cmp menu is open
      -- to prevent odd behavior/garbled up suggestions
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if cmp_status_ok then
        cmp.event:on("menu_opened", function()
          vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
          vim.b.copilot_suggestion_hidden = false
        end)
      end

      -- disable copilot if we are in a private project
    end,
  },

  {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require "octo".setup()
    end
  },

  {
    "gbprod/yanky.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    config = function()
      -- optional: setup telescope before loading the extension
      require("telescope").setup {
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {
            diff_plugin = "diffview",
          }
        }
      }

      require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
      --- See dependencies
    },
  },

  {
    "tversteeg/registers.nvim",
    cmd = "Registers",
    config = true,
    keys = {
      { "\"",    mode = { "n", "v" } },
      { "<C-R>", mode = "i" }
    },
    name = "registers",
  },

  { 'mfussenegger/nvim-lint' },
}, {})
-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
require('dark_notify').run()
require("ibl").setup {
  -- indent = { char = "┊" },
  -- whitespace = { highlight = { "Whitespace", "NonText" } },
  indent = { highlight = { "Whitespace", "NonText" }, char = "┊" },
  whitespace = {
    remove_blankline_trail = false,
  },
  scope = { show_start = false },
}
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

vim.o.background = "dark"
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set colorscheme
vim.o.termguicolors = true
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_foreground = 'mix'
vim.g.gruvbox_material_cursor = 'orange'
-- vim.g.gruvbox_material_dim_inactive_windows = 1
-- vim.g.gruvbox_material_visual = 'reverse'
vim.g.gruvbox_material_sign_column_background = 'grey'
vim.g.gruvbox_material_menu_selection_background = 'yellow'
vim.g.gruvbox_material_float_style = 'dim'
-- vim.g.gruvbox_material_diagnostic_text_highlight = 1
-- grpid = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', {})
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   group = grpid,
--   pattern = 'gruvbox-material',
--   command = -- floating popups
--   -- 'hi NormalFloat guibg=#282828 |' ..
--   -- 'hi FloatBorder guibg=#282828'
-- })


vim.cmd [[colorscheme gruvbox-material]]

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local fb_actions = require "telescope._extensions.file_browser.actions"
require('telescope').setup {
  extensions = {
    file_browser = {
      auto_depth = true,
      select_buffer = true,
      grouped = true,
      respect_gitignore = false,
      -- collapse_dirs = true,
      initial_mode = "normal",
      -- theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["H"] = fb_actions.toggle_hidden,
        },
      },
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
        previewer = false,
        borderchars = {
          prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
          results = { " " },
          preview = { " " },
        },
      }
    }
  },
  defaults = {
    color_devicons = true,
    -- border = true,
    selection_caret = "» ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.60,
        results_width = 0.60,
      },
      vertical = {
        mirror = false,
      },
      width = 0.85,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    -- file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    -- path_display = { "truncate = 3" },
    -- border = {
    --   prompt = { 1, 1, 1, 1 },
    --   results = { 1, 1, 1, 1 },
    --   preview = { 1, 1, 1, 1 },
    -- },
    -- borderchars = {
    --   prompt = { " ", " ", "─", "│", "│", " ", "─", "└" },
    --   results = { "─", " ", " ", "│", "┌", "─", " ", "│" },
    --   preview = { "─", "│", "─", "│", "┬", "┐", "┘", "┴" },
    -- },
    winblend = 0,
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Load Telescope extensions
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("undo")

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          -- ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          -- ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  require("lsp-inlayhints").on_attach(client, bufnr, true)

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register({
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {
  --   hints = {
  --     assignVariableTypes = true,
  --     compositeLiteralFields = true,
  --     constantValues = true,
  --     functionTypeParameters = true,
  --     parameterNames = true,
  --     rangeVariableTypes = true
  --   }
  -- },
  -- rust_analyzer = {},
  tsserver = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    },
    pyright = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    },

    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    }
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' }
      },
    },
  },
}

-- Update gutter signs for LSP diagnostics
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = false

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

require("lspconfig").gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
  init_options = {
    usePlaceholders = true,
  },
})
-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}


local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
cmp.setup {
  enabled = function()
    if require "cmp.config.context".in_treesitter_capture("comment") == true or require "cmp.config.context".in_syntax_group("Comment") then
      return false
    else
      return true
    end
  end,

  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind

      -- Source
      -- vim_item.menu = ({
      --   nvim_lsp = "[LSP]",
      --   buffer = "[Buffer]",
      --   luasnip = "[Snip]",
      --   nvim_lua = "[Lua]",
      --   treesitter = "[Treesitter]",
      --   path = "[Path]",
      --   nvim_lsp_signature_help = "[Signature]",
      -- })[entry.source.name]
      -- if vim_item ~= "Snippet" then
      return vim_item
      -- end
      -- end
    end,
  },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox-material',
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
    },
      'searchcount',
      'diff'
    },
    lualine_x = {
      {
        'diagnostics',
        sources = { "nvim_diagnostic" },
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = ' '
        }
      },
      'encoding',
      'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'fugitive' }
}
local neogit = require('neogit')
neogit.setup {
  disable_line_numbers = true,
}
-- vim.keymap.set('n', '<leader>c', '<Cmd>BufferClose<CR> ', { desc = '[C]lose Buffer' })
vim.keymap.set('n', '<leader>q', '[[<C-w>q]] ', { desc = '[Q]uit current window' })

-- Resume latest Telescope window
-- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- LazyGit
vim.keymap.set('n', '<leader>lg', '<Cmd>LazyGit<CR> ', { desc = '[L]azy[G]it' })

-- Close current buffer
vim.keymap.set('n', '<leader>bc', '<Cmd>bd<CR>', { desc = '[B]uffer [C]lose' })

-- Keymaps for moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = 'Move to below split' })
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = 'Move to above split' })
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = 'Move to right split' })

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Keymaps for moving beween open buffers
vim.keymap.set('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Move to previous buffer' })
vim.keymap.set('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Move to next buffer' })

-- Keymap for toggling the Telescope file browser
vim.keymap.set('n', '<leader>e', '<Cmd>Telescope file_browser<CR>', { desc = 'File [E]xplorer' })
-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<leader>e",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)

-- Keymaps for Trouble
vim.keymap.set('n', '<leader>tt', '<Cmd>TroubleToggle<CR> ', { desc = '[T]oggle [T]rouble list' })

vim.keymap.set('n', '<leader>u', '<Cmd>Telescope undo<CR>', { desc = "[U]ndo tree" })


vim.keymap.set('n', '<leader>gg', '<Cmd>Neogit kind=auto<CR>', { desc = 'Open Neogit' })
-- Map jj and jk to Escape
vim.keymap.set('i', 'jk', '<Esc>')


-- Move lines and blocks
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)

vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    previewer = false,
    -- borderchars = {
    --   prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
    --   results = { " " },
    --   preview = { " " },
    -- },

  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
vim.cmd [[let &fcs='eob: ']]
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
  }
)
vim.cmd [[set cmdheight=0]]
vim.cmd [[set winbar+=%{%v:lua.require'nvim-navic'.get_location()%}]]
vim.cmd [[set tabstop=4]]
vim.cmd [[set shiftwidth=4]]

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, bufnr, true)
  end,
})

vim.cmd [[hi! link LspInlayHint Comment]]
vim.cmd [[set ttyfast]]
vim.cmd [[:command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1)]]
vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal number]]
vim.cmd [[:hi NonText guifg=bg]]
vim.cmd [[set guicursor=n-v-c-i:block]]
vim.api.nvim_set_keymap('i', '<S-Del>', '<Nop>', { noremap = true, silent = true })

vim.cmd([[autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)]])

vim.cmd [[:Copilot disable]]


vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

vim.keymap.set({ "n", "x" }, "ys", ":YankyRingHistory<CR>")



-- vim.cmd [[
--   hi TelescopeBorder guibg=#1b1b1b
--   hi TelescopePromptNormal guibg=#1b1b1b
--   hi TelescopeResultsNormal guibg=#1b1b1b
--   hi TelescopePreviewNormal guibg=#1b1b1b
-- ]]
