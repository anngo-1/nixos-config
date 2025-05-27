{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "python-dev";
  buildInputs = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.venv
    python3Packages.ipython
    python3Packages.jupyter
    python3Packages.requests
    python3Packages.numpy
    python3Packages.pandas
  ];
  
  shellHook = ''
    echo "🐍 Python development environment activated"
    export DEV_SHELL_NAME="python"
  '';
}

