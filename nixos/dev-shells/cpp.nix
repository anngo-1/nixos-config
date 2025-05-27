{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "cpp-dev";
  buildInputs = with pkgs; [
    gcc
    clang
    cmake
    ninja
    gdb
    valgrind
    pkg-config
    boost
    catch2
  ];
  
  shellHook = ''
    echo "⚙️  C++ development environment activated"
    export DEV_SHELL_NAME="cpp"
  '';
}

