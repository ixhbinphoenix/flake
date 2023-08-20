{pkgs, ...}:
{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
    extraConfig = {
      user = {
        signingkey = "BA62877F1E9D4833";
        name = "ixhbinphoenix";
        email = "47122082+ixhbinphoenix@users.noreply.github.com";
      };
      commit = {
        sign = true;
        gpgsign = true;
      };
      init = {
        defaultBranch = "master";
      };
    };
  };
}
