--------------------------------------------------------------------
-- Basic Settings
--------------------------------------------------------------------
-- Set leader key to space (must be set before any leader keymaps)
vim.g.mapleader = " "

vim.g.vim_home_path = "~/.vim"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.background = "dark"
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.cmd('syntax enable')

--------------------------------------------------------------------
-- GitHub Theme (Treesitter supported)
--------------------------------------------------------------------
require('github-theme').setup({
  options = {
    theme_style = "dark_default",  -- dark_default, dark, dark_dimmed, dark_high_contrast, dark_colorblind
    transparent = false,
    terminal_colors = true,
    dim_inactive = false,
    module_default = true,
  }
})
vim.cmd('colorscheme github_dark_default')

--------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

require'nvim-treesitter.configs'.setup {
  -- Enable syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  -- Enable indentation
  indent = {
    enable = true,
  },

  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

--------------------------------------------------------------------
-- Conform (formatter)
--------------------------------------------------------------------
require("conform").setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    go = { "gofmt", "goimports" },  -- Add Go formatters
  },
  format_on_save = {
    lsp_format = "fallback",  -- Use LSP if no formatter configured
    timeout_ms = 500,
  },
})

--------------------------------------------------------------------
-- llama-vim (C only, via Ollama)
--------------------------------------------------------------------
vim.g.llama_config = {
  endpoint_fim = "http://127.0.0.1:11434/api/generate",
  auto_fim = false,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.g.llama_config = vim.tbl_extend("force", vim.g.llama_config, { auto_fim = true })
  end,
})

--------------------------------------------------------------------
-- Gitsigns
--------------------------------------------------------------------
require('gitsigns').setup()

--------------------------------------------------------------------
-- LSP Configuration
--------------------------------------------------------------------
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_command([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    ]])
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
end

-- Configure LSP servers using vim.lsp.config (Neovim 0.11+)
vim.lsp.config.gopls = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  on_attach = on_attach,
}

vim.lsp.config.clangd = {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
  on_attach = on_attach,
}

vim.lsp.config.zls = {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "zls.json", "build.zig", ".git" },
  on_attach = on_attach,
  settings = {
    zls = {
      enable_inlay_hints = true,
      enable_semantic_tokens = true,
      enable_ast_check_diagnostics = true,
      enable_import_embedfile_subcommand = true,
      enable_autofix = true,
      enable_document_symbols = true,
      enable_completion = true,
      enable_go_to_definition = true,
      enable_hover = true,
      enable_references = true,
      enable_rename = true,
      enable_signature_help = true,
      enable_snippets = true,
      enable_type_information = true,
      enable_workspace_symbols = true,
      enable_format = true,
      enable_incremental_sync = true,
      enable_std_references = true,
      enable_std_symbols = true,
      enable_std_completion = true,
      enable_std_go_to_definition = true,
      enable_std_hover = true,
      enable_std_references = true,
      enable_std_rename = true,
      enable_std_signature_help = true,
      enable_std_snippets = true,
      enable_std_type_information = true,
      enable_std_workspace_symbols = true,
    }
  }
}

-- Enable LSP servers
vim.lsp.enable({ "gopls", "clangd", "zls" })

--------------------------------------------------------------------
-- nvim-cmp (completion engine)
--------------------------------------------------------------------
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  }),
})

--------------------------------------------------------------------
-- Markdown settings
--------------------------------------------------------------------
-- vim-markdown folding
vim.g.vim_markdown_folding_disabled = 0  -- Enable folding
vim.g.vim_markdown_folding_level = 1     -- Default fold level

-- render-markdown.nvim
require('render-markdown').setup({
  -- Default settings work well
})

-- Optional: Add keybindings for render-markdown
vim.keymap.set('n', '<leader>mt', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle markdown rendering' })
vim.keymap.set('n', '<leader>mp', '<cmd>RenderMarkdown preview<cr>', { desc = 'Preview markdown' })

--------------------------------------------------------------------
-- Telescope Configuration
--------------------------------------------------------------------
require('telescope').setup{
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/" },
  }
}

-- Telescope keymaps
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true, desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true, desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true, desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true, silent = true, desc = 'Help tags' })

--------------------------------------------------------------------
-- Disable old vim-misc Go formatting (prevents formatting_sync error)
--------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    -- Clear any old BufWritePre autocmds that might use old LSP API
    vim.api.nvim_clear_autocmds({ event = "BufWritePre", pattern = "*.go", group = vim.api.nvim_create_augroup("GoFormat", { clear = true }) })
  end,
})
