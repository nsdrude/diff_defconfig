{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git               # For git operations
    pkgs.findutils         # Provides the 'find' command
    pkgs.gnumake           # For make commands
    pkgs.bash              # Ensures a compatible bash environment
    pkgs.coreutils         # Provides basic GNU utilities like 'mv'
    pkgs.flex              # For the 'flex' command
    pkgs.bison             # For the 'bison' command
  ];

  shellHook = ''
    echo "Environment set up for running the script."
    echo "Using export ARCH=arm64 by default"
    export ARCH=arm64
  '';
}
