{
  # Set the target repository for the rendered manifests
  # and applications.
  # This should be replaced with yours, usually the same
  # repository as the nixidy definitions.
  nixidy.target.repository = "https://github.com/isbecker/homelab.git";

  # Set the target branch the rendered manifests for _this_
  # environment should be pushed to in the repository defined
  # above.
  nixidy.target.branch = "main";

  # Set the target sub-directory to copy the generated
  # manifests to when running `nixidy switch .#dev`.
  nixidy.target.rootPath = "./manifests/dev";
}
