{
  fetchurl,
  makeWrapper,
  nodejs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "agent-device";
  version = "0.21.31";

  src = fetchurl {
    url = "https://registry.npmjs.org/agent-device/-/agent-device-${finalAttrs.version}.tgz";
    hash = "sha256-e0ho3urQDskYhinGbdnKbhVwjx12fVjwLrtMnozdFpg=";
  };
  sourceRoot = "package";
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/agent-device" "$out/bin"
    cp -R . "$out/lib/agent-device/"
    makeWrapper ${nodejs}/bin/node "$out/bin/agent-device" \
      --add-flags "$out/lib/agent-device/bin/agent-device.mjs" \
      --set-default AGENT_DEVICE_NO_UPDATE_NOTIFIER 1 \
      --set-default AGENT_DEVICE_SESSION_IDLE_TIMEOUT_MS 1200000 \
      --run 'export AGENT_DEVICE_STATE_DIR="''${AGENT_DEVICE_STATE_DIR:-$HOME/.t3/userdata/device/agent-device}"'
    runHook postInstall
  '';
})
