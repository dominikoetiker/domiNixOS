{
  pkgs-unstable,
  ...
}:

{
  environment.systemPackages = [
    pkgs-unstable.structurizr-cli
  ];
}
