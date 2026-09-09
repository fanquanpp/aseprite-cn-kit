# -*- coding: utf-8 -*-
"""从官方 zh_Hans.ini 生成优化版 sChinese.ini
用法: python build_hanhua.py [zh_Hans.ini路径] [输出sChinese.ini路径]
默认针对 Aseprite 1.3.18.5 源码"""
import re, sys, os

SRC = sys.argv[1] if len(sys.argv) > 1 else \
    r'C:\Users\fanqu\Downloads\Aseprite-v1.3.18.5-Source (1)\data\strings\zh_Hans.ini'
DST = sys.argv[2] if len(sys.argv) > 2 else \
    r'C:\Atian\Aseprite\Aseprite-Hanhua-Kit\src\hanhua\1.3.17\sChinese.ini'

t = open(SRC, encoding='utf-8').read()

# 统一术语：调色板 -> 色板（像素艺术社区标准用语）；选择区域 -> 选区
t = t.replace('选择区域', '选区')
t = t.replace('调色板', '色板')

fixes = [
    # 精修生硬直译（\n 为 INI 内字面转义）
    (r'精灵正在被备份 / 数据恢复进程占用', '精灵正被备份/数据恢复进程占用'),
    (r'在精灵的帧被添加到精灵表之前修剪整个精灵', '先将精灵整体裁切空边，再将其帧添加到精灵表'),
    (r'当选区被修改时，自动显示选区边缘', '修改选区后自动显示选区边缘'),
    (r'当组合键被按下时，禁用变换控制柄', '按住组合键时禁用变换控制柄'),
    (r'如果按下 Shift/Ctrl/Alt 键，用于变换选区的控制柄将被暂时禁用',
     '按住 Shift/Ctrl/Alt 键时，将暂时禁用变换选区的控制柄'),
    (r'当按下鼠标按钮并将鼠标移动到另一个位置时，启用选择范围的图层/帧/单元格',
     '按住鼠标左键拖动时，即可连续框选图层/帧/单元格'),
    (r'图层被选择后闪烁', '选中图层时闪烁高亮'),
    (r'为每个界面窗口创建一个原生窗口。\n即菜单、预览和弹出窗口都有其自己的窗口。',
     '为每个界面窗口创建独立的原生窗口，\n菜单、预览和弹窗均互不合并。'),
    (r'每个像素都是一个色板的引用\n（每个像素 8 位）', '每个像素存储色板中的索引\n（每像素 8 位）'),
    (r'增加/减少一个单位需要鼠标移动的像素数', '鼠标每移动多少像素，数值增减一个单位'),
    (r'勾选此项将会自动向 Aseprite 开发人员分享崩溃数据，\n这将有助于发现新的错误并提高 Aseprite 对所有用户的稳定性',
     '自动向 Aseprite 开发者分享崩溃数据，\n帮助发现并修复错误，提升软件稳定性'),
    (r'信息\n<<此 Aseprite 副本不支持输入许可证密钥。\n<<请考虑从网站 https://aseprite.org/download 下载。\n<<激活的 Aseprite 将能获取自动更新。',
     '提示\n<<当前版本不支持输入许可证密钥。\n<<请从官网 https://aseprite.org/download 下载正式版。\n<<激活版可获取自动更新。'),
    (r'使用铅笔工具时可以\n按住 Shift 键并单击绘制直线，\n勾选此选项后，当按住 Shift 键时，你将实时看到预览',
     '使用铅笔工具时，按住 Shift 并单击可绘制直线；\n勾选后，按住 Shift 拖动时会实时显示直线预览'),
    (r'此文件最初是使用较新版本的 Aseprite 创建的，其中包含无法完全读取的信息。',
     '此文件由更高版本的 Aseprite 创建，包含本版本无法读取的信息。'),
]

miss = 0
for old, new in fixes:
    if old in t:
        t = t.replace(old, new)
    else:
        miss += 1
        print('MISS:', old[:40].replace('\\n', '<NL>'))

# 替换头部注释
head_end = t.index('[advanced_mode]')
new_head = '''# Aseprite 1.3.18.5 简体中文汉化 · 增强版
# 基于官方 zh_Hans（aseprite/strings 仓库）深度校对：统一术语（色板/选区）、润色生硬直译
# 原翻译授权 CC-BY-4.0，本优化版同样以 CC-BY-4.0 发布
# 汉化工具包：见项目仓库 README

'''
t = new_head + t[head_end:]

open(DST, 'w', encoding='utf-8', newline='\n').write(t)
print('OK, miss =', miss, ', total chars =', len(t))
