{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "rust-dev";
  buildInputs = with pkgs; [
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
    pkg-config
    openssl
  ];
  
  shellHook = ''
    echo "🦀 Rust development environment activated"
    export DEV_SHELL_NAME="rust"
  '';
}
