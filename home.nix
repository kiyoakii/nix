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
      signing.signByDefault = false;
      signing.key = null;

      extraConfig = {
        credential.helper = "${
            pkgs.git.override { withLibsecret = true; }
          }/bin/git-credential-libsecret";
      };
    };
    gitui.enable = true;
    
    fish = {
      enable = true;
      plugins = with pkgs.fishPlugins; [ 
        sponge fzf-fish forgit grc bass
      ];
    };
  };

  home.packages = with pkgs; [ 
    htop
    grc
    fzf
    btop
    p7zip
    helix
  ];
}
