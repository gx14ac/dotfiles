--------------------------------------------------------------------
-- Basic Settings
--------------------------------------------------------------------
vim.g.vim_home_path = "~/.vim"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.background = "dark"
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.cmd('syntax enable')

--------------------------------------------------------------------
-- Catppuccin Theme (Treesitter supported)
--------------------------------------------------------------------
require("catppuccin").setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = true,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    telescope = {
      enabled = true,
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
  },
})
vim.cmd.colorscheme "catppuccin"

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
  },
  format_on_save = {
    lsp_format = "never",
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
local nvim_lsp = require('lspconfig')
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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

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

nvim_lsp["gopls"].setup { on_attach = on_attach }
nvim_lsp["clangd"].setup { on_attach = on_attach }
nvim_lsp["zls"].setup {
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
