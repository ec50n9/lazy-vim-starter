return {
  "snacks.nvim",
  opts = {
    picker = {
      sources = {
        -- 配置 <space><space>
        files = {
          hidden = true,
          ignored = false,
        },
        -- 配置 <space>/
        grep = {
          hidden = true,
          ignored = false,
        },
        -- 配置右侧文件浏览
        explorer = {
          hidden = true,
          ignored = false,
          layout = {
            layout = {
              preset = "sidebar",
              position = "right",
            },
          },
        },
      },
    },
  },
}
