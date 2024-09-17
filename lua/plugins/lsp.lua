---@class lsp.Keymap
---@field desc string

---@class lsp.Keygroup
---@field group string


local has_trouble = require "user.configs.keymaps".is_installed("trouble.nvim")

local function activate_codelens()
  local bufnr = vim.api.nvim_get_current_buf()
  local group = vim.api.nvim_create_augroup("lsp_codelens", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
    buffer = bufnr,
    group = group,
    desc = "Refresh codelens",
    callback = function()
      vim.lsp.codelens.refresh({ bufnr = bufnr })
    end,
  })
  vim.lsp.codelens.refresh({ bufnr = bufnr })
  vim.keymap.set({ "n" },
    "<leader>llr", function() vim.lsp.codelens.refresh { bufnr = bufnr } end,
    { desc = "Refresh codelens", buffer = bufnr })
  vim.keymap.set({ "n" }, "<leader>llR", vim.lsp.codelens.run, { desc = "Run codelens", buffer = bufnr })
end

local function deactivate_codelens()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.del({ "n" }, "<leader>llr", { buffer = bufnr })
  vim.keymap.del({ "n" }, "<leader>llR", { buffer = bufnr })
  vim.api.nvim_clear_autocmds({ group = "lsp_codelens", buffer = bufnr })
  vim.lsp.codelens.clear(nil, bufnr)
end

local default_lsp_keymaps = {
  { "<Leader>l",  group = "Lsp" },
  { "<Leader>ls", group = "Search" },
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
    "<Leader>la", vim.lsp.buf.code_action, desc = "Code actions",
  },
  ["textDocument/rename"] = {
    "<Leader>lr", vim.lsp.buf.rename, desc = "Smart rename",
  },
  ["textDocument/hover"] = { "K", vim.lsp.buf.hover, desc = "Show documentation" },
  ["textDocument/format"] = { "<Leader>lf", vim.lsp.buf.format, desc = "Format document" },
  ["textDocument/publishDiagnostics"] = {
    { "<Leader>ld",  group = "Diagnostics" },
    {
      "<Leader>ldb",
      "<cmd>Telescope diagnostics bufnr=0<cr>",
      desc = "Buffer diagnostics",
    },
    { "<Leader>ldl", vim.diagnostic.open_float, desc = "Line diagnostics" },
    { "<Leader>ldn", vim.diagnostic.goto_next,  desc = "Next" },
    { "<Leader>ldp", vim.diagnostic.goto_prev,  desc = "Prev" },
    { "[e",          vim.diagnostic.goto_prev,  desc = "Previous diagnostic" },
    { "]e",          vim.diagnostic.goto_next,  desc = "Next diagnostic" },
    { "<Leader>lx",  group = "Trouble",         cond = has_trouble },
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
    { "<leader>lxl", "<cmd>Trouble loclist toggle<CR>",  cond = has_trouble, desc = "Open trouble location list" },
    { "<leader>lxt", "<cmd>Trouble todo toggle<CR>",     cond = has_trouble, desc = "Open todos in trouble" },
  },

  ["textDocument/codeLens"] = {
    { "<Leader>ll", group = "Codelens" },
    {
      "<Leader>llt",
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
      "<Leader>li",
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end,
      desc = "Toggle inlay hint",
    },
  },

  ["textDocument/documentSymbol"] = {
    {
      "<Leader>lss",
      function()
        require("telescope.builtin").lsp_document_symbols({
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
          }
        })
      end,
      desc = "Document symbols (Telescope)"
    }
  },

  ["workspace/symbol"] = {
    {
      "<Leader>lsw",
      function()
        require("telescope.builtin").lsp_workspace_symbols({
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
          }
        })
      end,
      desc = "Workspace symbols (Telescope)"
    },

    ["workspace/symbol"] = {
      {
        "<Leader>lsS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
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
            }
          })
        end,
        desc = "Workspace symbols (Telescope)"
      },
    },
  },
}

local default_aucmds = {
  ["textDocument/codeLens"] = {
    function()
      if vim.g.codelens_enabled then
        activate_codelens()
      end
    end,
  },
}


local function is_keybinding(map)
  return map["desc"] ~= nil or map["group"] ~= nil
end

local function is_lsp_method(key)
  return type(key) == "string" and vim.lsp.handlers[key] ~= nil
