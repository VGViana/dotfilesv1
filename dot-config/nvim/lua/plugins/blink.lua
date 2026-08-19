return {
  {
    "saghen/blink.cmp",

    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    version = "*",

    opts = {
      keymap = {
        preset = "default",
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },

        ghost_text = {
          enabled = false,
        },

        menu = {
          border = "rounded",
        },
      },

      signature = {
        enabled = true,

        window = {
          border = "rounded",
        },
      },
    },
  },
}
