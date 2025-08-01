{
  config,
  pkgs,
  lib,
  inputs,
  nixGL,
  ...
}: {
  nixGL = {
    packages = nixGL.packages; # you must set this or everything will be a noop
    defaultWrapper = "mesa"; # choose from nixGL options depending on GPU
  };

  home = {
    username = "irage";
    homeDirectory = "/home/irage";
    stateVersion = "23.11";
    packages = with pkgs; [
      # Core terminals
      (config.lib.nixGL.wrap alacritty)
      kitty

      # Browsers
      firefox

      # Essential Wayland tools
      waybar
      rofi-wayland
      dunst

      # System utilities
      grim
      slurp
      wl-clipboard
      cliphist

      # Font
      nerd-fonts.jetbrains-mono

      # Window management helpers
      wmctrl
      xdotool
    ];

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      NIXOS_OZONE_WL = "1";
      TERM = "xterm-color";
    };
  };

  programs.home-manager.enable = true;

  # Enable essential services
  services = {
    dunst.enable = true;
  };

  # Essential terminal configuration
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      background_opacity = "0.9";
      # Catppuccin Mocha theme
      foreground = "#cdd6f4";
      background = "#1e1e2e";
      selection_foreground = "#1e1e2e";
      selection_background = "#f5e0dc";
      # Additional colors
      color0 = "#45475a";
      color1 = "#f38ba8";
      color2 = "#a6e3a1";
      color3 = "#f9e2af";
      color4 = "#89b4fa";
      color5 = "#f5c2e7";
      color6 = "#94e2d5";
      color7 = "#bac2de";
      color8 = "#585b70";
      color9 = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#f5c2e7";
      color14 = "#94e2d5";
      color15 = "#a6adc8";
    };
  };

  # Waybar configuration for Hyprland
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "tray" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;  # Show only current monitor's workspaces
          warp-on-scroll = false;
          format = "{icon}";
          format-icons = {
            "1" = "1:Term";
            "2" = "2:Web";
            "3" = "3:Dev";
            "4" = "4";
            "5" = "5";
            "6" = "6:Chrome";
            "7" = "7";
            "8" = "8";
            "9" = "9:Chat";
            "10" = "10:Media";
            "11" = "11";
            "12" = "12";
            "13" = "13";
            "14" = "14";
            "15" = "15";
            "16" = "16";
            "17" = "17";
            "18" = "18";
            "19" = "19";
            "20" = "20";
            urgent = "";
            focused = "";
            default = "";
          };
          persistent-workspaces = {
            "DP-1" = [ 1 2 3 4 5 ];
            "DP-2" = [ 6 7 8 9 10 ];
          };
        };

        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
          max-length = 50;
        };

        tray = {
          spacing = 10;
        };

        clock = {
          timezone = "America/New_York";
          format = "{:%H:%M %Y-%m-%d}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "CPU {usage}%";
          tooltip = false;
          interval = 1;
        };

        memory = {
          format = "RAM {}%";
          interval = 1;
        };

        network = {
          format-wifi = "WiFi {signalStrength}%";
          format-ethernet = "Eth {ipaddr}";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "Vol {volume}%";
          format-bluetooth = "Vol {volume}% ";
          format-bluetooth-muted = "Muted ";
          format-muted = "Muted";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.95);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #cdd6f4;
        border-bottom: 2px solid transparent;
      }

      #workspaces button:hover {
        background: rgba(108, 112, 134, 0.2);
      }

      #workspaces button.focused {
        background-color: #89b4fa;
        color: #1e1e2e;
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
        color: #1e1e2e;
      }

      #window,
      #clock,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        color: #cdd6f4;
      }

      #cpu {
        background-color: rgba(166, 227, 161, 0.1);
      }

      #memory {
        background-color: rgba(249, 226, 175, 0.1);
      }

      #network {
        background-color: rgba(137, 180, 250, 0.1);
      }

      #pulseaudio {
        background-color: rgba(245, 194, 231, 0.1);
      }

      #clock {
        background-color: rgba(203, 166, 247, 0.1);
        font-weight: bold;
      }
    '';
  };

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      # Variables
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";

      # Monitor configuration - adjust names/resolutions for your setup
      monitor = [
        # Primary monitor (left) - adjust name and resolution as needed
        "DP-1,1920x1080@60,0x0,1"
        # Secondary monitor (right) - adjust name and resolution as needed  
        "DP-2,1920x1080@60,1920x0,1"
        # Fallback for any other monitors
        ",preferred,auto,1"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgba(89b4faff)";
        "col.inactive_border" = "rgba(6c7086ff)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "master";
      };

      # Master layout configuration
      master = {
        new_status = "master";
        new_on_top = true;
        orientation = "left";
        smart_resizing = true;
      };

      # Input configuration
      input = {
        kb_layout = "us";
        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0;
      };

      # Minimal decorations for performance
      decoration = {
        rounding = 4;
        active_opacity = 1.0;
        inactive_opacity = 0.95;

        shadow = {
          enabled = false;
        };

        blur = {
          enabled = false;
        };
      };

      # Fast animations
      animations = {
        enabled = true;
        bezier = [
          "fast, 0.1, 0.0, 0.0, 1.0"
        ];
        animation = [
          "windows, 1, 3, fast"
          "border, 1, 5, fast"
          "fade, 1, 3, fast"
          "workspaces, 1, 3, fast"
        ];
      };

      # Performance settings
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 1;
        focus_on_activate = true;
      };

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "CLUTTER_BACKEND,wayland"
        "MOZ_ENABLE_WAYLAND,1"
      ];

      bind = [
        # System controls
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod SHIFT, R, exec, hyprctl reload"

        # Applications
        "$mod, Return, exec, $terminal"
        "$mod, D, exec, $menu"
        "$mod, B, exec, firefox"
        "$mod, C, exec, google-chrome --enable-features=UseOzonePlatform --ozone-platform=wayland"

        # Application jumping (focus if exists, launch if not)
        "$mod ALT, B, exec, hyprctl dispatch focuswindow class:^firefox$ || firefox"
        "$mod ALT, C, exec, hyprctl dispatch focuswindow class:^google-chrome$ || google-chrome"
        "$mod ALT, T, exec, hyprctl dispatch focuswindow class:^kitty$ || $terminal"

        # Cycle through windows of same application
        "$mod CTRL, B, exec, hyprctl dispatch cyclenext class:^firefox$"
        "$mod CTRL, C, exec, hyprctl dispatch cyclenext class:^google-chrome$"
        "$mod CTRL, T, exec, hyprctl dispatch cyclenext class:^kitty$"

        # Window management
        "$mod, Space, togglefloating"
        "$mod, F, fullscreen, 0"
        "$mod, P, pseudo"
        "$mod, O, togglesplit"

        # Master layout controls
        "$mod, M, layoutmsg, swapwithmaster"
        "$mod, I, layoutmsg, addmaster"
        "$mod, U, layoutmsg, removemaster"

        # Focus movement (vim-style + arrows)
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Window movement
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Window resizing
        "$mod CTRL, left, resizeactive, -40 0"
        "$mod CTRL, right, resizeactive, 40 0"
        "$mod CTRL, up, resizeactive, 0 -40"
        "$mod CTRL, down, resizeactive, 0 40"
        "$mod CTRL, h, resizeactive, -40 0"
        "$mod CTRL, l, resizeactive, 40 0"
        "$mod CTRL, k, resizeactive, 0 -40"
        "$mod CTRL, j, resizeactive, 0 40"

        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, Print, exec, grim - | wl-copy"

        # Clipboard history
        "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        
        # Monitor switching
        "$mod, comma, focusmonitor, l"
        "$mod, period, focusmonitor, r"
        "$mod SHIFT, comma, movewindow, mon:l"
        "$mod SHIFT, period, movewindow, mon:r"
        
        # Workspace movement between monitors
        "$mod ALT, comma, moveworkspacetomonitor, current l"
        "$mod ALT, period, moveworkspacetomonitor, current r"
      ] ++ (
        # Workspace bindings (1-10) with monitor-aware switching
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            # Monitor-specific workspace switching (alt + num for second monitor)
            "$mod ALT, ${ws}, workspace, ${toString (x + 1 + 10)}"
            "$mod ALT SHIFT, ${ws}, movetoworkspace, ${toString (x + 1 + 10)}"
          ]
        ) 10)
      );

      bindm = [
        # Mouse bindings
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Workspace assignments for dual monitor setup
      workspace = [
        # Primary monitor (left) - workspaces 1-5
        "1, monitor:DP-1"
        "2, monitor:DP-1" 
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        # Secondary monitor (right) - workspaces 6-10
        "6, monitor:DP-2"
        "7, monitor:DP-2"
        "8, monitor:DP-2" 
        "9, monitor:DP-2"
        "10, monitor:DP-2"
        # Extended workspaces 11-20 for Alt+Num bindings
        "11, monitor:DP-1"
        "12, monitor:DP-1"
        "13, monitor:DP-1"
        "14, monitor:DP-1"
        "15, monitor:DP-1"
        "16, monitor:DP-2"
        "17, monitor:DP-2"
        "18, monitor:DP-2"
        "19, monitor:DP-2"
        "20, monitor:DP-2"
      ];

      # Window rules for productivity
      windowrulev2 = [
        # Primary monitor applications (workspaces 1-5)
        # Terminals - Workspace 1 (left monitor)
        "workspace 1,class:^(kitty)$"
        "workspace 1,class:^(Alacritty)$"

        # Browsers - Workspace 2 (left monitor)  
        "workspace 2,class:^(firefox)$"
        "workspace 6,class:^(google-chrome)$"  # Chrome on right monitor

        # Development - Workspace 3 (left monitor)
        "workspace 3,title:^.*nvim.*$"
        
        # Communication - Workspace 9 (right monitor)
        "workspace 9,class:^(discord)$"
        "workspace 9,class:^(slack)$"
        
        # Media - Workspace 10 (right monitor)
        "workspace 10,class:^(spotify)$"
        "workspace 10,class:^(vlc)$"

        # Opacity for better focus
        "opacity 0.95,class:^(kitty)$"
        "opacity 0.95,class:^(Alacritty)$"
        "opacity 0.98,class:^(firefox)$"
        "opacity 0.98,class:^(google-chrome)$"
      ];

      # Auto-start applications
      exec-once = [
        "waybar"
        "dunst"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "[workspace 1 silent] $terminal"
        "[workspace 2 silent] firefox"
      ];
    };
  };
}
