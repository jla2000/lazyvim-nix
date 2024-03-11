{ pkgs, ... }:
let
  # codelldb executable is not exported by default
  codelldb = (pkgs.writeShellScriptBin "codelldb" ''
    ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb "$@"
  '');
in
# Link together all runtime dependencies into one derivation
pkgs.symlinkJoin {
  name = "lazyvim-nix-runtime";
  paths = with pkgs; [
    # LazyVim dependencies
    lazygit
    ripgrep
    fd

    # Debuggers
    codelldb

    # Formatters
    stylua
    nixpkgs-fmt

    # Linters
    markdownlint-cli

    # Bundle also cmake
    cmake
  ];
}
