{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.tmux = {
    enable = true;

    plugins = with pkgs; [
      tmuxPlugins.tmux-powerline
    ];

    extraConfig = ''
      # destroy unattached sessions
      set -g destroy-unattached on

      # enable mouse
      set -g mouse on

      # slower scrolling
      bind -Tcopy-mode WheelUpPane send -N1 -X scroll-up
      bind -Tcopy-mode WheelDownPane send -N1 -X scroll-down

      # --- Create Window (Alt+c) ---
      bind -n M-c new-window

      # --- Window Navigation (Alt+0-9) ---
      run-shell -b 'for i in $(seq 0 9); do \
      	tmux bind -n M-''${i} if-shell "[[ \$(tmux list-windows | grep ^''${i}:) ]]" \
      	"select-window -t ''${i}" "new-window -t ''${i}"; \
      done'

      # --- Additional Window Navigation ---
      bind -n M-n previous-window
      bind -n M-m next-window


      # --- Kill Pane (Alt+d) ---
      bind -n M-d kill-pane

      # --- Pane Navigation (Alt+h/j/k/l) ---
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # --- Split Panes ---
      bind -n M-b split-window -h
      bind -n M-v split-window -v
    '';

  };

  home.file.".config/tmux-powerline/config.sh".text = ''
      export TMUX_POWERLINE_THEME="theme"
    	export TMUX_POWERLINE_DIR_USER_THEMES="''${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/themes"
  '';
  home.file.".config/tmux-powerline/themes/theme.sh".text = ''
    		# Default Theme

    		if patched_font_in_use; then
    			TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
    			TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
    			TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
    			TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
    		else
    			TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
    			TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
    			TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
    			TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
    		fi

    		TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=''${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'235'}
    		TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=''${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'255'}

    		TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=''${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
    		TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=''${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

    		# See man tmux.conf for additional formatting options for the status line.
    		# The `format regular` and `format inverse` functions are provided as conveniences

    		if [ -z $TMUX_POWERLINE_WINDOW_STATUS_CURRENT ]; then
    			TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
    				"#[$(format inverse)]" \
    				"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR" \
    				" #I#F " \
    				"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
    				" #W " \
    				"#[$(format regular)]" \
    				"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
    			)
    		fi

    		if [ -z $TMUX_POWERLINE_WINDOW_STATUS_STYLE ]; then
    			TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
    				"$(format regular)"
    			)
    		fi

    		if [ -z $TMUX_POWERLINE_WINDOW_STATUS_FORMAT ]; then
    			TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    				"#[$(format regular)]" \
    				"  #I#{?window_flags,#F, } " \
    				"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
    				" #W "
    			)
    		fi

    		if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
    			TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=()
    		fi

    		if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
    			TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=()
    		fi
  '';

}
