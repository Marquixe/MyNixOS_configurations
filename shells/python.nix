{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    python312
    gcc
    pkg-config
    openssl
  ];

  shellHook = ''
    echo "Python shell ready"
    python --version
  '';
}
