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
        email = "phoenix@ixhby.dev";
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