end

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
          if client.supports_method(k, { bufnr = opts.buffer }) then
            loop(v)
          end
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
      local lspconfig = require("lspconfig")

      -- import cmp-nvim-lsp plugin
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

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

          for k, v in pairs(default_aucmds or {}) do
            if client.supports_method(k) then
              v[1]()
            end
          end

          -- TODO: Move this out to a generalized config, see:
          -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/cpp/init.lua
          -- for an example.
          if client.name == "clangd" then
            require "clangd_extensions"
            local wk = require "which-key"
            wk.add({
              "<Leader>lh",
              "<CMD>ClangdSwitchSourceHeader<CR>",
              desc = "switch source/header file",
              buffer = ev.buf,
              silent = true,
            })

            local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_in_insert", { clear = true })

            wk.add({
              "<leader>li",
              function()
                if require("clangd_extensions.inlay_hints").toggle_inlay_hints() then
                  vim.api.nvim_create_autocmd("InsertEnter", {
                    group = group,
                    buffer = ev.buf,
                    callback = require("clangd_extensions.inlay_hints").disable_inlay_hints,
                  })
                  vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
                    group = group,
                    buffer = ev.buf,
                    callback = require("clangd_extensions.inlay_hints").set_inlay_hints,
                  })
                else
                  vim.api.nvim_clear_autocmds({ group = group, buffer = ev.buf })
                end
              end,
              buffer = ev.buf,
              silent = true,
              desc = "Toggle inlay hints",
            })
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
      vim.diagnostic.config({
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
          virt_text_pos = 'eol',
          prefix = "",
        }
      })

      -- Setup bordered ui for LspInfo
      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- used to enable autocompletion (assign to every lsp server config)
      local cmp_capabilities = cmp_nvim_lsp.default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      -- Load top level configs for modularity
      local user_config = require "user.configs.lsp"

      -- Add cmp default_capabilities to each config, and call setup
      for server, config in pairs(user_config.configs) do
        -- FIXME: use pcall to check if this works.
        local default_config = require("lspconfig.server_configurations." .. server).default_config
        default_config.handlers = vim.tbl_deep_extend('keep', default_config.handlers or {}, user_config.handlers)
        -- override default config with user config
        config = vim.tbl_deep_extend("keep", config, default_config)
        config = vim.tbl_deep_extend("keep", config,
          {
            capabilities = cmp_capabilities,
          })
        lspconfig[server].setup(config)
      end
    end,
  }, {
  "hrsh7th/nvim-cmp",
  lazy = false,
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "onsails/lspkind.nvim", -- pictograms in completion
    "petertriho/cmp-git",
    "p00f/clangd_extensions.nvim",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",     -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
  },
  config = function(_, opts)
    local cmp = require "cmp"
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    opts = opts or {}

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup(vim.tbl_deep_extend('force', opts, {
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      view = {
        entries = {
          name = "custom", -- can be "custom", "wildmenu" or "native"
        }
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-m>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-n>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-,>"] = cmp.mapping(function(fallback)
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-.>"] = cmp.mapping(function(fallback)
          if luasnip.choice_active() then
            luasnip.change_choice(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer",  keyword_length = 4, max_item_count = 5 },
        { name = "git" },
      },
      -- configure lspkind
      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        format = lspkind.cmp_format {
          maxwidth = 50,
          ellipsis_char = "...",
        },
      },
      sorting = {
        priority_weight = 100,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.recently_used,
          require("clangd_extensions.cmp_scores"),
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      experimental = {
        ghost_text = true,
      },
      ---@diagnostic disable-next-line: missing-fields
      performance = {
        max_view_entries = 100,
      },
    }))

    require("cmp_git").setup({})
    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      view = {
        entries = {
          name = "custom", -- can be "custom", "wildmenu" or "native"
        }
      },
      sources = {
        { name = 'buffer' }
      },
      mapping = {
        ["<C-k>"] = { c = cmp.mapping.select_prev_item() }, -- previous suggestion
        ["<C-j>"] = { c = cmp.mapping.select_next_item() }, -- next suggestion
        ["<C-Space>"] = { c = cmp.mapping.complete() }, -- show completion suggestions
        ["<C-e>"] = { c = cmp.mapping.abort() },        -- close completion window
        ["<CR>"] = { c = cmp.mapping.confirm({ select = false }) },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      view = {
        entries = {
          name = "custom", -- can be "custom", "wildmenu" or "native"
        }
      },
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      mapping = {
        ["<C-k>"] = { c = cmp.mapping.select_prev_item() }, -- previous suggestion
        ["<C-j>"] = { c = cmp.mapping.select_next_item() }, -- next suggestion
        ["<C-e>"] = { c = cmp.mapping.abort() },        -- close completion window
        ["<CR>"] = { c = cmp.mapping.confirm({ select = false }) },
      },
      ---@diagnostic disable-next-line: missing-fields
      matching = { disallow_symbol_nonprefix_matching = false }
    })
  end,
},
}
