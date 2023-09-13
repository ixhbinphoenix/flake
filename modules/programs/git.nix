{pkgs, ...}:
{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
    extraConfig = {
      user = {
        name = "ixhbinphoenix";
        email = "47122082+ixhbinphoenix@users.noreply.github.com";
        signingkey = "3E62370C1D773013";
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
