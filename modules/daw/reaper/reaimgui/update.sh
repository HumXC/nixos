#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
output="$script_dir/sources.nix"

metadata_url="https://raw.githubusercontent.com/ReaTeam/Extensions/master/API/reaper_imgui.ext"

for cmd in curl jq nix; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing command: $cmd" >&2
    exit 1
  fi
done

metadata="$(curl -fsSL "$metadata_url")"

version="$(
  printf '%s\n' "$metadata" |
    awk '$1 == "@version" {
      print $2
      exit
    }'
)"

if [[ -z "$version" ]]; then
  echo "Failed to get ReaImGui version" >&2
  exit 1
fi

get_provide() {
  local type="$1"
  local name="$2"

  printf '%s\n' "$metadata" |
    awk -v type="$type" -v name="$name" '
      $1 == type && $2 == name {
        print $3
        exit
      }
    '
}

expand_url() {
  local template="$1"
  local path="$2"

  template="${template//\$version/$version}"
  template="${template//\$path/$path}"

  printf '%s\n' "$template"
}

get_hash() {
  nix store prefetch-file \
    --json \
    "$1" |
    jq -r '.hash'
}

plugin_name="reaper_imgui-x86_64.so"
imgui_lua_name="imgui.lua"
imgui_py_name="imgui.py"
gfx2imgui_lua_name="gfx2imgui.lua"

plugin_template="$(get_provide "[linux64]" "$plugin_name")"
imgui_lua_template="$(get_provide "[script]" "$imgui_lua_name")"
imgui_py_template="$(get_provide "[script]" "$imgui_py_name")"
gfx2imgui_lua_template="$(get_provide "[script]" "$gfx2imgui_lua_name")"

for value in \
  plugin_template \
  imgui_lua_template \
  imgui_py_template \
  gfx2imgui_lua_template
do
  if [[ -z "${!value}" ]]; then
    echo "Failed to find $value in ReaPack metadata" >&2
    exit 1
  fi
done

plugin_url="$(
  expand_url "$plugin_template" "$plugin_name"
)"

imgui_lua_url="$(
  expand_url "$imgui_lua_template" "$imgui_lua_name"
)"

imgui_py_url="$(
  expand_url "$imgui_py_template" "$imgui_py_name"
)"

gfx2imgui_lua_url="$(
  expand_url "$gfx2imgui_lua_template" "$gfx2imgui_lua_name"
)"

echo "ReaImGui $version"
echo

echo "Prefetching plugin..."
plugin_hash="$(get_hash "$plugin_url")"

echo "Prefetching imgui.lua..."
imgui_lua_hash="$(get_hash "$imgui_lua_url")"

echo "Prefetching imgui.py..."
imgui_py_hash="$(get_hash "$imgui_py_url")"

echo "Prefetching gfx2imgui.lua..."
gfx2imgui_lua_hash="$(get_hash "$gfx2imgui_lua_url")"

tmp="$(mktemp "$script_dir/sources.nix.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

cat >"$tmp" <<EOF
{
  version = "$version";

  plugin = {
    url = "$plugin_url";
    hash = "$plugin_hash";
  };

  imguiLua = {
    url = "$imgui_lua_url";
    hash = "$imgui_lua_hash";
  };

  imguiPy = {
    url = "$imgui_py_url";
    hash = "$imgui_py_hash";
  };

  gfx2imguiLua = {
    url = "$gfx2imgui_lua_url";
    hash = "$gfx2imgui_lua_hash";
  };
}
EOF

mv "$tmp" "$output"
trap - EXIT

echo
echo "Updated $output"