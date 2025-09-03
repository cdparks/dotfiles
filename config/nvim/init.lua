-- Leader
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Required for certain icons/ligatures
vim.g.have_nerd_font = true

-- Sync OS copy/paste
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

local o = vim.opt

-- Enable hybrid line numbering
o.number = true
o.relativenumber = true

-- Already in the status line
o.showmode = false

-- Enable break indent
o.breakindent = true

-- Save undo history
o.undofile = true

-- Ignore case unless \C or capital letters are used
o.ignorecase = true
o.smartcase = true

-- Keep signcolumn on by default
o.signcolumn = "yes"

-- Decrease update time
-- o.updatetime = 250
-- Decrease mapped sequence wait time
-- o.timelinelen = 300

-- Open panes to right and bottom
o.splitbelow = true
o.splitright = true

-- Highlight trailing whitespace
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Highlight current line
o.cursorline = true

-- Show at least 8 lines of context
o.scrolloff = 8

-- Show dialog if operation would fail for unsaved changes
o.confirm = true

-- Highlight searches, search incrementally
o.hlsearch = true
o.incsearch = true

-- Preview substitutions live
o.inccommand = "split"

-- Continue comment marker in new lines
o.formatoptions:append({o = true})

-- Wrap long lines as you type them
o.textwidth = 100

-- Insert 2 spaces when TAB is pressed
o.expandtab = true
o.tabstop = 2

-- Real tabs for Makefiles though
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  group = vim.api.nvim_create_augroup("make.config", { clear = true }),
  pattern = { "make" },
  command = "set noexpandtab"
})

-- Highlight yanked text
autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Indentation amount for < and > commands
o.shiftwidth = 2

-- Use a reasonable file encoding
o.encoding = "utf-8"

-- Disable guicursor
o.guicursor = ""

local opts = { silent = true }
local map = vim.keymap.set

-- Use Esc to exit insert mode in terminal
map("t", "<Esc>", [[<C-\><C-n>]], opts)

-- Use homerow movement keys to move between panes
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Clear search highlights on ESC
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Ignore files ending with these extensions
o.wildignore = o.wildignore + "*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox"
o.wildmode = "longest,list,full"
o.wildmenu = true

-- :Term in horizontal split
vim.api.nvim_create_user_command("Term", function(opts)
    vim.api.nvim_command("split")
    vim.api.nvim_command("terminal")
  end,
  {
    nargs = 0,
    desc = "Open terminal in horizontal split",
    force = true,
  }
)

-- :VTerm in vertical split
vim.api.nvim_create_user_command("VTerm", function(opts)
    vim.api.nvim_command("vsplit")
    vim.api.nvim_command("terminal")
  end,
  {
    nargs = 0,
    desc = "Open terminal in vertical split",
    force = true,
  }
)

