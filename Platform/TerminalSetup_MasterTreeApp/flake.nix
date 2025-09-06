{
  description = "TerminalSetup v3 — deterministic dev shell (Apple Silicon)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        python311
        python311Packages.pip
        git
        jq
        yq-go
        ruff
        pre-commit
      ];
      shellHook = ''
        echo "[nix] dev shell ready (TerminalSetup v3)"
        python3 --version || true
        git --version || true
      '';
    };
  };
}
