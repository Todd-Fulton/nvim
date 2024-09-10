
---@class lsp.Keymap
---@field desc string

---@class lsp.Keygroup
---@field group string

-- TODO: Add documentation
-- Consider moving to a seperate lspconfig-config module/plugin


---@function
---@param plugin string
local function is_installed(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

local function apply(func, ...)
  local args = {...}
  return function(...) return func(table.unpack(args), ...) end
end

local has_trouble = apply(is_installed, "trouble.nvim")

---@type table string bool
--- Used to check if a key in a `lsp.KeymapSet` is a LPS method, in which case
--- the value of theKey/Value pair is `lsp.Keymap|(lsp.Keymap|lsp.Keygroup)[]`
local LspMethods = {
  ["textDocument/declaration"] = true,
  ["textDocument/definition"] = true,
  ["textDocument/typeDefinition"] = true,
  ["textDocument/implementation"] = true,
  ["textDocument/references"] = true,
  ["textDocument/prepareCallHierarchy"] = true,
  ["callHierarchy/incomingCalls"] = true,
  ["callHierarchy/outgoingCalls"] = true,
  ["textDocument/prepareTypeHierarchy"] = true,
  ["typeHierarchy/supertypes"] = true,
  ["typeHierarchy/subtypes"] = true,
  ["textDocument/documentHighlight"] = true,
  ["textDocument/documentLink"] = true,
  ["documentLink/resolve"] = true,
  ["textDocument/hover"] = true,
  ["textDocument/codeLens"] = true,
  ["codeLens/resolve"] = true,
  ["workspace/codeLens/refresh"] = true,
  ["textDocument/foldingRange"] = true,
  ["textDocument/selectionRange"] = true,
  ["textDocument/documentSymbol"] = true,
  ["textDocument/semanticTokens"] = true,
  ["textDocument/semanticTokens/full"] = true,
  ["textDocument/semanticTokens/full/delta"] = true,
  ["textDocument/semanticTokens/range"] = true,
  ["textDocument/semanticTokens/refresh"] = true,
  ["textDocument/inlayHint"] = true,
  ["inlayHint/resolve"] = true,
  ["workspace/inlayHint/refresh"] = true,
  ["textDocument/inlineValue"] = true,
  ["workspace/inlineValue/refresh"] = true,
  ["textDocument/moniker"] = true,
  ["textDocument/completion"] = true,
  ["completionItem/resolve"] = true,
  ["textDocument/publishDiagnostics"] = true,
  ["textDocument/diagnostic"] = true,
  ["workspace/diagnostic"] = true,
  ["workspace/diagnostic/refresh"] = true,
  ["textDocument/signatureHelp"] = true,
  ["textDocument/codeAction"] = true,
  ["codeAction/resolve"] = true,
  ["textDocument/rename"] = true,
  ["workspace/executeCommand"] = true,
}

local default_lsp_keymaps = {
  { "<Leader>l", group = "Lsp" },
  { "<Leader>ls", group = "Search" },
  ["textDocument/references"] = {
    "<Leader>lsr", "<cmd>Telescope lsp_references<cr>",
    desc = "References"
  },
  ["textDocument/declaration"] = {
    "<Leader>lsd", vim.lsp.buf.declaration,
    desc = "Go to declaration"
  },
  ["textDocument/definition"] = {
    "<Leader>lsD", "<cmd>Telescope lsp_definitions<cr>",
    desc = "Definitions"
  },
  ["textDocument/implementation"] = {
    "<Leader>lsi", "<cmd>Telescope lsp_implementations<cr>",
    desc = "Implementation"
  },
  ["textDocument/typeDefinitions"] = {
    "<Leader>lst", "<cmd>Telescope lsp_type_definitions<cr>",
    desc = "Type definitions"
  },
  ["textDocument/codeAction"] = {
    "<Leader>la", vim.lsp.buf.code_action, desc = "Code actions"
  },
  ["textDocument/rename"] = {
    "<Leader>lr", vim.lsp.buf.rename, desc = "Smart rename"
  },
  ["textDocument/hover"] = { "K", vim.lsp.buf.hover, desc = "Show documentation" },
  ["textDocument/publishDiagnostics"] = {
      { "<Leader>ld", group = "Diagnostics" },
      {
        "<Leader>ldb", "<cmd>Telescope diagnostics bufnr=0<cr>",
        desc = "Buffer diagnostics"
      },
      { "<Leader>ldl", vim.diagnostic.open_float, desc = "Line diagnostics" },
      { "<Leader>ldn", vim.diagnostic.goto_next, desc = "Next" },
      { "<Leader>ldp", vim.diagnostic.goto_prev, desc = "Prev" },
      { "[e", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
      { "]e", vim.diagnostic.goto_next, desc = "Next diagnostic" },
      { "<Leader>lx", group = "Trouble", cond = has_trouble },
      { "<leader>lxw", "<cmd>Trouble diagnostics toggle<CR>", cond = has_trouble, desc = "Open trouble workspace diagnostics" },
      { "<leader>lxd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", cond = has_trouble, desc = "Open trouble document diagnostics" },
      { "<leader>lxq", "<cmd>Trouble quickfix toggle<CR>", cond = has_trouble, desc = "Open trouble quickfix list" },
      { "<leader>lxl", "<cmd>Trouble loclist toggle<CR>", cond = has_trouble, desc = "Open trouble location list" },
      { "<leader>lxt", "<cmd>Trouble todo toggle<CR>", cond = has_trouble, desc = "Open todos in trouble" },
  }
}


local function is_keybinding(map)
  return map["desc"] ~= nil or map["group"] ~= nil
end

local function is_lsp_method(key)
  return type(key) == "string" and LspMethods[key] ~= nil
end



local function parse_keymaps(client, mappings, opts)
  local loop

  local function handle_method(method, maps)
    if client.supports_method(method, {bufnr = opts.buffer})
    then
      loop(maps)
    end
  end

  loop = function(map)
    if is_keybinding(map) then
        require'which-key'.add(vim.tbl_extend('keep', map, opts))
    else
      for k, v in pairs(map) do
        if is_lsp_method(k) then
          handle_method(k, v)
        else
          loop(v)
        end
      end
    end
  end

  loop(mappings)
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      -- import lspconfig plugin
      local lspconfig = require("lspconfig")

      -- import mason_lspconfig plugin
      -- local mason_lspconfig = require("mason-lspconfig")

      -- import cmp-nvim-lsp plugin
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      vim.lsp.handlers["textDocument/hover"] =
      vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          border = "single"
        }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
          border = "single"
        }
      )

      -- setup default configuration, keybindings, etc.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function (ev)
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          if not client then return end -- TODO: Report failure
          -- set keybinds

          parse_keymaps(client, default_lsp_keymaps, { buffer = ev.buf, silent = true })
        end,
      })

      -- unset default configuration, keybindings, etc.
      -- vim.api.nvim_create_autocmd("LspDetach", {
      --   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      --   callback = on_lsp_detach,
      -- })

      -- Change the Diagnostic symbols in the sign column (gutter)
      -- (not in youtube nvim video)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      -- Setup bordered ui
      require('lspconfig.ui.windows').default_options.border = 'single'

      -- used to enable autocompletion (assign to every lsp server config)
      local cmp_capabilities = cmp_nvim_lsp.default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      -- Load top level configs for modularity
      local configs = require'lsp-configs'

      -- Add cmp default_capabilities to each config, and call setup
      for server, config in pairs(configs) do
        -- FIXME: use pcall to check if this works.
        local default_config = require('lspconfig.server_configurations.' .. server).default_config
        -- use override default config with user config
        config = vim.tbl_deep_extend('keep', config, default_config)
        config = vim.tbl_deep_extend('keep', config,
          {
            capabilities = cmp_capabilities,
          })
        lspconfig[server].setup(config)
      end
    end,
  }, {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim", -- pictograms in completion
      "petertriho/cmp-git",
    },
    config = function()
      local cmp = require'cmp'
      local lspkind = require'lspkind'
      cmp.setup ({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        window =  {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = "custom",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
          ["<C-e>"] = cmp.mapping.abort(), -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources{
          { name = "nvim_lsp" },
          -- TODO: Install LuaSnip
          -- { name = "luasnip" },
          { name = "path" },
          { name = "buffer", keyword_length = 4, max_item_count = 5 },
        },
        -- configure lspkind
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = lspkind.cmp_format {
            maxwidth = 50,
            ellipsis_char = "...",
          },
        },
        experimental = {
          ghost_text = true,
        },
        ---@diagnostic disable-next-line: missing-fields
        performance = {
          max_view_entries = 100,
        }
      })
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
        }, {
            { name = 'buffer' },
          })
      })
      require("cmp_git").setup()
    end,
  }
}
