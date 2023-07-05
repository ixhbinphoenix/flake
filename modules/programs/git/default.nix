{pkgs, ...}:
{
  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        signingkey = "2524A3371AF14680";
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
