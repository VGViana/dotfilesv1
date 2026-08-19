return {
  {
    "nvim-telescope/telescope.nvim",

    opts = {
      defaults = {
        hidden = true,
        layout_strategy = "horizontal",

        layout_config = {
          horizontal = {
            preview_width = 0.45,
          },
        },

        border = true,
      },

      pickers = {
        find_files = {
          hidden = true,
          follow = true,
        },
      },
    },
  },
}
