# -*- coding: utf-8 -*-
"""将 一键汉化.bat 从 UTF-8 转换为 GBK（中文 Windows cmd 原生兼容）"""
src = r'C:\Atian\Aseprite\Aseprite-Hanhua-Kit\一键汉化.bat'
t = open(src, encoding='utf-8').read()
# 去掉 chcp 65001（GBK bat 无需）
t = t.replace('chcp 65001 >nul\n', '')
open(src, 'w', encoding='gbk', newline='\r\n').write(t)
print('converted to GBK + CRLF, chars =', len(t))
