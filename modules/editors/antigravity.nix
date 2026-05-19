{
  pkgs-unstable,
  ...
}:

{
  environment.systemPackages = [
    pkgs-unstable.antigravity
  ];
}
