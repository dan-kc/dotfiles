{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "heptabase";
  version = "1.115.0";
  src = fetchurl {
    url = "https://github.com/heptameta/project-meta/releases/download/v${version}/Heptabase-${version}.AppImage";
    hash = "sha256-D3b/M6TClzKqWmHbjS67fDHaSaEJVaJOd8grtzLBaTw=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/project-meta.desktop $out/share/applications/heptabase.desktop
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/0x0/apps/project-meta.png $out/share/icons/hicolor/512x512/apps/heptabase.png

    substituteInPlace $out/share/applications/heptabase.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=heptabase %U' \
      --replace-fail 'Icon=project-meta' 'Icon=heptabase'
  '';

  meta = {
    description = "A visual note-taking tool for learning complex topics";
    homepage = "https://heptabase.com/";
    changelog = "https://github.com/heptameta/project-meta/releases/tag/v${version}";
    license = lib.licenses.unfree;
    mainProgram = "heptabase";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
