# lightpanda

Nix package for the [Lightpanda](https://github.com/lightpanda-io/browser) headless browser binary releases.

This package downloads the upstream Linux release binary and lets `autoPatchelfHook` adapt it for the Nix store.

## Usage

This package is loaded by `/etc/nixos/pkgs/default.nix` as `lightpanda`.

Example system usage:

```nix
environment.systemPackages = [ pkgs.lightpanda ];
```

## Update

Update to the latest stable GitHub release:

```bash
./update.sh
```

Update to a specific release:

```bash
./update.sh 0.3.1
```

`update.sh` follows the nixpkgs `qq` updater style: it runs through `nix-shell`, fetches release metadata, skips non-semver tags like `nightly`, prefetches both supported Linux binaries, converts their hashes to SRI format, and regenerates `sources.nix`.

Supported platforms:

- `x86_64-linux`
- `aarch64-linux`
