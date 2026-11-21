# mpv-handler for Homebrew

本 Tap 为 [akiirui/mpv-handler](https://github.com/akiirui/mpv-handler) 提供 macOS 的 Homebrew 安装方式。

用 macOS 浏览器里的 `mpv-handler://` 链接启动 mpv。Homebrew 管理命令行程序、mpv 和 yt-dlp，另一个命令生成接收浏览器链接的应用外壳。

## 安装

```sh
brew install xlilu/mpv-handler/mpv-handler
create-mpv-handler-app
```

第二条命令创建 `~/Applications/mpv-handler.app`，并向 macOS 注册两种协议。`mpv-handler://` 直接启动播放，`mpv-handler-debug://` 会打开“终端”窗口，显示输出和错误信息。浏览器首次询问是否打开外部应用时，选择打开。

如果目标目录已有同名应用，脚本会提示并退出。要先检查新外壳，可指定另一个目录并跳过注册：

```sh
create-mpv-handler-app --no-register "$PWD/preview"
```

## 配合浏览器用户脚本使用

在浏览器中启用 Tampermonkey 或 Violentmonkey，再打开 [Greasy Fork 上的「使用 MPV 播放」](https://greasyfork.org/zh-CN/scripts/416271-play-with-mpv)，点击「安装此脚本」。

打开 YouTube 或哔哩哔哩的视频页，点击页面左下角的 mpv 图标即可播放。脚本的 `Run With Console` 默认是 `yes`，会打开 Terminal 显示播放输出和错误。要直接播放，在图标旁的齿轮设置中将它改为 `no` 并保存。

## 配置与升级

默认设置即可使用。自定义播放器、yt-dlp 路径或代理时，可编辑 `~/.config/mpv-handler/config.toml`。需要 cookie 文件时，将其放在 `~/.config/mpv-handler/cookies/`。如果应用环境中的 `XDG_CONFIG_HOME` 是绝对路径，两者都从 `$XDG_CONFIG_HOME/mpv-handler/` 读取。变量未设置或值为相对路径时，使用默认位置。[协议格式](https://github.com/xlilu/mpv-handler/blob/dev/README.zh-Hans.md)

如果此前的 Homebrew 版本在 `~/Library/Application Support/mpv-handler/` 中保存了配置，可将其中的 `config.toml` 和 `cookies/` 下的文件按原目录结构复制到当前配置目录，跳过已有的同名文件。

```sh
brew update
brew upgrade xlilu/mpv-handler/mpv-handler
```

外壳通过 Homebrew 的 `opt/mpv-handler` 路径调用当前核心。**如果外壳由 Formula `0.4.2_1` 或更早版本生成**，升级后请将旧应用移到废纸篓，再运行 `create-mpv-handler-app` 生成支持调试窗口的新外壳。如果曾指定安装目录，请把同一目录作为参数传给生成命令。

## 卸载

在 Finder 中把 `~/Applications/mpv-handler.app` 移到废纸篓。如果生成时指定了其他目录，请移除该目录里的应用。然后在终端卸载核心程序。

```sh
brew uninstall xlilu/mpv-handler/mpv-handler
```

如果也想移除这个 Tap，运行 `brew untap xlilu/mpv-handler`。

本项目使用了先安装核心、再在本机生成应用外壳的思路。[9beach/mpv-app-bundle](https://github.com/9beach/mpv-app-bundle)

## 许可证

mpv-handler 核心由 Akatsuki Rui 开发，以 MIT 许可证发布。本 Tap 的 Homebrew 打包代码由 xlilu 提供，同样采用 MIT 许可证。[上游 LICENSE](https://github.com/akiirui/mpv-handler/blob/main/LICENSE) · [Tap LICENSE](LICENSE)
