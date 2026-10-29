{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
  makeWrapper,
}:
let
  version = "0.1.2";
  darwinAppName = "T3 Code (Beta)";
  sources = {
    x86_64-linux = {
      url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
      hash = "sha256-zwHi0Wfv+dAcTBAE0xssDaniUizJQmLkFkTRyxXf21w=";
    };
    aarch64-darwin = {
      url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-arm64.dmg";
      hash = "sha256-e7QPln8iAHKFuMe8DIS9NmDuSk7ZatcfLoiHUOUnU5Y=";
    };
  };
  source = sources.${stdenv.hostPlatform.system} or (throw "t3code-desktop: unsupported system ${stdenv.hostPlatform.system}");
in
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    pname = "t3code-desktop";
    inherit version;

    src = fetchurl { inherit (source) url hash; };

    nativeBuildInputs = [ undmg ];

    sourceRoot = "${darwinAppName}.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -r . "$out/Applications/${darwinAppName}.app"
      mkdir -p $out/bin
      ln -s "$out/Applications/${darwinAppName}.app/Contents/MacOS/${darwinAppName}" $out/bin/t3-desktop
      runHook postInstall
    '';

    meta = {
      description = "T3 Code desktop app";
      homepage = "https://github.com/pingdotgg/t3code";
      license = lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
    };
  }
else
  appimageTools.wrapType2 rec {
    pname = "t3code-desktop";
    inherit version;
    src = fetchurl { inherit (source) url hash; };

    nativeBuildInputs = [ makeWrapper ];

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/t3code-desktop.desktop <<EOF
      [Desktop Entry]
      Name=T3 Code
      Exec=t3code-desktop %U
      Type=Application
      Categories=Development;
      Comment=T3 Code desktop app
      EOF
      ln -s $out/bin/t3code-desktop $out/bin/t3-desktop
    '';

    meta = {
      description = "T3 Code desktop app";
      homepage = "https://github.com/pingdotgg/t3code";
      license = lib.licenses.mit;
      mainProgram = "t3code-desktop";
      platforms = [ "x86_64-linux" ];
    };
  }
