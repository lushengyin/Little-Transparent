# 小透明 (Little Transparent)

一款 macOS 原生浮动小窗口工具，可以置顶在其他应用上方，支持调整透明度和窗口层级。适合在工作时隐蔽地看小说、看视频等。

## 功能特性

- **自由缩放** — 窗口大小随意调整
- **透明度调节** — 滑块或快捷键控制窗口透明度，放在其他应用上方时可以非常隐蔽
- **三级置顶** — 普通层级 / 浮动层级 / 最顶层，按需切换
- **多标签页** — 同时打开多个内容，底部标签栏一键切换
- **嵌入网页** — 在小窗口中浏览任意网站
- **本地文本** — 打开 TXT 文件阅读，自动渲染为排版舒适的阅读视图
- **EPUB 电子书** — 打开 EPUB 格式的电子书
- **本地视频** — 播放本地视频文件，带播放控制
- **菜单栏模式** — 无 Dock 图标，只显示菜单栏小图标，更低调
- **状态记忆** — 窗口透明度、层级、标签页等设置自动保存

## 截图 你好

<!-- 可以后续添加截图 -->

## 系统要求

- macOS 13.0 (Ventura) 及以上

## 安装

### 从源码构建

1. 克隆仓库：

```bash
git clone git@github.com:lushengyin/Little-Transparent.git
cd Little-Transparent
```

2. 安装 [xcodegen](https://github.com/yonaskolb/XcodeGen)（如果还没有）：

```bash
brew install xcodegen
```

3. 生成 Xcode 项目并构建：

```bash
xcodegen generate
open Little\ Transparent.xcodeproj
```

4. 在 Xcode 中按 `Cmd+R` 运行

## 使用方法

1. 启动应用后会出现一个浮动小窗口
2. 点击底部的 **+** 按钮添加内容：
   - 输入网址打开网页
   - 选择本地文本文件、EPUB 电子书或视频文件
3. 拖动顶部滑块调整窗口透明度
4. 点击滑块旁的层级按钮切换窗口置顶级别
5. 底部标签栏可以切换不同内容

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Cmd+N` | 添加新标签 |
| `Cmd++` | 增加透明度 |
| `Cmd+-` | 降低透明度 |
| `Cmd+L` | 切换窗口层级 |

## 技术栈

- **语言**: Swift
- **UI 框架**: SwiftUI + AppKit
- **网页渲染**: WebKit (WKWebView)
- **视频播放**: AVKit (AVPlayer)
- **窗口系统**: NSPanel (非激活浮动面板)

## 项目结构

```
Little Transparent/
├── App/
│   └── LittleTransparentApp.swift    # 应用入口
├── Models/
│   ├── TabItem.swift                  # 标签页数据模型
│   └── WindowConfig.swift             # 窗口配置（透明度、层级）
├── ViewModels/
│   └── MainViewModel.swift            # 主窗口状态管理
├── Views/
│   ├── MainWindowView.swift           # 主界面
│   ├── ControlBarView.swift           # 顶部控制栏
│   ├── WebViewContainer.swift         # 网页/文本/EPUB 渲染容器
│   ├── VideoPlayerView.swift          # 视频播放器
│   ├── TabBarView.swift               # 底部标签栏
│   └── AddTabSheet.swift              # 添加标签弹窗
├── Helpers/
│   ├── WindowLevel.swift              # 窗口层级工具
│   └── FileOpener.swift               # 文件打开工具
└── Assets.xcassets/                    # 资源文件
```

## 许可证

MIT License
