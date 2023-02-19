{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nabokov";
  home.homeDirectory = "/home/nabokov";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    
    git = {
      enable = true;
      userEmail = "lijin110110@gmail.com";
      userName  = "Jin Li";
      signing.signByDefault = true;
      signing.key = "/home/nabokov/.ssh/id_ed25519";

      extraConfig = {
        gpg.format = "ssh";
      };
    };
    gitui.enable = true;
   
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting;
        any-nix-shell fish --info-right | source;
        bind -k nul accept-autosuggestion;
      '';
      plugins = [];
      
    };
    
    helix = {
      enable = true;
      settings = {
        theme = "bogster";
        keys.normal = {};   
        editor = { 
          true-color = true;
          lsp.display-messages = true;
        };
      };
    };
  };

  home.packages = with pkgs; [ 
    btop
    p7zip
  ];
}
