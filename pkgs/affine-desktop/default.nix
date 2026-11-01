{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
}:
let
  # Match the self-hosted server. The pinned nixpkgs client (0.26.7)
  # expects the old auth preflight response and falls back to email codes.
  pname = "affine";
  version = "0.27.4";
  src = fetchurl {
    url = "https://github.com/toeverything/AFFiNE/releases/download/v${version}/affine-${version}-stable-linux-x64.appimage";
    hash = "sha256-EC/wk+o69wZ4k+dq6FuKXVgYqpLIeF05kxK9j0aPXKw=";
  };
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "AFFiNE";
    exec = "affine %U";
    terminal = false;
    categories = [ "Utility" ];
    mimeTypes = [ "x-scheme-handler/affine" ];
    startupWMClass = "AFFiNE";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/
  '';
  meta = {
    description = "AFFiNE desktop client matching the self-hosted server";
    homepage = "https://affine.pro/";
    mainProgram = "affine";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
