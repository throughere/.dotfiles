{
  config,
  pkgs,
  ...
}: let
  # quickphrase entries: key<TAB>phrase. ignoreUserConfig sets SKIP_FCITX_USER_PATH=1,
  # so ~/.local/share/fcitx5 is ignored and this has to ship through XDG_DATA_DIRS.
  kaomoji = pkgs.writeTextFile {
    name = "fcitx5-kaomoji";
    destination = "/share/fcitx5/data/quickphrase.d/kaomoji.mb";
    text = ''
      shy	(,,>﹏<,,)
      cry	(｡•́︿•̀｡)
      happy	(*≧▽≦)
      love	(♡˙︶˙♡)
      shrug	¯\_(ツ)_/¯
      flip	(╯°□°)╯︵ ┻━┻
      unflip	┬─┬ ノ( ゜-゜ノ)
      angry	(╬ಠ益ಠ)
      dead	(x_x)
      wink	(^_~)
      hug	(っ˘̩╭╮˘̩)っ
      sleep	(－_－) zzZ
      ok	(๑•̀ㅂ•́)و✧
      wat	(⊙_⊙)
      cat	(=^･ω･^=)
      bear	ʕ•ᴥ•ʔ
      lenny	( ͡° ͜ʖ ͡°)
      sparkle	(✧ω✧)
    '';
  };
in {
  environment.systemPackages = [kaomoji];

  i18n.inputMethod = {
    # Available since NixOS 24.11
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      ignoreUserConfig = true; # Use settings below, ignore user config
      addons = with pkgs; [
        fcitx5-mozc-ut # Japanese input method with the large UT dictionary
        catppuccin-fcitx5 # theme for the candidate popup
      ];
      settings = {
        globalOptions = {
          Hotkey = {
            TriggerKeys = "";
            EnumerateWithTriggerKeys = "False";
          };
          "Hotkey/EnumerateForwardKeys" = {
            "0" = "Control+Shift_L";
            "1" = "Control+Shift_R";
          };
          "Hotkey/EnumerateGroupForwardKeys"."0" = "Control+space";
          "Behavior/DisabledAddons"."0" = "kimpanel";
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "keyboard-ua";
          "Groups/1" = {
            Name = "Japanese";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/1/Items/0".Name = "mozc";
          GroupOrder = {
            "0" = "Default";
            "1" = "Japanese";
          };
        };
        addons = {
          # Ctrl+; then a key from kaomoji.mb, Enter -> inserts the kaomoji.
          # Works in any group, no need to switch to Japanese first.
          quickphrase.globalSection = {
            TriggerKey = "Control+semicolon";
            Choose = "None";
            Spell = "False";
          };
          # Candidate popup (the menu you cycle with Tab/Space)
          classicui.globalSection = {
            Theme = "catppuccin-mocha-mauve";
            DarkTheme = "catppuccin-mocha-mauve";
            Font = "Noto Sans CJK JP 16";
            MenuFont = "Noto Sans CJK JP 14";
            "Vertical Candidate List" = "True";
            PerScreenDPI = "True";
          };
        };
      };
    };
  };
}
