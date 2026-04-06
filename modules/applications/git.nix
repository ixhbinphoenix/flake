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
          ds = "diff --staged";
          dsl = "diff --staged ':!*.lock'";
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
