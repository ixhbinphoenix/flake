{pkgs, ...}:
{
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.catppuccin;
	extraConfig = ''
	set -g @catppuccin_powerline_icons_theme_enabled on
	set -g @catppuccin_l_left_separator "<U+E0B0>"
	set -g @catppuccin_l_right_separator "<U+E0B0>"
	set -g @catppuccin_r_left_separator "<U+E0B2>"
	set -g @catppuccin_r_right_separator "<U+E0B2>"
	'';
      }
      tmuxPlugins.yank
    ];
    extraConfig = ''
    set-option -sa terminal-overrides ",xterm*:Tc"

    # Set prefix
    unbind C-b
    set -g prefix C-Space
    bind C-Space send-prefix

    # Shift Alt to switch windows
    bind -n M-J previous-window
    bind -n M-K next-window

    # Start windows and panes at 1
    set -g base-index 1
    set -g pane-base-index 1
    set-window-option -g pane-base-index 1
    set-option -g renumber-windows on

    set-window-option -g mode-keys vi

    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

    # Open pane in CWD
    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"

    # Ctrl=L rebind
    bind -n C-v send-keys -R C-l
    '';
  };
}
