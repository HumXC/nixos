#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${REAPERTIPS_INSTALL_ENV:-}" ]]; then
  exec nix shell \
    nixpkgs#unzip \
    nixpkgs#fontconfig \
    nixpkgs#coreutils \
    nixpkgs#findutils \
    --command env \
      REAPERTIPS_INSTALL_ENV=1 \
      "$0" "$@"
fi

readonly PRODUCT_URL="https://www.reapertips.com/products/reapertips-theme"

usage() {
  cat <<EOF_USAGE
Reapertips Theme installer for Linux / REAPER

1. Open the official product page and obtain the Reapertips Theme ZIP archive:
   $PRODUCT_URL

2. Run this script with the downloaded ZIP file:
   $(basename "$0") ~/Downloads/Reapertips\ Theme\ v1.93b.zip

The installer will:
  - install the bundled fonts into your user font directory
  - install the main theme and all theme variations into REAPER/ColorThemes

It will not install anything system-wide and will not delete unrelated REAPER themes or fonts.
EOF_USAGE
}

if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi

if [[ $# -ne 1 ]]; then
  echo "Error: expected exactly one ZIP file." >&2
  echo >&2
  usage >&2
  exit 2
fi

archive="$1"

if [[ ! -f "$archive" ]]; then
  echo "Error: file not found: $archive" >&2
  exit 1
fi

case "$archive" in
  *.zip|*.ZIP) ;;
  *)
    echo "Error: expected a .zip archive: $archive" >&2
    exit 1
    ;;
esac

if ! command -v unzip >/dev/null 2>&1; then
  cat >&2 <<'EOF_ERROR'
Error: 'unzip' is required but was not found.

On NixOS you can run this installer from a temporary environment with:
  nix shell nixpkgs#unzip -c ./install.sh /path/to/theme.zip
EOF_ERROR
  exit 1
fi

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"

reaper_theme_dir="$config_home/REAPER/ColorThemes"
font_target_dir="$data_home/fonts/reapertips-theme"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

# Some Reapertips releases contain a harmless mismatch between ZIP local and
# central-directory filenames (notably U+2013 EN DASH). Info-ZIP returns 1 for
# these warnings even though extraction succeeds, so accept status 0 or 1.
unzip_log="$tmpdir/unzip.log"

set +e
unzip -q "$archive" -d "$tmpdir" 2>"$unzip_log"
unzip_status=$?
set -e

if (( unzip_status > 1 )); then
  echo "Error: failed to extract archive: $archive" >&2
  cat "$unzip_log" >&2
  exit 1
fi

font_source_dir="$(find "$tmpdir" -type d -name '01_Install these fonts' -print -quit)"
theme_source_dir="$(find "$tmpdir" -type d -name '02_Theme' -print -quit)"

if [[ -z "$font_source_dir" || -z "$theme_source_dir" ]]; then
  cat >&2 <<'EOF_ERROR'
Error: this archive does not look like a Reapertips Theme package.
Expected to find:
  01_Install these fonts/
  02_Theme/
EOF_ERROR
  exit 1
fi

mapfile -d '' -t font_files < <(
  find "$font_source_dir" -maxdepth 1 -type f \( -iname '*.ttf' -o -iname '*.otf' \) -print0
)

mapfile -d '' -t theme_files < <(
  find "$theme_source_dir" -type f -name '*.ReaperThemeZip' -print0
)

if (( ${#font_files[@]} == 0 )); then
  echo "Error: no font files found in the archive." >&2
  exit 1
fi

if (( ${#theme_files[@]} == 0 )); then
  echo "Error: no .ReaperThemeZip files found in the archive." >&2
  exit 1
fi

mkdir -p "$font_target_dir" "$reaper_theme_dir"

echo "Installing fonts to:"
echo "  $font_target_dir"

for src in "${font_files[@]}"; do
  name="$(basename "$src")"
  install -m 0644 "$src" "$font_target_dir/$name"
  echo "  + $name"
done

echo
echo "Installing REAPER themes to:"
echo "  $reaper_theme_dir"

for src in "${theme_files[@]}"; do
  name="$(basename "$src")"

  # Some versions encode U+2013 as the literal token '#U2013' in the ZIP
  # central directory. Restore the intended filename on installation.
  name="${name// #U2013 / – }"

  install -m 0644 "$src" "$reaper_theme_dir/$name"
  echo "  + $name"
done

echo
if command -v fc-cache >/dev/null 2>&1; then
  echo "Refreshing the user font cache..."
  fc-cache -f "$font_target_dir" >/dev/null
else
  echo "Warning: fc-cache was not found; fonts were installed but the font cache was not refreshed." >&2
fi

echo
echo "Installation complete."
echo "Restart REAPER if it is running, then select the theme from Options -> Themes."
