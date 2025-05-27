{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "fullstack-dev";
  buildInputs = with pkgs; [
    # Python
    python3
    python3Packages.pip
    python3Packages.fastapi
    python3Packages.uvicorn
    
    # Node.js
    nodejs_20
    nodePackages.npm
    nodePackages.typescript
    
    # Database tools
    postgresql
    redis
    
    # Other tools
    docker-compose
    curl
    jq
  ];
  
  shellHook = ''
    echo "🚀 Full-stack development environment activated"
    export DEV_SHELL_NAME="fullstack"
  '';
}

