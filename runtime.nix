{ pkgs, ... }:
let
  # TODO: make lazy
  # codelldb executable is not exported by default
  codelldb = (pkgs.writeShellScriptBin "codelldb" ''
    ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb "$@"
  '');

  # cmake-lint is used as cmakelint
  cmakelint = (pkgs.writeShellScriptBin "cmakelint" ''
    nix shell nixpkgs#cmake-format --command cmake-lint "$@"
  '');

  make-lazy = pkg: bin: pkgs.writeShellScriptBin "${bin}" ''
    nix shell nixpkgs#${pkg} --command ${bin} "$@"
  '';
in
# Link together all runtime dependencies into one derivation
pkgs.symlinkJoin {
  name = "lazyvim-nix-runtime";
  paths = with pkgs; [
    # LazyVim dependencies
    lazygit
    ripgrep
    fd

    # LSP's
    (make-lazy "clang-tools_16" "clangd")
    (make-lazy "nil" "nil")
    (make-lazy "taplo" "taplo")
    (make-lazy "rust-analyzer" "rust-analyzer")
    (make-lazy "marksman" "marksman")
    (make-lazy "neocmakelsp" "neocmake-lsp")
    (make-lazy "yaml-language-server" "yaml-language-server")

    # Debuggers
    codelldb

    # Formatters
    (make-lazy "stylua" "stylua")
    (make-lazy "nixpkgs-fmt" "nixpkgs-fmt")
    (make-lazy "jq" "jq")

    # Linters
    (make-lazy "markdownlint-cli" "markdownlint-cli")
    (make-lazy "cmake-format" "cmake-format")
    cmakelint

    # Bundle also cmake
    (make-lazy "cmake" "cmake")
  ];
}
