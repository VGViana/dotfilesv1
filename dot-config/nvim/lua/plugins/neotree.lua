return {
  {
    "nvim-neo-tree/neo-tree.nvim",

    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },

        follow_current_file = {
          enabled = true,
        },

        use_libuv_file_watcher = true,
      },

      window = {
        width = 32,

        mappings = {
          ["<space>"] = "none",
        },
      },
    },
  },
}
