# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

# export GDK_DPI_SCALE=1.33
export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export SWAY_CURSOR_SIZE=32
export XCURSOR_SIZE=32
export _JAVA_AWT_WM_NONREPARENTING=1

export PATH
