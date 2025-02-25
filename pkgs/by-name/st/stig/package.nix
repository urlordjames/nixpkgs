{
  lib,
  fetchFromGitHub,
  python310Packages,
  testers,
  stig,
}:

python310Packages.buildPythonApplication rec {
  pname = "stig";
  # This project has a different concept for pre release / alpha,
  # Read the project's README for details: https://github.com/rndusr/stig#stig
  version = "0.12.10a0";

  src = fetchFromGitHub {
    owner = "rndusr";
    repo = "stig";
    rev = "v${version}";
    sha256 = "sha256-lSFI4/DxWl17KFgLXZ7c5nW/e5IUGN7s8Gm6wTM5ZWg=";
  };

  propagatedBuildInputs = with python310Packages; [
    urwid
    urwidtrees
    aiohttp
    async-timeout
    pyxdg
    blinker
    natsort
    setproctitle
  ];

  nativeCheckInputs = with python310Packages; [
    asynctest
    pytestCheckHook
  ];

  dontUseSetuptoolsCheck = true;

  preCheck = ''
    export LC_ALL=C
  '';

  disabledTestPaths = [
    # Almost all tests fail in this file, it is reported upstream in:
    # https://github.com/rndusr/stig/issues/214 , and upstream fails to
    # reproduce the issue unfortunately.
    "tests/client_test/aiotransmission_test/api_settings_test.py"
  ];
  disabledTests = [
    # Another failure with similar circumstances to the above
    "test_candidates_are_sorted_case_insensitively"
  ];

  passthru.tests = testers.testVersion {
    package = stig;
    command = "stig -v";
    version = "stig version ${version}";
  };

  # https://github.com/rndusr/stig/issues/214#issuecomment-1995651219
  dontUsePytestCheck = true;

  meta = with lib; {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = "https://github.com/rndusr/stig";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
