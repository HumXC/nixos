{
  lib,
  feishu,
  fetchurl,
}:
feishu.overrideAttrs (prev: {
  pname = "lark";
  version = "7.50.14";
  src = fetchurl {
    url = "https://sf16-sg.larksuitecdn.com/obj/lark-artifact-storage/31c1c2ee/Lark-linux_x64-7.50.14.deb";
    hash = "sha256-cI0qDNG0McQtby1tzdVm5ixiGMuIvuNofALKKphVtS0=";
  };
  installPhase = lib.replaceString "feishu" "lark" prev.installPhase;
  meta.mainProgram = "bytedance-lark";
})
