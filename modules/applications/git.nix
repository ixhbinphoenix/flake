{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      signing = {
        signByDefault = true;
        # key set per-user
      };

      settings = {
        alias = {
          staash = "stash --all";
          s = "status";
          ds = "diff --staged";
          dsl = "diff --staged ':!*.lock'";
          rs = "restore --staged";
        };
        # user settings set per-user
        init = {
          defaultBranch = "root";
        };
        pull = {
          rebase = true;
        };
      };
    };
  };
}
