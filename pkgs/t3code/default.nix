{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  version = "0.1.2";
  platforms = {
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-3xEuHxl3K0BVooyXsDLrbQONXXGCAV8cr9MlStb6vQ8=";
    };
    x86_64-linux = {
      arch = "x64";
      hash = "sha256-eu1iXLlhk43xdMGgZ8DwUjU2CUC1PogqFkMSa3VNoWw=";
    };
  };
  platform = platforms.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  pname = "t3code-headless";
  inherit version;

  # The nixpkgs pin predates Pi support. Use the self-contained CLI archive
  # instead of building Electron and the entire web/desktop workspace on loft.
  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/t3-${version}-linux-${platform.arch}.tar.gz";
    inherit (platform) hash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];
  dontBuild = true;
  # Node's single-executable application embeds its JavaScript in the ELF.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec/t3code" "$out/bin"
    cp -r . "$out/libexec/t3code/"
    # NixOS uses glibc; the archive also includes an unused musl fff build.
    rm -rf "$out/libexec/t3code/node_modules/@ff-labs/fff-bin-linux-${platform.arch}-musl"
    ln -s "$out/libexec/t3code/t3" "$out/bin/t3"

    runHook postInstall
  '';

  meta = {
    description = "Headless T3 Code server for remote coding agents";
    homepage = "https://github.com/pingdotgg/t3code";
    license = lib.licenses.mit;
    mainProgram = "t3";
    platforms = builtins.attrNames platforms;
  };
}
