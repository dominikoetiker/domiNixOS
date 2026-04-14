{
  pkgs-unstable,
  ...
}:

{
  environment.systemPackages = [
    pkgs-unstable.gemini-cli
  ];
}
