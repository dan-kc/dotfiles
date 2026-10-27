{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  patchelf,
}:
let
  version = "0.1.2";
  # 0.19.2 corrupts this Node SEA executable on aarch64 (startup SIGSEGV).
  # Keep this tool pin independent of the T3 version; revisit on patcher updates.
  t3Patchelf = patchelf.overrideAttrs {
    version = "0.15.2";
    src = fetchurl {
      url = "https://github.com/NixOS/patchelf/releases/download/0.15.2/patchelf-0.15.2.tar.bz2";
      hash = "sha256-F3RfVkFZyOIo/EEtplogSLhGxLa0Igt3y/IkFuAvLXw=";
    };
  };
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

  nativeBuildInputs = [
    t3Patchelf
    autoPatchelfHook
  ];
  # Both stdenv's ELF fixup and autoPatchelfHook invoke patchelf via PATH.
  preFixup = ''
    export PATH="${lib.makeBinPath [ t3Patchelf ]}:$PATH"
  '';
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

  # installCheck runs after all ELF fixups, including autoPatchelf's hook.
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/t3" --version
    runHook postInstallCheck
  '';

  meta = {
    description = "Headless T3 Code server for remote coding agents";
    homepage = "https://github.com/pingdotgg/t3code";
    license = lib.licenses.mit;
    mainProgram = "t3";
    platforms = builtins.attrNames platforms;
  };
}
