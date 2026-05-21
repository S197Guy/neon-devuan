{ pkgs, inputs, ... }:

{
  imports = [
    ./mangowm.nix
    ./openrc.nix
    ./kitty.nix
    ./theme.nix
    ./greeter.nix
  ];

  home.username = "neonscar";
  home.homeDirectory = "/home/neonscar";
  home.stateVersion = "23.11";

  targets.genericLinux.enable = true;
  systemd.user.enable = false;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Core Tools
    git
    vim
    thunar
    fastfetch
    
    # Mango/DMS Dependencies
    matugen
    swaybg
    brightnessctl
    wl-clipboard
    grim
    slurp
    
    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    
    # GTK Support
    gnome-themes-extra
    adwaita-icon-theme
    glib # for gsettings
    gnome-keyring
    
    # Audio Control
    wireplumber
    pulseaudio
    pavucontrol
    
    # Networking & Bluetooth Control
    networkmanager
    networkmanagerapplet
    blueman
    
    # nixGL for hardware acceleration
  ];

  # Enable Dank Material Shell (AvengeMedia version)
  programs.dank-material-shell.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "command-not-found" ];
    };

    initExtra = ''
      # Terminal Greeter
      fastfetch
    '';

    shellAliases = {
      update = "nix run .#home-manager -- switch --flake .#neonscar -b backup";
      gc = "nix-collect-garbage -d";
    };
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--gtk-version=3"
      "--enable-features=WebRTCPipeWireCapturer"
      "--force-dark-mode"
      "--enable-dark-mode"
    ];
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      continuation_prompt = "[▸▹ ](dimmed white)";
      format = "($nix_shell$container$fill$git_metrics\n)$cmd_duration$hostname$localip$shlvl$shell$env_var$jobs$sudo$username$character";
      right_format = "$singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_status$hg_branch$pijul_channel$docker_context$package$c$cpp$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$fortran$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$maven$nim$nodejs$bun$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$vlang$vagrant$xmake$zig$buf$conda$pixi$meson$spack$memory_usage$aws$gcloud$openstack$azure$crystal$custom$status$os$battery$time";

      fill = { symbol = " "; };
      character = {
        format = "$symbol ";
        success_symbol = "[◎](bold italic bright-yellow)";
        error_symbol = "[○](italic purple)";
        vimcmd_symbol = "[■](italic dimmed green)";
        vimcmd_replace_one_symbol = "◌";
        vimcmd_replace_symbol = "□";
        vimcmd_visual_symbol = "▼";
      };
      env_var.VIMSHELL = {
        format = "[$env_value]($style)";
        style = "green italic";
      };
      sudo = {
        format = "[$symbol]($style)";
        style = "bold italic bright-purple";
        symbol = "⋈┈";
        disabled = false;
      };
      username = {
        style_user = "bright-yellow bold italic";
        style_root = "purple bold italic";
        format = "[⭘ $user]($style) ";
        disabled = false;
        show_always = false;
      };
      directory = {
        home_symbol = "⌂";
        truncation_length = 2;
        truncation_symbol = "□ ";
        read_only = " ◈";
        use_os_path_sep = true;
        style = "italic blue";
        format = "[$path]($style)[$read_only]($read_only_style)";
        repo_root_style = "bold blue";
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold bright-blue)";
      };
      cmd_duration = { format = "[◄ $duration ](italic white)"; };
      jobs = {
        format = "[$symbol$number]($style) ";
        style = "white";
        symbol = "[▶](blue italic)";
      };
      localip = {
        ssh_only = true;
        format = " ◯[$localipv4](bold magenta)";
        disabled = false;
      };
      time = {
        disabled = false;
        format = "[ $time]($style)";
        time_format = "%R";
        utc_time_offset = "local";
        style = "italic dimmed white";
      };
      battery = {
        format = "[ $percentage $symbol]($style)";
        full_symbol = "█";
        charging_symbol = "[↑](italic bold green)";
        discharging_symbol = "↓";
        unknown_symbol = "░";
        empty_symbol = "▃";
        display = [
          { threshold = 20; style = "italic bold red"; }
          { threshold = 60; style = "italic dimmed bright-purple"; }
          { threshold = 70; style = "italic dimmed yellow"; }
        ];
      };
      git_branch = {
        format = " [$branch(:$remote_branch)]($style)";
        symbol = "[△](bold italic bright-blue)";
        style = "italic bright-blue";
        truncation_symbol = "⋯";
        truncation_length = 11;
        ignore_branches = [ "main" "master" ];
        only_attached = true;
      };
      git_metrics = {
        format = "([▴$added]($added_style))([▿$deleted]($deleted_style))";
        added_style = "italic dimmed green";
        deleted_style = "italic dimmed red";
        ignore_submodules = true;
        disabled = false;
      };
      git_status = {
        style = "bold italic bright-blue";
        format = "([⎪$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed⎥]($style))";
        conflicted = "[◪◦](italic bright-magenta)";
        ahead = "[▴│[${count}](bold white)│](italic green)";
        behind = "[▿│[${count}](bold white)│](italic red)";
        diverged = "[◇ ▴┤[${ahead_count}](regular white)│▿┤[${behind_count}](regular white)│](italic bright-magenta)";
        untracked = "[◌◦](italic bright-yellow)";
        stashed = "[◃◈](italic white)";
        modified = "[●◦](italic yellow)";
        staged = "[▪┤[$count](bold white)│](italic bright-cyan)";
        renamed = "[◎◦](italic bright-blue)";
        deleted = "[✕](italic red)";
      };
      nix_shell = {
        style = "bold italic dimmed blue";
        symbol = "✶";
        format = "[$symbol nix⎪$state⎪]($style) [$name](italic dimmed white)";
        impure_msg = "[⌽](bold dimmed red)";
        pure_msg = "[⌾](bold dimmed green)";
        unknown_msg = "[◌](bold dimmed yellow)";
      };
    };
  };

  programs.home-manager.enable = true;
}
