return {
  {
    "nvim-lualine/lualine.nvim",

    event = "VeryLazy",

    opts = {
      options = {
        theme = "gruvbox-material",

        globalstatus = true,

        component_separators = "",
        section_separators = "",

        disabled_filetypes = {
          statusline = {
            "dashboard",
            "alpha",
            "snacks_dashboard",
          },
        },
      },

      sections = {
        lualine_a = {
          {
            "mode",

            fmt = function()
              return ({
                NORMAL = "NORMAL",
                INSERT = "INSERT",
                VISUAL = "VISUAL",
                ["V-LINE"] = "V-LINE",
                ["V-BLOCK"] = "V-BLOCK",
                REPLACE = "REPLACE",
                COMMAND = "COMMAND",
                TERMINAL = "TERM",
              })[vim.fn.mode()] or vim.fn.mode()
            end,
          },
        },

        lualine_b = {
          {
            "filename",
            path = 1,
          },
        },

        lualine_c = {
          {
            "branch",
            icon = "󰘬",
          },
        },

        lualine_x = {
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
          },
        },

        lualine_y = {
          "filetype",
        },

        lualine_z = {
          {
            "location",
          },
        },
      },
    },
  },
}
