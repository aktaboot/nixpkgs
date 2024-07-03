{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "taskchampion-sync-server";
  version = "0.4.1-unstable-2024-06-25";
  src = fetchFromGitHub {
      owner = "GothenburgBitFactory";
      repo = "taskchampion-sync-server";
      rev = "bb8febdf9193684f4c4cbe786147cb31a8fc0bae";
      fetchSubmodules = false;
      sha256 = "sha256-Zc3Iuw0SEVM2yNiWKWIYcQa8J7L61uCCrXUeLtNAobM=";
    };

  cargoHash = "sha256-l1+W9B4U0rgkTK8Tn9+RFuDVEtkOh2lYKKwAi60Rquw=";

  # cargo tests fail when checkType="release" (default)
  checkType = "debug";

  meta = {
    description = "Sync server for Taskwarrior 3";
    license = lib.licenses.mit;
    homepage = "https://github.com/GothenburgBitFactory/taskchampion-sync-server";
    maintainers = with lib.maintainers; [mlaradji];
    mainProgram = "taskchampion-sync-server";
  };
}
