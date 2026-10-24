#!@bash@
set -euo pipefail

config_root="${XDG_CONFIG_HOME:-$HOME/.config}/xppen"
config_dir="$config_root/conf/xppen"

@coreutils@/bin/mkdir -p -- "$config_dir"
for source in @dataDir@/conf/xppen/*; do
  target="$config_dir/${source##*/}"
  if [[ ! -e "$target" ]]; then
    @coreutils@/bin/install -m600 -- "$source" "$target"
  fi
done

# The vendor hides its tray-close button when the session type is Wayland.
export XDG_SESSION_TYPE=x11
export QT_QPA_PLATFORM=xcb

cd -- "$config_root"
exec @program@ "$@"
