#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure -p nix curl cacert python3 jq coreutils

set -euo pipefail

cd -- "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

if (( $# != 0 )); then
  echo "Usage: $0 (updates to the latest Linux tar.gz on the Deco MW download page)" >&2
  exit 1
fi

page_url="https://www.xp-pen.com/download/deco-mw.html"
work_dir=$(mktemp -d)
sources_tmp=""
trap 'rm -rf -- "$work_dir"; if [[ -n "$sources_tmp" ]]; then rm -f -- "$sources_tmp"; fi' EXIT

curl --fail --silent --show-error --location --retry 3 \
  --connect-timeout 20 --max-time 120 "$page_url" -o "$work_dir/page.html"

python3 - "$work_dir/page.html" >"$work_dir/metadata.json" <<'PY'
import json
import pathlib
import re
import sys
import xml.etree.ElementTree as ET
from html.parser import HTMLParser
from urllib.parse import urlencode


class PageParser(HTMLParser):
    void_tags = {"area", "base", "br", "col", "embed", "hr", "img",
                 "input", "link", "meta", "param", "source", "track", "wbr"}

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.root = ET.Element("document")
        self.stack = [self.root]

    def handle_starttag(self, tag, attrs):
        node = ET.SubElement(self.stack[-1], tag, dict((k, v or "") for k, v in attrs))
        if tag not in self.void_tags:
            self.stack.append(node)

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        if tag not in self.void_tags:
            self.stack.pop()

    def handle_endtag(self, tag):
        for index in range(len(self.stack) - 1, 0, -1):
            if self.stack[index].tag == tag:
                del self.stack[index:]
                break

    def handle_data(self, data):
        # Text-bearing driver fields contain no nested markup on the current page.
        node = self.stack[-1]
        node.text = (node.text or "") + data


def has_class(node, name):
    return name in node.get("class", "").split()


def text(node):
    return " ".join("".join(node.itertext()).split())


parser = PageParser()
parser.feed(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
parents = {child: parent for parent in parser.root.iter() for child in parent}
filename_pattern = re.compile(r"XPPenLinux-?(\d+\.\d+\.\d+)[-._](\d{6})\.tar\.gz", re.I)
candidates = []

for group in parser.root.iter("div"):
    if not (has_class(group, "js-driver-item") and group.get("data-tab-group") == "linux"):
        continue
    for name_node in group.iter("p"):
        if not has_class(name_node, "driver_item_name"):
            continue
        filename = text(name_node)
        match = filename_pattern.fullmatch(filename)
        if not match:
            continue
        # Find the smallest row that contains this filename and its download button.
        row = parents[name_node]
        while row is not group:
            names = [p for p in row.iter("p") if has_class(p, "driver_item_name")]
            links = [a for a in row.iter("a") if a.get("data-ext") == "gz"]
            if len(names) == 1 and len(links) == 1:
                break
            row = parents[row]
        else:
            raise SystemExit(f"Cannot associate a download button with {filename}")
        link = links[0]
        file_id, product_id = link.get("data-id", ""), link.get("data-pid", "")
        if not (re.fullmatch(r"[0-9]+", file_id) and re.fullmatch(r"[0-9]+", product_id)):
            raise SystemExit(f"Invalid download IDs for {filename}")
        version, build = match.groups()
        date = next((text(p) for p in row.iter("p") if has_class(p, "driver_item_time")), "")
        metadata = {
            "version": f"{version}-{build}",
            "filename": filename,
            "release_date": date,
            "url": "https://www.xp-pen.com/download/file.html?" + urlencode({
                "id": file_id, "pid": product_id, "ext": "gz",
            }),
        }
        candidates.append((tuple(map(int, version.split("."))) + (int(build),), metadata))

if not candidates:
    raise SystemExit("No valid XPPen Linux tar.gz release found; sources.nix was not changed")
latest = max(key for key, _ in candidates)
releases = [metadata for key, metadata in candidates if key == latest]
if len({(item["filename"], item["url"]) for item in releases}) != 1:
    raise SystemExit("Ambiguous latest XPPen release; sources.nix was not changed")
json.dump(releases[0], sys.stdout)
PY

version=$(jq -er '.version' "$work_dir/metadata.json")
filename=$(jq -er '.filename' "$work_dir/metadata.json")
release_date=$(jq -r '.release_date' "$work_dir/metadata.json")
url=$(jq -er '.url' "$work_dir/metadata.json")

echo "Prefetching $filename"
nix-prefetch-url --type sha256 --print-path --name "$filename" "$url" >"$work_dir/prefetch"
mapfile -t prefetched <"$work_dir/prefetch"
if [[ ${#prefetched[@]} != 2 ]]; then
  echo "Unexpected nix-prefetch-url output" >&2
  exit 1
fi

# Reject HTTP 200 error pages and archives that do not contain the driver.
python3 - "${prefetched[1]}" "$filename" <<'PY'
import sys
import tarfile

archive_path, filename = sys.argv[1:]
member_path = f"{filename.removesuffix('.tar.gz')}/App/usr/lib/pentablet/PenTablet"
with tarfile.open(archive_path, "r:gz") as archive:
    member = archive.getmember(member_path)
    if not member.isfile():
        raise SystemExit("Driver is not a regular file in the archive")
    with archive.extractfile(member) as driver:
        if driver.read(4) != b"\x7fELF":
            raise SystemExit("Archive does not contain an ELF driver")
PY
hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "${prefetched[0]}")

sources_tmp=$(mktemp ./.sources.nix.XXXXXX)
cat >"$sources_tmp" <<EOF
# Generated by ./update.sh - do not update manually!
# Upstream release date: $release_date
{fetchurl}: {
  version = "$version";
  src = fetchurl {
    name = "$filename";
    url = "$url";
    hash = "$hash";
  };
}
EOF
chmod 644 "$sources_tmp"

if [[ -f sources.nix ]] && cmp -s -- "$sources_tmp" sources.nix; then
  echo "Already up to date: $version"
else
  mv -f -- "$sources_tmp" sources.nix
  echo "Updated sources.nix to $version"
fi
