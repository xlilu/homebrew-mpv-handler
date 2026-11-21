# mpv-handler for Homebrew

用 macOS 浏览器里的 `mpv-handler://` 链接启动 mpv。Homebrew 管理命令行程序、mpv 和 yt-dlp，另一个命令生成接收浏览器链接的应用外壳。

## 安装

```sh
brew install xlilu/mpv-handler/mpv-handler
create-mpv-handler-app
```

第二条命令创建 `~/Applications/mpv-handler.app`，并向 macOS 注册 `mpv-handler://` 和 `mpv-handler-debug://`。浏览器首次询问是否打开外部应用时，选择打开。调试链接的输出保存在 `~/Library/Logs/mpv-handler/debug.log`。

如果目标目录已有同名应用，脚本会提示并退出。要替换旧版，请先将旧应用移到备份位置，再运行生成命令。要先检查新外壳，可指定另一个目录并跳过注册：

```sh
create-mpv-handler-app --no-register "$PWD/preview"
```

## 配置与升级

默认设置即可使用。自定义播放器、yt-dlp 路径或代理时，请编辑 `~/Library/Application Support/mpv-handler/config.toml`。[协议格式与浏览器用户脚本](https://github.com/xlilu/mpv-handler/blob/dev/README.zh-Hans.md)

```sh
brew update
brew upgrade xlilu/mpv-handler/mpv-handler
```

外壳通过 Homebrew 的 `opt/mpv-handler` 路径调用当前版本。常规核心升级后，已有外壳会自动使用新版本。

## 卸载

在 Finder 中把 `~/Applications/mpv-handler.app` 移到废纸篓。如果生成时指定了其他目录，请移除该目录里的应用。然后在终端卸载核心程序。

```sh
brew uninstall xlilu/mpv-handler/mpv-handler
```

如果也想移除这个 Tap，运行 `brew untap xlilu/mpv-handler`。

本项目使用了先安装核心、再在本机生成应用外壳的思路。[9beach/mpv-app-bundle](https://github.com/9beach/mpv-app-bundle)
