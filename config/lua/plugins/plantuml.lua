return {
  "javiorfo/nvim-soil",
  ft = "plantuml",
  dependencies = "javiorfo/nvim-nyctophilia",
  config = function()
    require("soil").setup({
      image = {
        darkmode = true,
        format = "png",
        execute_to_open = function(img)
          return "wslview '" .. img .. "'"
        end,
      },
    })
  end,
}
