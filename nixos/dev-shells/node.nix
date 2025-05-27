{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "node-dev";
  buildInputs = with pkgs; [
    nodejs_20
    nodePackages.npm
    nodePackages.yarn
    nodePackages.typescript
    nodePackages.eslint
    nodePackages.prettier
  ];
  
  shellHook = ''
    echo "⚡ Node.js development environment activated"
    export DEV_SHELL_NAME="node"
  '';
}
