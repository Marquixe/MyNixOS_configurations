{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    python312
    gcc
    pkg-config
    openssl
  ];

  shellHook = ''
    export DEV_SHELL_NAME="python"
    export STARSHIP_CONFIG="$HOME/.config/starship-python.toml"
    echo "Python shell ready"
    python --version
  '';
}
