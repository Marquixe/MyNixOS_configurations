{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    jdk21
    gradle
  ];

  shellHook = ''
    echo "Java shell ready"
    java -version
  '';
}
