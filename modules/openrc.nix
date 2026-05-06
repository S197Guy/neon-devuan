{ pkgs, ... }:

{
  # Minimal OpenRC awareness for PoC
  # No complex activation scripts to avoid lib.dag errors
  
  home.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };
}
