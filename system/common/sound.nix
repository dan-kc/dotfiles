{ pkgs, ... }:

{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    pulseaudio.enable = false;
  };

  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
  ];
}
