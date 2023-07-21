{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
}:

stdenvNoCC.mkDerivation rec {
  pname = "fluent-icon";
  version = "2023-06-07";

  src = fetchFromGitHub {
    repo = "Fluent-icon-theme";
    owner = "vinceliuice";
    rev = version;
    sha256 = "sha256-drEAjIY/lacqncSeVeNmeRX6v4PnLvGo66Na1fuFXRg=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  preInstall = ''
    mkdir -p $out/share/icons
  '';

  installPhase = ''
    runHook preInstall
    bash install.sh -a -d $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fluent icon theme for linux desktops";
    homepage = "https://github.com/vinceliuice/Fluent-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}