-- Install lazy.nvim plugin manager
-- See `:help lazy.nvim.txt`
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = o.rtp
rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  performance = {
    rtp = {
      -- Using a different matchparen below
      disabled_plugins = { "matchparen" }
    }
  },
  spec = {
    -- Solarized color scheme
    {
      "maxmx03/solarized.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        variant = "autumn",
        palette = "selenized",
      },
      ---@type solarized.config
      config = function(_, opts)
        o.termguicolors = true
        o.background = "dark"
        require("solarized").setup(opts)
        vim.cmd.colorscheme "solarized"
      end,
    },

    -- Add git symbols to the gutter
    {
      "lewis6991/gitsigns.nvim",
      opts = {
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      },
    },

    -- Pending keybinds.
    {
      "folke/which-key.nvim",
      event = "VimEnter",
      opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.o.timeoutlen
        delay = 300,
        icons = {
          -- set icon mappings to true if you have a Nerd Font
          mappings = vim.g.have_nerd_font,
          keys = vim.g.have_nerd_font and {}
        },
      },
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
      "nvim-telescope/telescope.nvim",
      event = "VimEnter",
      dependencies = {
        "nvim-lua/plenary.nvim",
        -- If encountering errors, see telescope-fzf-native README for installation instructions
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
          cond = function()
            return vim.fn.executable "make" == 1
          end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
      },
      config = function()
        -- See `:help telescope` and `:help telescope.setup()`

        -- Duplicated because putting this in default.mappings breaks ui-select.
        local split_mappings = {
          mappings = {
            i = {
              ["<CR>"] = "select_vertical",
              ["<C-x>"] = "select_horizontal",
            }
          }
        }

        require("telescope").setup {
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown()
            },
          },
          pickers = {
            find_files = split_mappings,
            live_grep = split_mappings,
            buffers = split_mappings,
          }
        }

        -- Enable Telescope extensions if they are installed
        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        -- See `:help telescope.builtin`
        local builtin = require "telescope.builtin"
        map("n", "<leader>f", builtin.find_files, { desc = "Search [F]iles" })
        map("n", "<leader>l", builtin.live_grep, { desc = "Search by [L]ive Grep" })
        map("n", "<leader>b", builtin.buffers, { desc = "Find existing [B]uffers" })
        map("n", "<leader>o", function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = "Live Grep in [O]pen Files",
          }
        end, { desc = "Search in [O]pen Files" })
      end,
    },

    -- LSPs
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { "mason-org/mason.nvim", opts = {} },
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} },
        "saghen/blink.cmp",
      },

      config = function()
        autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("config.lsp-attach", { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc, mode)
              mode = mode or "n"
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
            end

            -- Rename the variable under your cursor.
            map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

            -- Execute a code action, usually at cursor location
            map("<leader>qf", vim.lsp.buf.code_action, "[Q]uick [F]ix", { "n", "x" })

            -- Find references for the word under your cursor.
            map("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

            -- Jump to the implementation of the word under your cursor
            map("<leader>gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

            -- Jump to the definition of the word under your cursor
            map("<leader>gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

            -- Jump to the declaration of the word under your cursor
            map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

            -- Fuzzy find all the symbols in your current document
            map("<leader>gs", require("telescope.builtin").lsp_document_symbols, "Open Document [S]ymbols")

            -- Fuzzy find all the symbols in your current workspace
            map("<leader>gS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace [S]ymbols")

            -- Jump to the type of the word under your cursor
            map("<leader>gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

            -- Activate picker for open diagnostics
            map("<leader>gx", require("telescope.builtin").diagnostics, "[G]oto Diagnosti[X]")

            -- Open diagnostic float for error at cursor
            map("<leader>df", vim.diagnostic.open_float, "Open [D]iagnostic [F]loat")

            -- Highlight references of the word under your cursor after a bit
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
              local highlight_augroup = vim.api.nvim_create_augroup("config.highlight", { clear = false }),
              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("config.lsp-detach", { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = "config.highlight", buffer = event2.buf }
                end,
              })
            end
          end,
        })

        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
          severity_sort = true,
          float = { border = "rounded", source = "if_many" },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = "󰅚 ",
              [vim.diagnostic.severity.WARN] = "󰀪 ",
              [vim.diagnostic.severity.INFO] = "󰋽 ",
              [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
          } or {},
          virtual_text = {
            source = "if_many",
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          },
        }

        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local servers = {
          clangd = {},
          rust_analyzer = {},
          -- use "mrcjkb/haskell-tools.nvim instead
          -- hls = {}
        }

        local ensure_installed = vim.tbl_keys(servers or {})
        require("mason-tool-installer").setup { ensure_installed = ensure_installed }
        require("mason-lspconfig").setup {
          ensure_installed = {},
          automatic_installation = false,
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
              require("lspconfig")[server_name].setup(server)
            end,
          },
        }
      end
    },

    -- Haskell tools
    {
      "mrcjkb/haskell-tools.nvim",
      version = "^6", -- Recommended
      lazy = false, -- This plugin is already lazy
    },

    -- Autocompletion
    {
      "saghen/blink.cmp",
      event = "VimEnter",
      version = "1.*",
      dependencies = {
        -- Snippet Engine
        {
          "L3MON4D3/LuaSnip",
          version = "2.*",
          build = "make install_jsregexp",
          opts = {},
        },
        "folke/lazydev.nvim",
      },

      --- @module "blink.cmp"
      --- @type blink.cmp.Config
      opts = {
        keymap = {
          -- "default" (<c-y>), "super-tab", "enter", "none"
          preset = "super-tab"
        },
        appearance = { nerd_font_variant = "mono" },
        completion = {
          -- By default, you may press `<c-space>` to show the documentation.
          -- Optionally, set `auto_show = true` to show the documentation after a delay.
          documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },
        sources = {
          default = { "lsp", "path", "snippets", "lazydev" },
          providers = {
            lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
          },
        },
        snippets = { preset = "luasnip" },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
      },
    },

    -- Highlight todo, notes, etc in comments
    {
      "folke/todo-comments.nvim",
      event = "VimEnter",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = { signs = false }
    },

    -- Status line, don"t color git status
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        sections = {
          lualine_b = {
            "branch",
            {
              "diff",
              colored = false
            },
            "diagnostics",
          }
        }
      }
    },

    -- Use treesitter for syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      main = "nvim-treesitter.configs",
      opts = {
        ensure_installed = {
          "bash",
          "c",
          "diff",
          "haskell",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "printf",
          "python",
          "query",
          "regex",
          "rust",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      },
    },

    -- Matching parens w/ treesitter
    {
      "monkoose/matchparen.nvim",
      opts = {},
    },
  }
})

-- Bold the heck out of matching parens
vim.api.nvim_set_hl(0, "MatchParen", {
  fg = "#002B36", -- solarized background
  bg = "#FFAC1C", -- bright orange
  bold = true,
})
