-- ESP-IDF 交叉编译项目的 clangd 配置
--
-- 为什么需要: LazyVim 默认用 mason 装的 clangd, 它只带 x86_64 后端。
-- 分析 ESP32 代码时 triple 会退化成 x86_64-unknown-linux-gnu, 结果是
-- sizeof(void*)==8、__XTENSA__ 未定义 —— 编辑器和实际编译看到的是两套代码。
-- Espressif 打包的 clangd 带 xtensa/riscv 后端, 但反过来不认识 x86,
-- 所以只能按项目切换: 检测到 ESP-IDF 项目(有 sdkconfig)才用 esp-clangd。
--
-- 另一件事是标准库头文件。项目用 picolibc(CONFIG_LIBC_PICOLIBC=y),
-- 头文件路径由 -specs=picolibc.specs 决定, 而 specs 只有 GCC 认。
-- 这里用 --query-driver 让 clangd 直接问 GCC "你的搜索路径是什么",
-- 比在 .clangd 里手写一串 -isystem 更稳(换工具链版本不用改)。

local function first_glob(pattern)
  local hits = vim.fn.glob(pattern, false, true)
  table.sort(hits) -- 多版本时取字典序最大的, 通常就是最新版
  return hits[#hits]
end

local esp_clangd = first_glob(vim.fn.expand("~/.espressif/tools/esp-clangd/*/esp-clangd/bin/clangd"))
-- esp-clangd 二进制包里不含 clang 的 builtin 头(stddef.h / float.h 等),
-- 得借用同版本 esp-clang 的 resource dir, 否则 #include <stdlib.h> 就找不到。
local esp_resource = first_glob(vim.fn.expand("~/.espressif/tools/esp-clang/*/esp-clang/lib/clang/*"))

-- 这两个是留给 clangd 自己解析的通配符, 不能过 vim.fn.expand ——
-- expand 会把 ** 展成一串真实路径(每个芯片一个 g++), 反而把参数搞坏。
-- 只手动展开 ~, 其余原样交给 clangd。
local home = vim.env.HOME
local xtensa_driver = home .. "/.espressif/tools/xtensa-esp-elf/**/bin/xtensa-esp*-elf-g++"
local riscv_driver = home .. "/.espressif/tools/riscv32-esp-elf/**/bin/riscv32-esp-elf-g++"

-- 没装 esp-clangd 就什么都不做, 保持 LazyVim 默认行为
if not esp_clangd or not esp_resource then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- 关掉 mason 自动接管, 否则它会用自己那份 clangd 覆盖下面的 cmd
          mason = false,
          cmd = {
            esp_clangd,
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            -- 白名单: 允许 clangd 执行这些 GCC 去抽取系统头文件路径
            "--query-driver=" .. xtensa_driver .. "," .. riscv_driver,
            "--resource-dir=" .. esp_resource,
          },
          -- 只在 ESP-IDF 项目里启用。sdkconfig 是 idf.py 生成的, 比 CMakeLists.txt 更专一。
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { "sdkconfig", "sdkconfig.defaults" })
            if root then
              on_dir(root)
            end
            -- 非 ESP 项目: 不调用 on_dir, 这个 config 就不激活。
            -- 想同时支持宿主机 C++ 项目的话, 另建一个用 mason clangd 的 config。
          end,
        },
      },
    },
  },
}
