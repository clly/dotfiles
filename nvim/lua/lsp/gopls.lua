return {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
        unusedwrite = true,
        staticcheck = true,
      },
      usePlaceholders = true,
      gofumpt = true,
    },
  },
}
