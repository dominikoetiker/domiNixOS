{
  pkgs-unstable,
  ...
}:

{
  environment.systemPackages = [
    pkgs-unstable.jetbrains.idea
  ];
}
