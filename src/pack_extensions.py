# -*- coding: utf-8 -*-
"""打包 .aseprite-extension（标准 zip：根目录 package.json）"""
import zipfile, os

KIT = r'C:\Atian\Aseprite\Aseprite-Hanhua-Kit'

def pack(srcdir, out, arc_prefix=''):
    files = []
    for root, _, names in os.walk(srcdir):
        for n in names:
            full = os.path.join(root, n)
            rel = os.path.relpath(full, srcdir).replace('\\', '/')
            files.append((full, arc_prefix + rel))
    with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for full, arc in files:
            z.write(full, arc)
    print('packed', out, len(files), 'files,', os.path.getsize(out), 'bytes')

# 汉化扩展：src/hanhua/1.3.17/* -> 根目录
pack(os.path.join(KIT, 'src', 'hanhua', '1.3.18.5'),
     os.path.join(KIT, 'extensions', 'hanhua-1.3.18.5.aseprite-extension'))

# 主题扩展：src/theme-msyh/aseprite-theme-msyh/* -> 根目录
pack(os.path.join(KIT, 'src', 'theme-msyh', 'aseprite-theme-msyh'),
     os.path.join(KIT, 'extensions', 'aseprite-theme-cn-1.1.0.aseprite-extension'))
