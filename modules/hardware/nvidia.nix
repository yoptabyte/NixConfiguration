{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA proprietary drivers";
  };

  config = mkIf config.modules.hardware.nvidia.enable {
    # Enable graphics
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      #package = config.boot.kernelPackages.nvidiaPackages.stable;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
     
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Additional packages for NVIDIA and Vulkan
    environment.systemPackages = with pkgs; [
      nvidia-vaapi-driver
      libva
      libva-utils
      vulkan-loader
      vulkan-tools          # includes vulkaninfo
      vulkan-validation-layers
      #config.hardware.nvidia.package
      
      xorg.xorgserver
      xorg.xinit
      xorg.xauth
      xterm
      nvtopPackages.v3d
    ];

    # Environment variables for NVIDIA and Vulkan

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";

      # Vulkan
      VK_ICD_FILENAMES = "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json";
      #VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
    };

    environment.sessionVariables = {
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
     # QTWEBENGINE_CHROMIUM_FLAGS = "--disable-gpu --disable-vulkan";
    };
        
    boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  };
}
