{
  description = "Deterministic dev env for TerminalSetup v3";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
  outputs = { self, nixpkgs }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        python311 python311Packages.pip python311Packages.virtualenv
        jq yq git
        pre-commit ruff
      ];
      shellHook = "echo \"[nix] dev shell ready (TerminalSetup v3)\"; python3 --version || true";
};
  };
}
