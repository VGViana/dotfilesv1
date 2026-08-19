return {
  {
    "folke/snacks.nvim",

    opts = {
      explorer = {
        hidden = true,
        ignored = true,
        follow_file = true,
      },

      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },

          files = {
            hidden = true,
            ignored = true,
          },
        },
      },

      notifier = {
        enabled = true,
        timeout = 3000,
      },

      indent = {
        enabled = false,
      },

      scroll = {
        enabled = false,
      },
    },
  },
}
