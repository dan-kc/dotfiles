{ pkgs, ... }:

{
  services = {
    pipewire = {
      # Force a consistent sample‑rate configuration
      extraConfig.pipewire."10-audio-setup" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
          ];
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 2048;
        };
      };
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # Disable DisplayLink dock audio - it can't be opened and the constant
      # error polling disrupts the audio graph, causing browser video to freeze
      wireplumber.extraConfig."50-disable-displaylink" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.name" = "~alsa_card.usb-DisplayLink*";
              }
            ];
            actions = {
              update-props = {
                "device.disabled" = true;
              };
            };
          }
        ];
      };
    };
    pulseaudio.enable = false;
  };

  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
  ];
}
