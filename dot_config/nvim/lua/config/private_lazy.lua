-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "pappasam/papercolor-theme-slim",
      priority = 1000,
      config = function()
        vim.opt.termguicolors = true
        vim.opt.background = "light"
        vim.cmd.colorscheme("PaperColorSlimLight")
      end
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "bashls",
          "clangd",
          "cssls",
          "docker_compose_language_service",
          "dockerls",
          "expert",
          "hls",
          "html",
          "jsonls",
          "lua_ls",
          "marksman",
          "pyright",
          "sqlls",
          "tailwindcss",
          "taplo",
          "ts_ls",
          "yamlls",
          "zls",
        },
        automatic_enable = {
          exclude = { "rust_analyzer", "elixirls" },
        },
        handlers = {
          rust_analyzer = function() end,
        },
      },
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").install({
          "bash",
          "c",
          "cpp",
          "css",
          "dockerfile",
          "eex",
          "elixir",
          "heex",
          "html",
          "javascript",
          "json",
          "lua",
          -- markdown/markdown_inline intentionally omitted: neovim 0.12 bundles a
          -- matching parser+queries pair. Installing nvim-treesitter's grammar here
          -- crosses its parser with neovim's bundled queries (different versions),
          -- which crashes the highlighter (Invalid field name "operator").
          "python",
          "query",
          "rust",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        })

        -- main branch has no highlight/indent modules; enable per-buffer.
        vim.api.nvim_create_autocmd("FileType", {
          callback = function(args)
            local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
            if not lang then
              return
            end
            -- start() errors when the parser isn't installed yet; guard it.
            if not pcall(vim.treesitter.start, args.buf, lang) then
              return
            end
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
      end
    },
    {
      "saghen/blink.cmp",
      version = "1.*",
      dependencies = {
        "rafamadriz/friendly-snippets"
      },
      opts = {
        keymap = {
          preset = "super-tab"
        },
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
        },
        sources = {
          default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
          },
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning",
        },
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup({
          defaults = {
            file_ignore_patterns = { "node_modules", ".git/" },
          },
        })

        telescope.load_extension("fzf")

        vim.keymap.set("n", "<C-f>", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<C-g>", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<C-b>", builtin.buffers, { desc = "Buffers" })

        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
        vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
        vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
        vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        vim.keymap.set("n", ",nn", "<CMD>Neotree toggle<CR>", { desc = "Toggle file tree" })
      end,
    },
    {
      "stevearc/oil.nvim",
      config = function()
        require("oil").setup({
          default_file_explorer = true,
          view_options = {
            show_hidden = true,
          },
        })

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      end,
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer local keymaps",
        },
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      opts = {
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local opts = function(desc)
            return { buffer = bufnr, desc = desc }
          end

          vim.keymap.set("n", "]h", gs.next_hunk, opts("Next hunk"))
          vim.keymap.set("n", "[h", gs.prev_hunk, opts("Previous hunk"))
          vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts("Stage hunk"))
          vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts("Reset hunk"))
          vim.keymap.set("n", "<leader>hb", gs.blame_line, opts("Blame line"))
          vim.keymap.set("n", "<leader>hd", gs.diffthis, opts("Diff this"))
        end,
      },
    },
    {
      "NeogitOrg/neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
      },
      config = function()
        local neogit = require("neogit")
        neogit.setup({})

        vim.keymap.set("n", "<leader>gg", neogit.open, { desc = "Neogit" })
        vim.keymap.set("n", "<leader>gc", function()
          neogit.open({ "commit" })
        end, { desc = "Neogit commit" })
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {
        indent = {
          char = "│",
        },
        scope = {
          enabled = true,
        },
      },
    },
    {
      "zeioth/garbage-day.nvim",
      dependencies = "neovim/nvim-lspconfig",
      event = "VeryLazy",
      opts = {},
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
      },
    },
    {
      "mrcjkb/rustaceanvim",
      version = "^8",
      lazy = false,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "PaperColorSlimLight", "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.lsp.config("sourcekit", {
  cmd = { "xcrun", "sourcekit-lsp" },
  filetypes = { "swift", "objc", "objcpp" },
})
vim.lsp.enable("sourcekit")

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float({ focusable = false })
  end,
})

vim.opt.updatetime = 250
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:6,hor:3"

local function read_branch(cwd)
  local git = vim.fs.find(".git", { path = cwd, upward = true })[1]
  if not git then return nil end
  local stat = vim.uv.fs_stat(git)
  local head_path
  if stat and stat.type == "directory" then
    head_path = git .. "/HEAD"
  else
    local fh = io.open(git, "r"); if not fh then return nil end
    local line = fh:read("*l"); fh:close()
    local gd = line and line:match("^gitdir:%s*(.+)$")
    if not gd then return nil end
    if not gd:match("^/") then
      gd = vim.fs.normalize(vim.fs.dirname(git) .. "/" .. gd)
    end
    head_path = gd .. "/HEAD"
  end
  local fh = io.open(head_path, "r"); if not fh then return nil end
  local head = fh:read("*l"); fh:close()
  if not head then return nil end
  return head:match("ref: refs/heads/(.+)$") or head:sub(1, 7)
end

local function refresh_tab(tabid)
  tabid = tabid or vim.api.nvim_get_current_tabpage()
  local tabnr = vim.api.nvim_tabpage_get_number(tabid)
  local cwd = vim.fn.getcwd(-1, tabnr)
  vim.api.nvim_tabpage_set_var(tabid, "branch", read_branch(cwd) or "")
  vim.api.nvim_tabpage_set_var(tabid, "tabcwd", cwd)
end

function _G.tabline()
  local parts = {}
  local cur = vim.fn.tabpagenr()
  for i = 1, vim.fn.tabpagenr("$") do
    local tabid = vim.api.nvim_list_tabpages()[i]
    local ok_b, branch = pcall(vim.api.nvim_tabpage_get_var, tabid, "branch")
    local ok_c, cwd = pcall(vim.api.nvim_tabpage_get_var, tabid, "tabcwd")
    if not ok_c or cwd == "" then cwd = vim.fn.getcwd(-1, i) end
    local name = vim.fn.fnamemodify(cwd, ":t")
    local label = name
    if ok_b and branch ~= "" then label = name .. " [" .. branch .. "]" end
    local hl = (i == cur) and "%#TabLineSel#" or "%#TabLine#"
    parts[#parts + 1] = hl .. "%" .. i .. "T " .. label .. " "
  end
  parts[#parts + 1] = "%#TabLineFill#%T"
  return table.concat(parts)
end

vim.api.nvim_create_autocmd(
  { "TabEnter", "TabNew", "DirChanged", "BufEnter", "FocusGained" },
  { callback = function() refresh_tab() end }
)

vim.opt.tabline = "%!v:lua.tabline()"
vim.opt.showtabline = 2
