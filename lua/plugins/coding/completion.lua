return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim", -- pictograms in completion
      "petertriho/cmp-git",
      "p00f/clangd_extensions.nvim",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",   -- for autocompletion
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
          ["<C-e>"] = cmp.mapping.abort(),      -- close completion window
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
          ["<C-Space>"] = { c = cmp.mapping.complete() },   -- show completion suggestions
          ["<C-e>"] = { c = cmp.mapping.abort() },          -- close completion window
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
          ["<C-e>"] = { c = cmp.mapping.abort() },          -- close completion window
          ["<CR>"] = { c = cmp.mapping.confirm({ select = false }) },
        },
        ---@diagnostic disable-next-line: missing-fields
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end,
  },
}
