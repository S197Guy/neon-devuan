{ pkgs, lib, config, ... }:

{
  # Since Home Manager doesn't natively manage OpenRC services in /etc/init.d,
  # we provide a template for manual integration and ensure environment variables
  # are set correctly for an OpenRC-based system.

  home.sessionVariables = {
    # Ensure Nix binaries are preferred in the path
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };

  # Activation script to remind the user about OpenRC manual steps
  home.activation.openrcInfo = lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD echo "🌸 OpenRC Awareness: Nix environment is ready."
    $DRY_RUN_CMD echo "   Note: On Devuan, start your session with 'mangowm' from TTY."
    $DRY_RUN_CMD echo "   System services should still be managed via 'sudo rc-service'."
  '';
}
