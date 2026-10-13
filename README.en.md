[中文](README.md) · **English**

# Aseprite Chinese Localization Kit (aseprite-cn-kit)

A complete Chinese localization solution for **Aseprite v1.3.18.5** (Windows x64):
a thoroughly refined Simplified Chinese translation + a crisp CJK font theme + a one-click installer — putting an end to the **blurry text** in the Chinese UI.

> This repository also ships scripts and instructions for building Aseprite entirely from source. The `一键汉化.bat` one-click installer works just as well with the official installed build.

---

## ✨ Features

- **Enhanced Simplified Chinese localization** (`sChinese`): a deep proofreading pass on top of the official `zh_Hans` (the latest translation from the [aseprite/strings](https://github.com/aseprite/strings) repository — all 1815 strings translated)
  - Unified terminology (palette / selection / sprite, etc.)
  - Polished stiff, literal phrasings (passive constructions, wordy subordinate clauses — 14+ in total)
  - Covers every string newly added in 1.3.18
- **Crisp CJK font theme** (`Aseprite-CN`): Latin letters and digits keep the official pixel font, while Chinese text falls back to
  Microsoft YaHei (Windows) / PingFang (macOS) / Source Han Sans (Linux) with anti-aliasing enabled
  - Light and dark skins: `cn-clear` (light) and `cn-clear-dark` (dark)
  - No more faint, blurry Chinese characters under the default theme
- **One-click install**: `一键汉化.bat` installs the extensions and switches the language and theme for you
- **Optional pixel-style theme**: `aseprite-theme-pixel` (Zfull-GB pixel CJK font — a complete localization with a retro pixel look)

## 🚀 Quick Start (one-click localization)

1. **Close Aseprite** (if it is running)
2. Download this repository (`Code → Download ZIP`) or grab an attachment from [Releases](../../releases) and extract it
3. Double-click **`一键汉化.bat`**
4. Restart Aseprite — done!

The one-click script automatically:

- Installs the localization extension → `%APPDATA%\Aseprite\extensions\aseprite-language-sChinese`
- Installs the crisp font theme → `%APPDATA%\Aseprite\extensions\aseprite-theme-cn`
- Writes the configuration: language `sChinese`, theme `cn-clear` (edits `%APPDATA%\Aseprite\aseprite.ini`)

## 🔧 Manual Installation (if you prefer not to use the script)

1. Double-click `extensions\hanhua-1.3.18.5.aseprite-extension`; Aseprite opens an install dialog — click **Install**
2. Double-click `extensions\aseprite-theme-cn-1.0.0.aseprite-extension` and click **Install**
3. Menu: `Edit → Preferences → General → Language` — select **sChinese**
4. Menu: `Edit → Preferences → Theme` — select **Aseprite-CN** (or Aseprite-CN Dark)

## 📦 Repository Contents

| Path | Description |
| --- | --- |
| `一键汉化.bat` | One-click install: extensions + language + theme configuration |
| `extensions/hanhua-1.3.18.5.aseprite-extension` | Enhanced Simplified Chinese language extension |
| `extensions/aseprite-theme-cn-1.0.0.aseprite-extension` | Crisp CJK font theme (mixed-script approach) |
| `themes/中文字体主题合集.zip` | Bundle of the two extensions above plus the pixel theme |
| `themes/aseprite-theme-pixel.aseprite-extension` | Community pixel-style theme (Zfull-GB pixel CJK font; theme ID: `aseprite-theme-pixel`) |
| `fonts/中文字体包.zip` | Zfull-GB pixel CJK font + installation instructions |
| `src/` | Build scripts and the source files used to generate the localization and themes (reproducible) |

> **Note**: the one-click `.bat` and the extension packages target a Chinese-language Windows environment (the `.bat` is GBK-encoded);
> if the `.bat` source looks garbled, open it with ANSI/GBK encoding.

## 🖥 Building Aseprite v1.3.18.5 from Source (Windows)

This kit includes `src\build_aseprite.cmd`, which configures and builds everything from the official sources in a single run.

### Prerequisites

| Tool | How to get it |
| --- | --- |
| Visual Studio 2022 Build Tools (with the C++ workload) | `winget install Microsoft.VisualStudio.2022.BuildTools` (select "Desktop development with C++") |
| CMake 3.20+ | `winget install Kitware.CMake` |
| Ninja | `winget install Ninja-build.Ninja` |
| Prebuilt Skia libraries (m124) | Download `Skia-Windows-Release-x64.zip` from [aseprite/skia releases](https://github.com/aseprite/skia/releases) and extract it to `C:\deps\m124` (the `out\Release-x64` directory must exist) |

### Build Steps

1. Obtain the sources from an official channel (e.g. `Aseprite-v1.3.18.5-Source.zip`) and extract them
2. Adjust `SRC` (source path), `BUILD` (build path) and `SKIA` (Skia path) in `src\build_aseprite.cmd` as needed
3. Run `src\build_aseprite.cmd` and wait for it to finish (roughly 10–40 minutes, depending on your CPU)
4. The output lands in the `bin\` folder of the build directory (`aseprite.exe` and the `data\` folder)

> Tip: if Skia downloads slowly from GitHub, use a multi-threaded download tool (IDM, aria2, etc.).

## ❓ FAQ

**Q: The Chinese UI shows garbled text.**
Switch back to English first, install the theme extension, then switch to sChinese.

**Q: There isn't even a zh_Hans in a self-compiled build or one built from official sources.**
Starting with Aseprite 1.3.18, the per-language translations moved out of the main repository into the standalone [aseprite/strings](https://github.com/aseprite/strings) repository (managed via Weblate). Just drop `zh_Hans.ini` into `data\strings\`; this repository already ships a prepared file.

**Q: The Chinese text is still blurry.**
Make sure the `Aseprite-CN` theme is enabled (`Edit → Preferences → Theme`). The crisp fonts come from the font chain inside the theme; without the theme enabled, Aseprite falls back to system font rendering.

**Q: I clicked a theme in the theme list but nothing happened.**
In the list, a **single click only selects** a theme; it does not apply it. You need to **double-click** the theme, or select it and click the **"Select Theme (S)"** button in the lower-left corner — only then does the theme take effect immediately. The "Apply/OK" buttons themselves do not switch the theme.

**Q: How do I go back to the official default appearance?**
In `Edit → Preferences → Extensions`, uninstall `aseprite-theme-cn`, then switch `Language` back to `中文（简体）` (zh_Hans).

**Q: Does it work with the Steam version or the official installed version?**
Yes. The extensions are installed into the user directory `%APPDATA%\Aseprite\extensions`, without modifying any installed files, so you can uninstall and revert at any time.

**Q: How does this differ from the official zh_Hans?**
The official Chinese translation is already complete. This kit proofreads its terminology and wording, and pairs it with a crisp font theme to fix the blurriness — **the font optimization is the core value of this kit.**

## 📄 License

- Official translation and theme: © Igara Studio S.A., [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/)
- The proofreading and the font-theme modifications: also released under CC-BY-4.0
- Zfull-GB font: comes from a community theme package; copyright belongs to its original author
- Aseprite itself: © Igara Studio S.A. (this repository does **not** bundle or distribute the Aseprite program itself; get it from the [official site](https://www.aseprite.org/))

## 🙏 Credits

- [Aseprite](https://github.com/aseprite/aseprite) — David Capello & Igara Studio
- The official zh_Hans translation team
- Just_Eleven (early community localization) and pixel-theme author Ilija Melentijevic
