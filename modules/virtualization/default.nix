{
  pkgs,
  userConfig,
  ...
}:

{
  # Enable the libvirtd daemon
  virtualisation.libvirtd.enable = true;

  # Add user to the libvirtd group
  users.users.${userConfig.username}.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  # Trust the libvirt bridge interface
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Install the virtualization clients and tools
  environment.systemPackages = with pkgs; [
    qemu_full
    virt-manager
  ];
}
