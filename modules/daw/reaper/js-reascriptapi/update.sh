#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
output="$script_dir/sources.nix"

metadata_url="https://raw.githubusercontent.com/ReaTeam/Extensions/master/API/js_ReaScriptAPI.ext"

for cmd in curl jq nix; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing command: $cmd" >&2
    exit 1
  fi
done

metadata="$(curl -fsSL "$metadata_url")"

version="$(
  printf '%s\n' "$metadata" |
    grep -oE '@version[[:space:]]+[^[:space:]]+' |
    head -n1 |
    awk '{ print $2 }'
)"

if [[ -z "$version" ]]; then
  echo "Failed to get js_ReaScriptAPI version" >&2
  exit 1
fi

plugin_name="reaper_js_ReaScriptAPI64.so"

plugin_template="$(
  printf '%s\n' "$metadata" |
    awk -v name="$plugin_name" '
      {
        for (i = 1; i <= NF; i++) {
          if ($i == "[linux64]" && $(i + 1) == name) {
            print $(i + 2)
            exit
          }
        }
      }
    '
)"

if [[ -z "$plugin_template" ]]; then
  echo "Failed to find $plugin_name" >&2
  exit 1
fi

plugin_url="${plugin_template//\$version/$version}"
plugin_url="${plugin_url//\$path/$plugin_name}"

echo "js_ReaScriptAPI $version"
echo
echo "Prefetching:"
echo "  $plugin_url"

plugin_hash="$(
  nix store prefetch-file \
    --json \
    "$plugin_url" |
    jq -r '.hash'
)"

tmp="$(mktemp "$script_dir/sources.nix.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

cat >"$tmp" <<EOF
{
  version = "$version";

  plugin = {
    url = "$plugin_url";
    hash = "$plugin_hash";
  };
}
EOF

mv "$tmp" "$output"
trap - EXIT

echo
echo "Updated $output"