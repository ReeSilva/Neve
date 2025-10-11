# Example configuration for enabling terragrunt-ls in your Nixvim setup
#
# This file demonstrates how to enable and configure the terragrunt-ls
# language server for Terragrunt HCL files.
#
# To use this in your configuration, you can either:
# 1. Copy the relevant sections to your main config
# 2. Import this file in your config/default.nix

{
  # Enable the LSP setup module
  lsp-setup.enable = true;

  # Enable terragrunt-ls with basic configuration
  terragrunt-ls = {
    enable = true;
    autoAttach = true;
  };

  # Example with logging enabled for debugging
  # terragrunt-ls = {
  #   enable = true;
  #   logPath = "/tmp/terragrunt-ls.log";
  #   autoAttach = true;
  # };
}
