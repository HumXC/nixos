{pkgs, ...}: let
  ndkVersions = "25.1.8937393";
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformToolsVersion = "33.0.3";
    buildToolsVersions = ["30.0.3"];
    includeEmulator = false;
    platformVersions = ["26"];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = ["google_apis_playstore"];
    abiVersions = ["arm64-v8a"];
    cmakeVersions = ["3.10.2"];
    includeNDK = true;
    ndkVersions = [ndkVersions];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;gcm"
    ];
  };
in
  (pkgs.buildFHSUserEnv {
    name = "android-sdk-env";
    targetPkgs = pkgs: (with pkgs; [
      glibc
      # android-studio
    ]) ++ [androidComposition.androidsdk];
    profile = ''
      export ANDROID_HOME=${androidComposition.androidsdk}/libexec/android-sdk
      echo ANDROID_HOME: $ANDROID_HOME

      export SYSROOT=$ANDROID_HOME/ndk/${ndkVersions}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/
      echo SYSROOT: $SYSROOT

      export PATH=$PATH:$ANDROID_HOME/ndk/${ndkVersions}
      export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
      export CFLAGS="I$SYSROOT/usr/include"
      export LDFLAGS="-L$SYSROOT/usr/lib -lz"

    '';
  })
  .env
