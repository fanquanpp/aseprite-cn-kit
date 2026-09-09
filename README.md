# Aseprite 汉化工具包（Aseprite-Hanhua-Kit）

针对 **Aseprite v1.3.18.5**（Windows x64）的完整中文本地化方案：
深度优化的简体中文翻译 + 中文清晰字体主题 + 一键安装脚本，彻底解决中文界面**显示模糊**的问题。

> 本仓库同时提供从源码完整编译 Aseprite 的脚本与说明，`一键汉化.bat` 对官方安装版同样有效。

---

## ✨ 特性

- **增强版简体中文汉化**（`sChinese`）：基于官方 `zh_Hans`（[aseprite/strings](https://github.com/aseprite/strings) 仓库最新翻译，1815 条全部翻译）深度校对
  - 统一术语（色板 / 选区 / 精灵 等）
  - 润色生硬直译（"被"字句、冗长从句等 14+ 处）
  - 覆盖 1.3.18 新增的全部字符串
- **中文字体清晰主题**（`Aseprite-CN`）：英文/数字保留官方像素字体，中文回退到
  微软雅黑（Windows）/ 苹方（macOS）/ 思源黑体（Linux）并开启抗锯齿
  - 明暗两套皮肤：`cn-clear`（浅色）与 `cn-clear-dark`（深色）
  - 彻底告别默认主题下中文发虚、模糊的问题
- **一键安装**：`一键汉化.bat` 自动安装扩展、切换语言与主题
- **可选像素风主题**：`aseprite-theme-pixel`（Zfull-GB 像素中文字体，复古像素风完整汉化观感）

## 🚀 快速开始（一键汉化）

1. **关闭 Aseprite**（如正在运行）
2. 下载本仓库（`Code → Download ZIP`）或从 [Releases](../../releases) 下载附件并解压
3. 双击 **`一键汉化.bat`**
4. 重新启动 Aseprite，完成！

一键脚本会自动完成：

- 安装汉化扩展 → `%APPDATA%\Aseprite\extensions\aseprite-language-sChinese`
- 安装清晰字体主题 → `%APPDATA%\Aseprite\extensions\aseprite-theme-cn`
- 写入配置：语言 `sChinese`、主题 `cn-clear`（修改 `%APPDATA%\Aseprite\aseprite.ini`）

## 🔧 手动安装（不想用脚本）

1. 双击 `extensions\hanhua-1.3.18.5.aseprite-extension`，Aseprite 会弹出安装窗口，点击 **Install**
2. 双击 `extensions\aseprite-theme-cn-1.0.0.aseprite-extension`，点击 **Install**
3. 菜单：`Edit → Preferences → General → Language` 选择 **sChinese**
4. 菜单：`Edit → Preferences → Theme` 选择 **Aseprite-CN**（或 Aseprite-CN Dark）

## 📦 仓库内容

| 路径 | 说明 |
| --- | --- |
| `一键汉化.bat` | 一键安装：扩展 + 语言 + 主题配置 |
| `extensions/hanhua-1.3.18.5.aseprite-extension` | 增强版简体中文语言扩展 |
| `extensions/aseprite-theme-cn-1.0.0.aseprite-extension` | 中文清晰字体主题（混排方案） |
| `themes/中文字体主题合集.zip` | 上面两个扩展 + 像素主题的打包合集 |
| `themes/aseprite-theme-pixel.aseprite-extension` | 社区像素风主题（Zfull-GB 像素中文字体，主题 ID：aseprite-theme-pixel） |
| `fonts/中文字体包.zip` | Zfull-GB 像素中文字体 + 安装说明 |
| `src/` | 构建脚本与生成汉化/主题的源文件（可复现） |

> **提示**：一键汉化 bat 与扩展包针对 Windows 中文环境（bat 为 GBK 编码）；
> 若查看 bat 源码出现乱码，请用 ANSI/GBK 编码打开。

## 🖥 从源码编译 Aseprite v1.3.18.5（Windows）

本包附带 `src\build_aseprite.cmd`，可从官方源码一次性完成配置与编译。

### 前置要求

| 工具 | 获取方式 |
| --- | --- |
| Visual Studio 2022 Build Tools（含 C++ 工作负载） | `winget install Microsoft.VisualStudio.2022.BuildTools`（勾选 "使用 C++ 的桌面开发"） |
| CMake 3.20+ | `winget install Kitware.CMake` |
| Ninja | `winget install Ninja-build.Ninja` |
| Skia 预编译库（m124） | 从 [aseprite/skia releases](https://github.com/aseprite/skia/releases) 下载 `Skia-Windows-Release-x64.zip`，解压到 `C:\deps\m124`（需保证 `out\Release-x64` 目录存在） |

### 编译步骤

1. 从官方渠道获取源码（如 `Aseprite-v1.3.18.5-Source.zip`）并解压
2. 按需修改 `src\build_aseprite.cmd` 中的 `SRC`（源码路径）、`BUILD`（构建路径）、`SKIA`（Skia 路径）
3. 运行 `src\build_aseprite.cmd`，等待完成（约 10~40 分钟，取决于 CPU）
4. 产物位于构建目录的 `bin\` 下（`aseprite.exe` 与 `data\` 文件夹）

> 提示：Skia 从 GitHub 下载较慢时可用多线程下载工具（IDM/aria2 等）。

## ❓ 常见问题

**Q：界面中文出现乱码？**
先切回 English，安装主题扩展后再切换到 sChinese。

**Q：编译版/官方源码编译的程序里连 zh_Hans 都没有？**
自 Aseprite 1.3.18 起，各语言翻译从主仓库迁移到了 [aseprite/strings](https://github.com/aseprite/strings) 独立仓库（Weblate 管理）。将 `zh_Hans.ini` 放入 `data\strings\` 即可；本仓库已附带处理好的文件。

**Q：中文字体还是模糊？**
确认已启用 `Aseprite-CN` 主题（`Edit → Preferences → Theme`）。清晰字体来自主题内的字体链，未启用主题时 Aseprite 会回退到系统字体渲染。

**Q：在主题列表里点了主题没反应？**
列表里**单击只是选中**，不会应用。需要**双击**该主题，或选中后点击左下角**「选择主题(S)」**按钮，主题才会立即生效；「应用/确定」按钮本身不切换主题。

**Q：如何换回官方默认外观？**
`Edit → Preferences → Extensions` 中卸载 `aseprite-theme-cn`，`Language` 切回 `中文（简体）`（zh_Hans）即可。

**Q：Steam 版 / 官方安装版能用吗？**
能。扩展安装到用户目录 `%APPDATA%\Aseprite\extensions`，不修改安装文件，随时可卸载还原。

**Q：与官方 zh_Hans 的区别？**
官方自带中文已是完整翻译；本包在其基础上校对术语与语句，并搭配清晰字体主题解决模糊——**字体优化才是本包核心价值**。

## 📄 许可证

- 官方翻译与主题：© Igara Studio S.A.，[CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/)
- 汉化校对与字体主题修改：同样以 CC-BY-4.0 发布
- Zfull-GB 字体：来自社区主题包，版权归原作者所有
- Aseprite 本体：© Igara Studio S.A.（本仓库不包含、不分发 Aseprite 程序本体，请从[官方渠道](https://www.aseprite.org/)获取）

## 🙏 致谢

- [Aseprite](https://github.com/aseprite/aseprite) — David Capello & Igara Studio
- 官方 zh_Hans 翻译团队
- Just_Eleven（早期社区汉化）与像素主题作者 Ilija Melentijevic
