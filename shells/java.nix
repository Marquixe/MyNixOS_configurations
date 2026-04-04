{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    jdk21
    gradle
  ];

  shellHook = ''
    export DEV_SHELL_NAME="java"
    export STARSHIP_CONFIG="$HOME/.config/starship-java.toml"
    echo "Java shell ready"
    java -version
  '';
}
