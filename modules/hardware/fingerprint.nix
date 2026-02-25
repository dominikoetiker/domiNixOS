{
  config,
  pkgs,
  ...
}:

{
  # enable fingerprint reader
  services.fprintd.enable = true;
}
