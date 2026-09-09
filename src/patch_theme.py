# -*- coding: utf-8 -*-
"""给优化主题的 theme.xml 写入中文清晰字体链（英文像素字体 + 中文雅黑回退）"""

OLD_FONTS = '''    <fonts>
        <font id="default" font="Aseprite"/>
        <font id="mini" font="Aseprite Mini" mnemonics="off"/>
    </fonts>'''

NEW_FONTS = '''    <fonts>
        <!-- 中文清晰字体：微软雅黑(Windows) / 苹方(macOS) / 思源黑体(Linux)，开启抗锯齿 -->
        <font name="CNFont" type="truetype"
              file_win="msyh.ttc"
              file_mac="PingFang.ttc"
              file_linux="NotoSansCJK-Regular.ttc"
              antialias="true"/>
        <!-- 官方像素英文字体 + 中文清晰回退，混排保持原生观感 -->
        <font name="AsepriteCN" type="spritesheet" descent="2" file="./aseprite_font.png">
            <fallback font="CNFont" size="12"/>
        </font>
        <font name="AsepriteMiniCN" type="spritesheet" descent="1" file="./aseprite_mini.png">
            <fallback font="CNFont" size="10"/>
        </font>
        <font id="default" font="AsepriteCN"/>
        <font id="mini" font="AsepriteMiniCN" mnemonics="off"/>
    </fonts>'''

for path in [
    r'C:\Atian\Aseprite\Aseprite-Hanhua-Kit\src\theme-msyh\aseprite-theme-msyh\theme.xml',
    r'C:\Atian\Aseprite\Aseprite-Hanhua-Kit\src\theme-msyh\aseprite-theme-msyh\dark\theme.xml',
]:
    t = open(path, encoding='utf-8').read()
    assert OLD_FONTS in t, 'font block not found in ' + path
    t = t.replace(OLD_FONTS, NEW_FONTS)
    t = t.replace('<theme name="Default"', '<theme name="Aseprite-CN"')
    open(path, 'w', encoding='utf-8', newline='\n').write(t)
    print('patched', path)
