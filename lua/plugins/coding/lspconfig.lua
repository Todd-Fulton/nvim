local has_trouble = require("user.configs.keymaps").is_installed "trouble.nvim"

local function activate_codelens()
  local bufnr = vim.api.nvim_get_current_buf()
  local group = vim.api.nvim_create_augroup("lsp_codelens", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
    buffer = bufnr,
    group = group,
    desc = "Refresh codelens",
    callback = function() vim.lsp.codelens.refresh { bufnr = bufnr } end,
  })
  vim.lsp.codelens.refresh { bufnr = bufnr }
  vim.keymap.set(
    { "n" },
    "<leader>llr",
    function() vim.lsp.codelens.refresh { bufnr = bufnr } end,
    { desc = "Refresh codelens", buffer = bufnr }
  )
  vim.keymap.set({ "n" }, "<leader>llR", vim.lsp.codelens.run, { desc = "Run codelens", buffer = bufnr })
end

local function deactivate_codelens()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.del({ "n" }, "<leader>llr", { buffer = bufnr })
  vim.keymap.del({ "n" }, "<leader>llR", { buffer = bufnr })
  vim.api.nvim_clear_autocmds { group = "lsp_codelens", buffer = bufnr }
  vim.lsp.codelens.clear(nil, bufnr)
end

local function set_symantic_tokens(bufnr, on, silent)
  bufnr = bufnr or 0
  vim.b[bufnr].semantic_tokens = on
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.supports_method "textDocument/semanticTokens/full" then
      vim.lsp.semantic_tokens[on and "start" or "stop"](bufnr, client.id, {})
      vim.lsp.semantic_tokens.force_refresh(bufnr)
    end
  end
  if silent == false then vim.notify(("Symantic highlighting has been %s"):format(on and "enabled" or "disabled")) end
end

local lsp_format = function(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  }
end

local function toggle_symantic_tokens(silent)
  local bufnr = vim.api.nvim_get_current_buf()
  set_symantic_tokens(bufnr, not vim.b[bufnr].semantic_tokens, silent)
end

