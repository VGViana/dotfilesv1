return {
  {
    "MeanderingProgrammer/render-markdown.nvim",

    ft = {
      "markdown",
    },

    opts = {
      enabled = true,

      render_modes = {
        "n",
        "c",
      },

      heading = {
        enabled = true,

        sign = false,

        position = "overlay",

        icons = {
          "▌ ",
          "▌ ",
          "▌ ",
          "▌ ",
          "▌ ",
          "▌ ",
        },

        backgrounds = {
          "GruvboxMaterialBg0",
          "GruvboxMaterialBg0",
          "GruvboxMaterialBg0",
          "GruvboxMaterialBg0",
          "GruvboxMaterialBg0",
          "GruvboxMaterialBg0",
        },
      },

      code = {
        enabled = true,

        sign = false,

        style = "full",

        width = "block",

        left_pad = 1,
        right_pad = 1,

        border = "thin",
      },

      bullet = {
        enabled = true,

        icons = {
          "•",
          "◦",
          "▪",
        },
      },

      checkbox = {
        enabled = true,

        unchecked = {
          icon = "󰄱 ",
        },

        checked = {
          icon = "󰱒 ",
        },
      },

      quote = {
        enabled = true,

        icon = "│",
      },

      pipe_table = {
        enabled = true,

        preset = "round",
      },
    },
  },
}
