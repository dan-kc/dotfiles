{
  fetchurl,
  lib,
  stdenvNoCC,
}:
let
  version = "1.14.0";
  assets = {
    aarch64-darwin = {
      name = "darwin-arm64";
      hash = "sha256-6OTNGuqpXoResBjFWwxZheGC2hcqoNSQKS7FqJkGT78=";
    };
    x86_64-darwin = {
      name = "darwin-amd64";
      hash = "sha256-QH3Ew85QspbGpvd6W60RjIJ4viKjec6e0KiX4CoMK+s=";
    };
    aarch64-linux = {
      name = "linux-arm64";
      hash = "sha256-Laz18AD4YQdWCcqRr0ILxpBPuPgb30S96pE6Me31zGY=";
    };
    x86_64-linux = {
      name = "linux-amd64";
      hash = "sha256-P6+He7eHICad0hUhWrfPR0G/GI4WO48YASy+LTujA30=";
    };
  };
  asset = assets.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "open-code-review";
  inherit version;

  src = fetchurl {
    url = "https://github.com/alibaba/open-code-review/releases/download/v${version}/opencodereview-${asset.name}";
    inherit (asset) hash;
  };
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/ocr"
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/alibaba/open-code-review";
    license = lib.licenses.asl20;
    mainProgram = "ocr";
    platforms = builtins.attrNames assets;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
