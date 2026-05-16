{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libreoffice-fresh

    # Required for spellchecking and hyphenation within LibreOffice documents
    hunspell
    hunspellDicts.de_CH
    hunspellDicts.en_US
    hyphenDicts.de_CH
    hyphenDicts.en_US
  ];
}
