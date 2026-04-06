{
  config.flake.factory.git-user-hm = { key, name, email }@user: {
    programs.git = {
      signing.key = user.key;
      settings.user = {
        name = user.name;
        email = user.email;
      };
    };
  };
}
