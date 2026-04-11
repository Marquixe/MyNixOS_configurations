{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    python313
    gcc
    pkg-config
    openssl
    zlib
  ];

  shellHook = ''
    export DEV_SHELL_NAME="python"
    export STARSHIP_CONFIG="$HOME/.config/starship-python.toml"
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
    ]}
    echo "Python shell ready"
    python --version
  '';
}