local default_lsp_keymaps = {
  { "<Leader>l", group = "LSP", icon = "" },
  { "<Leader>ls", group = "Search" },
  { "<Leader>lt", group = "Toggle" },
  ["textDocument/references"] = {
    "<Leader>lsr",
    "<cmd>Telescope lsp_references<cr>",
    desc = "References",
  },
  ["textDocument/declaration"] = {
    "<Leader>lsd",
    vim.lsp.buf.declaration,
    desc = "Go to declaration",
  },
  ["textDocument/definition"] = {
    "<Leader>lsD",
    "<cmd>Telescope lsp_definitions<cr>",
    desc = "Definitions",
  },
  ["textDocument/implementation"] = {
    "<Leader>lsi",
    "<cmd>Telescope lsp_implementations<cr>",
    desc = "Implementation",
  },
  ["textDocument/typeDefinitions"] = {
    "<Leader>lst",
    "<cmd>Telescope lsp_type_definitions<cr>",
    desc = "Type definitions",
  },
  ["textDocument/codeAction"] = {
    "<Leader>la",
    vim.lsp.buf.code_action,
    desc = "Code actions",
  },
  ["textDocument/rename"] = {
    "<Leader>lr",
    vim.lsp.buf.rename,
    desc = "Smart rename",
  },
  ["textDocument/hover"] = { "K", vim.lsp.buf.hover, desc = "Show documentation" },
  ["textDocument/publishDiagnostics"] = {
    { "<Leader>ld", group = "Diagnostics" },
    {
      "<Leader>ldb",
      "<cmd>Telescope diagnostics bufnr=0<cr>",
      desc = "Buffer diagnostics",
    },
    { "<Leader>ldl", vim.diagnostic.open_float, desc = "Line diagnostics" },
    { "<Leader>ldn", vim.diagnostic.goto_next, desc = "Next" },
    { "<Leader>ldp", vim.diagnostic.goto_prev, desc = "Prev" },
    { "[e", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
    { "]e", vim.diagnostic.goto_next, desc = "Next diagnostic" },
    { "<Leader>lx", group = "Trouble", cond = has_trouble },
    {
      "<leader>lxw",
      "<cmd>Trouble diagnostics toggle<CR>",
      cond = has_trouble,
      desc = "Open trouble workspace diagnostics",
    },
    {
      "<leader>lxd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
      cond = has_trouble,
      desc = "Open trouble document diagnostics",
    },
    { "<leader>lxq", "<cmd>Trouble quickfix toggle<CR>", cond = has_trouble, desc = "Open trouble quickfix list" },
    { "<leader>lxl", "<cmd>Trouble loclist toggle<CR>", cond = has_trouble, desc = "Open trouble location list" },
    { "<leader>lxt", "<cmd>Trouble todo toggle<CR>", cond = has_trouble, desc = "Open todos in trouble" },
  },

  ["textDocument/codeLens"] = {
    {
      "<Leader>ltl",
      function()
        vim.g.codelens_enabled = not vim.g.codelens_enabled
        if vim.g.codelens_enabled then
          activate_codelens()
        else
          deactivate_codelens()
        end
      end,
      desc = "Toggle codelens",
    },
  },

  ["textDocument/inlayHint"] = {
    {
      "<Leader>lti",
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
      desc = "Toggle inlay hint",
    },
  },

  ["textDocument/documentSymbol"] = {
    {
      "<Leader>lss",
      function()
        require("telescope.builtin").lsp_document_symbols {
          symbols = {
            "class",
            "function",
            "file",
            "module",
            "method",
            "property",
            "constructor",
            "enum",
            "interface",
            "struct",
            "variable",
          },
        }
      end,
      desc = "Document symbols (Telescope)",
    },
  },

  ["workspace/symbol"] = {
    {
      "<Leader>lsw",
      function()
        require("telescope.builtin").lsp_workspace_symbols {
          symbols = {
            "class",
            "function",
            "file",
            "module",
            "method",
            "enum",
            "interface",
            "struct",
            "variable",
          },
        }
      end,
      desc = "Workspace symbols (Telescope)",
    },

    {
      "<Leader>lsS",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols {
          symbols = {
            "class",
            "function",
            "file",
            "module",
            "method",
            "enum",
            "interface",
            "struct",
            "variable",
          },
        }
      end,
      desc = "Workspace symbols (Telescope)",
    },
  },

  ["textDocument/semanticTokens/full"] = {
    {
      "<Leader>lts",
      function() toggle_symantic_tokens(false) end,
      desc = "Toggle symantic highlighting",
    },
  },

  ["textDocument/prepareCallHierarchy"] = {
    { "<Leader>lh", group = "Call Hierarchy" },
    ["callHierarchy/incomingCalls"] = {
      "<Leader>lhi",
      "<CMD>Telescope lsp_incoming_calls<CR>",
      desc = "Show incoming calls",
    },

    ["callHierarchy/outgoingCalls"] = {
      "<Leader>lho",
      "<CMD>Telescope lsp_outgoing_calls<CR>",
      desc = "Show outgoing calls",
    },
  },
}

local default_aucmds = {
  ["textDocument/codeLens"] = {
    function()
      if vim.g.codelens_enabled then activate_codelens() end
    end,
  },
}

local function is_keybinding(map) return map["desc"] ~= nil or map["group"] ~= nil end

local function is_lsp_method(key) return type(key) == "string" and vim.lsp.handlers[key] ~= nil end

--- TODO: lsp.Keymap should support a way for functions to request arbitrary arguments
--- such as client id, buf number, opts, etc...
--- NOTE: From what context will we derive these arguments?
local function parse_keymaps(client, mappings, opts)
  local wk = require "which-key"
  local function loop(map)
    if is_keybinding(map) then
      wk.add(vim.tbl_extend("keep", map, opts))
    else
      for k, v in pairs(map) do
        if is_lsp_method(k) then
          if client.supports_method(k, { bufnr = opts.buffer }) then loop(v) end
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
      { "p00f/clangd_extensions.nvim" },
    },
    config = function()
      -- import lspconfig plugin
      local lspconfig = require "lspconfig"

      -- import cmp-nvim-lsp plugin
      local cmp_nvim_lsp = require "cmp_nvim_lsp"

      -- setup default configuration, keybindings, etc.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          if not client then return end -- TODO: Report failure
          -- set keybinds
          parse_keymaps(client, default_lsp_keymaps, { buffer = ev.buf, silent = true })

          if client.supports_method "textDocument/format" then
            vim.keymap.set(
              "n",
              "<Leader>lf",
              function() lsp_format(ev.buf) end,
              { buffer = ev.buf, noremap = true, desc = "Format document" }
            )
          end
          for k, v in pairs(default_aucmds or {}) do
            if client.supports_method(k) then v[1]() end
          end

          -- TODO: use an option to disable in user configs
          if client.supports_method "textDocument/symanticTokens/full" then
            vim.b[ev.buf].semantic_tokens = true
          else
            vim.b[ev.buf].semantic_tokens = false
          end
          set_symantic_tokens(ev.buf, vim.b[ev.buf].semantic_tokens, true)

          -- TODO: Move this out to a generalized config, see:
          -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/cpp/init.lua
          -- for an example.
          if client.name == "clangd" then
            require "clangd_extensions"
            local wk = require "which-key"
            wk.add {
              "<Leader>lz",
              "<CMD>ClangdSwitchSourceHeader<CR>",
              desc = "switch source/header file",
              buffer = ev.buf,
              silent = true,
            }
          end
        end,
      })

      -- unset default configuration, keybindings, etc.
      -- vim.api.nvim_create_autocmd("LspDetach", {
      --   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      --   callback = on_lsp_detach,
      -- })

      local ds = vim.diagnostic.severity
      local signs = { [ds.ERROR] = " ", [ds.WARN] = " ", [ds.HINT] = "󰠠 ", [ds.INFO] = " " }

      -- Configure diagnostics
      vim.diagnostic.config {
        -- sort by severity
        severity_sort = true,
        float = {
          -- use single line borders
          border = "rounded",
        },
        -- Use icons for signs
        signs = { text = signs },
        -- Don't use a prefix, the sign is in the sign column
        virtual_text = {
          virt_text_pos = "eol",
          prefix = "",
        },
      }

      -- Setup bordered ui for LspInfo
      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Load top level configs for modularity
      local user_config = require "user.configs.lsp"

      -- Add cmp default_capabilities to each config, and call setup
      for server, config in pairs(user_config.configs) do
        local status, server_config = pcall(require, "lspconfig.configs." .. server)
        -- TODO: Handle not status
        if status then
          server_config.default_config.handlers =
            vim.tbl_deep_extend("keep", server_config.default_config.handlers or {}, user_config.handlers)
          -- override default config with user config
          config = vim.tbl_deep_extend("keep", config, server_config.default_config)
          config = vim.tbl_deep_extend("keep", config, {
            capabilities = capabilities,
          })
          lspconfig[server].setup(config)
        end
      end
    end,
  },
}
