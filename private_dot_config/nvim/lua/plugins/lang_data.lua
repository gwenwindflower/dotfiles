return {
  {
    "d2lang/d2-vim",
    ft = { "d2" },
    dependencies = {
      {
        "ravsii/tree-sitter-d2",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        version = "*",
        build = "make nvim-install",
      },
    },
  },
}
