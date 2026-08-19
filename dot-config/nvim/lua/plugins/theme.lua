return {
  {
    "sainnhe/gruvbox-material",

    lazy = false,
    priority = 1000,

    config = function()
      vim.g.gruvbox_material_background = "soft"
      vim.g.gruvbox_material_foreground = "material"

      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_better_performance = 1

      vim.g.gruvbox_material_transparent_background = 0
      vim.g.gruvbox_material_ui_contrast = "low"
      vim.g.gruvbox_material_float_style = "dim"

      vim.cmd.colorscheme("gruvbox-material")

      local colors = {
        bg = "#282828",
        bg1 = "#32302f",
        bg2 = "#3c3836",
        bg3 = "#504945",

        fg = "#d4be98",
        fg1 = "#ebdbb2",
        fg2 = "#a89984",
        muted = "#665c54",

        yellow = "#d8a657",
        orange = "#e78a4e",
        green = "#a9b665",
        blue = "#7daea3",
        red = "#ea6962",
        purple = "#d3869b",
      }

      local groups = {
        Normal = {
          bg = colors.bg,
          fg = colors.fg,
        },

        NormalFloat = {
          bg = colors.bg1,
          fg = colors.fg,
        },

        FloatBorder = {
          bg = colors.bg1,
          fg = colors.muted,
        },

        CursorLine = {
          bg = colors.bg1,
        },

        CursorLineNr = {
          fg = colors.yellow,
          bold = true,
        },

        LineNr = {
          fg = colors.muted,
        },

        SignColumn = {
          bg = colors.bg,
        },

        Visual = {
          bg = colors.bg3,
        },

        Search = {
          bg = colors.yellow,
          fg = colors.bg,
        },

        IncSearch = {
          bg = colors.orange,
          fg = colors.bg,
        },

        Pmenu = {
          bg = colors.bg1,
          fg = colors.fg,
        },

        PmenuSel = {
          bg = colors.bg3,
          fg = colors.fg1,
        },

        StatusLine = {
          bg = colors.bg,
          fg = colors.fg2,
        },

        StatusLineNC = {
          bg = colors.bg,
          fg = colors.muted,
        },

        WinSeparator = {
          fg = colors.bg2,
          bg = colors.bg,
        },

        VertSplit = {
          fg = colors.bg2,
          bg = colors.bg,
        },

        -- Diagnósticos
        DiagnosticError = {
          fg = colors.red,
        },

        DiagnosticWarn = {
          fg = colors.yellow,
        },

        DiagnosticInfo = {
          fg = colors.blue,
        },

        DiagnosticHint = {
          fg = colors.green,
        },
      }

      for name, opts in pairs(groups) do
        vim.api.nvim_set_hl(0, name, opts)
      end
    end,
  },
}
