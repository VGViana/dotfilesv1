return {
  {
    "sainnhe/gruvbox-material",

    lazy = false,
    priority = 1000,

    config = function()
      -- ============================================================
      -- CONFIGURAÇÃO
      -- ============================================================

      vim.g.gruvbox_material_background = "soft"

      -- ORIGINAL = maior contraste
      -- MATERIAL = mais suave
      vim.g.gruvbox_material_foreground = "soft"
      vim.g.gruvbox_material_foreground = "material"

      vim.g.gruvbox_material_better_performance = 1

      -- Interface mais definida
      vim.g.gruvbox_material_ui_contrast = "high"

      -- Comentários sem itálico
      vim.g.gruvbox_material_disable_italic_comment = 0

      -- Funções em negrito
      vim.g.gruvbox_material_enable_bold = 1

      -- Não precisamos de itálico para leitura
      vim.g.gruvbox_material_enable_italic = 1

      -- Floats mais destacados
      vim.g.gruvbox_material_float_style = "bright"

      -- Diagnósticos visíveis
      vim.g.gruvbox_material_diagnostic_text_highlight = "colored"

      -- Seleção
      vim.g.gruvbox_material_visual = "grey background"

      -- ============================================================
      -- TEMA
      -- ============================================================

      local function get_theme()
        local hour = tonumber(os.date("%H"))

        if hour >= 8 and hour < 17 then
          return "light"
        end

        return "dark"
      end

      local function apply_theme()
        vim.o.background = get_theme()

        vim.cmd.colorscheme("gruvbox-material")

        -- ==========================================================
        -- EDITOR
        -- ==========================================================

        vim.opt.number = true
        vim.opt.relativenumber = false

        vim.opt.cursorline = true

        vim.opt.signcolumn = "yes"

        vim.opt.wrap = false

        vim.opt.scrolloff = 8
        vim.opt.sidescrolloff = 8

        vim.opt.termguicolors = true

        -- ==========================================================
        -- COMENTÁRIOS
        -- ==========================================================

        vim.api.nvim_set_hl(0, "Comment", {
          italic = false,
        })

        -- ==========================================================
        -- NÚMERO DA LINHA
        -- ==========================================================

        if vim.o.background == "light" then
          vim.api.nvim_set_hl(0, "LineNr", {
            fg = "#928374",
          })

          vim.api.nvim_set_hl(0, "CursorLineNr", {
            fg = "#9d6500",
            bold = true,
          })

          vim.api.nvim_set_hl(0, "CursorLine", {
            bg = "#ead9ad",
          })
        else
          vim.api.nvim_set_hl(0, "LineNr", {
            fg = "#665c54",
          })

          vim.api.nvim_set_hl(0, "CursorLineNr", {
            fg = "#d8a657",
            bold = true,
          })

          vim.api.nvim_set_hl(0, "CursorLine", {
            bg = "#32302f",
          })
        end
      end

      -- Aplicar
      apply_theme()

      -- ============================================================
      -- TROCA AUTOMÁTICA
      -- ============================================================

      local last_theme = get_theme()

      vim.fn.timer_start(60000, function()
        local current_theme = get_theme()

        if current_theme ~= last_theme then
          last_theme = current_theme

          vim.schedule(function()
            apply_theme()
          end)
        end
      end, {
        ["repeat"] = -1,
      })
    end,
  },
}
