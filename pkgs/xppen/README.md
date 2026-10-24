# XPPen Linux 驱动

打包 [Deco MW 官方下载页](https://www.xp-pen.com/download/deco-mw.html) 提供的 Linux tar.gz 驱动。当前版本为 `4.0.15-260422`，上游只提供 x86_64 二进制，许可证为 unfree。

## 构建与运行

在仓库根目录执行：

```sh
nix build path:.#xppen
./result/bin/xppen
```

也提供兼容命令 `PenTablet` 和桌面菜单入口。配置保存在 `${XDG_CONFIG_HOME:-$HOME/.config}/xppen/conf/xppen/`；首次启动仅复制缺失的默认文件，保留已有设置。

包使用 Nixpkgs 的 Qt 5，丢弃上游附带的 Qt 库。启动器设置 `XDG_SESSION_TYPE=x11` 和 `QT_QPA_PLATFORM=xcb`，默认通过 XWayland 运行，保留厂商在 Wayland 下会隐藏的关闭、最小化按钮；Wayland 会话需要启用 XWayland。配置加载和真实 Deco MW 接收器识别已在隔离环境中验证；压感和按键输入仍需交互测试。厂商 ELF 直接链接的 `libX11`、`libXtst`、`libXrandr` 必须保留。

用 `xppen /mini` 可以首次隐藏启动到托盘。已有实例时再次启动（包括传入 `/mini`）会显示现有窗口。点击程序自带的关闭按钮会隐藏到托盘并继续运行；通过 WM 的关闭命令关闭窗口仍会退出。

自定义按键需要驱动进程持续运行，隐藏窗口不影响驱动工作。驱动通过 libusb 读取设备 HID 报告，依据配置转换按键动作，再通过 `/dev/uinput` 的虚拟键盘输出 Linux 输入事件。界面和输入处理在同一个进程中；退出会停止转换并销毁虚拟输入设备。因此 Deco MW 的自定义快捷键依赖驱动常驻，保存设置后也应隐藏到托盘，而不是退出。XWayland 设置影响窗口显示，已确认的快捷键输出使用 uinput。

## NixOS 设备权限

在启用本仓库 `additions` overlay 的 NixOS 配置中，可加入：

```nix
{pkgs, ...}: {
  environment.systemPackages = [pkgs.xppen];
  services.udev.packages = [pkgs.xppen];
  boot.kernelModules = ["uinput"];
}
```

udev 规则来自官方压缩包，允许访问 XPPen USB 设备和 `/dev/uinput`。应用配置后重新连接设备，必要时重启以加载 `uinput`。仅构建或运行包不会安装系统 udev 规则。

若日志显示 `open uinput ok`，但同时出现 `hid_open_path Failed!` 和管理员权限提示，应检查 USB 设备访问权限。这版驱动使用 libusb，因此除了 `/dev/hidraw*`，还需要能读写对应的 `/dev/bus/usb/*/*` 节点。规则安装后，可让已连接的 XPPen 设备重新应用权限：

```sh
sudo udevadm control --reload-rules
sudo udevadm trigger --action=change --subsystem-match=usb --attr-match=idVendor=28bd
sudo udevadm trigger --action=change --subsystem-match=hidraw
sudo udevadm settle
```

`control --reload-rules` 只重载规则，`trigger` 或重新插拔设备才会更新现有节点权限。

## 更新

从任意目录运行：

```sh
/etc/nixos/pkgs/xppen/update.sh
```

脚本通过纯净的 `nix-shell` 提供依赖，自动抓取官方页面的 Linux 条目，按数字版本号及构建日期选择最新的 tar.gz，并从同一条目读取 `data-id`、`data-pid`、`data-ext`。下载地址格式为：

```text
https://www.xp-pen.com/download/file.html?id=4404&pid=846&ext=gz
```

这些 ID 由页面解析获得，脚本不固定使用当前值。没有额外的 JSON 元数据接口或登录步骤。

脚本预取压缩包、验证其可读取且含有预期的 ELF 驱动、计算 SHA-256 SRI，然后原子更新同目录的 `sources.nix`。页面解析、版本关联、下载或校验失败时保留旧文件；版本未变则不写入。更新后重新构建即可。
