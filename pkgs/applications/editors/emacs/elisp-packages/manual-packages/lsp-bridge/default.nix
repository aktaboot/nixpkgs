{
  lib,
  python3,
  melpaBuild,
  fetchFromGitHub,
  substituteAll,
  acm,
  markdown-mode,
  basedpyright,
  git,
  go,
  gopls,
  tempel,
  unstableGitUpdater,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      epc
      orjson
      paramiko
      rapidfuzz
      setuptools
      sexpdata
      six
    ]
  );
in
melpaBuild {
  pname = "lsp-bridge";
  version = "0-unstable-2024-09-05";

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    rev = "bd0cea9639bb902d22ec05189681eef1f1df7e17";
    hash = "sha256-QBtYSZAmdRhZqaR0/y0A1Q8fx62+owfdRiIVZOgWxkQ=";
  };

  patches = [
    # Hardcode the python dependencies needed for lsp-bridge, so users
    # don't have to modify their global environment
    (substituteAll {
      src = ./hardcode-dependencies.patch;
      python = python.interpreter;
    })
  ];

  packageRequires = [
    acm
    markdown-mode
  ];

  checkInputs = [
    # Emacs packages
    tempel

    # Executables
    basedpyright
    git
    go
    gopls
    python
  ];

  files = ''
    ("*.el"
     "lsp_bridge.py"
     "core"
     "langserver"
     "multiserver"
     "resources")
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    mkfifo test.log
    cat < test.log &
    HOME=$(mktemp -d) python -m test.test

    runHook postCheck
  '';

  __darwinAllowLocalNetworking = true;

  ignoreCompilationError = false;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Blazingly fast LSP client for Emacs";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fxttr
      kira-bruneau
    ];
  };
}
