return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  ft = "markdown",

  opts = {
    legacy_commands = false,

    workspaces = {
      {
        name = "estudos",
        path = "~/Obsidian/Auditor/",
      },
    },

    picker = {
      name = "snacks.picker",
    },

    completion = {
      nvim_cmp = false,
      min_chars = 2,
    },

    new_notes_location = "current_dir",

    daily_notes = {
      folder = "Diário",
    },

    templates = {
      folder = "Templates",
    },

    attachments = {
      img_folder = "Anexos",
    },
  },

  keys = {
    {
      "<leader>oo",
      "<cmd>Obsidian quick_switch<cr>",
      desc = "Obsidian: Quick switch",
    },

    {
      "<leader>on",
      "<cmd>Obsidian new<cr>",
      desc = "Obsidian: New note",
    },

    {
      "<leader>od",
      "<cmd>Obsidian today<cr>",
      desc = "Obsidian: Today",
    },

    {
      "<leader>os",
      "<cmd>Obsidian search<cr>",
      desc = "Obsidian: Search",
    },

    {
      "<leader>ob",
      "<cmd>Obsidian backlinks<cr>",
      desc = "Obsidian: Backlinks",
    },

    {
      "<leader>ot",
      "<cmd>Obsidian tags<cr>",
      desc = "Obsidian: Tags",
    },

    {
      "<leader>oi",
      "<cmd>Obsidian paste_img<cr>",
      desc = "Obsidian: Paste image",
    },

    {
      "<leader>of",
      "<cmd>Obsidian follow_link<cr>",
      desc = "Obsidian: Follow link",
    },

    {
      "<CR>",
      function()
        return require("obsidian").util.smart_action()
      end,
      expr = true,
      desc = "Obsidian: Smart action",
      ft = "markdown",
    },
  },
}
