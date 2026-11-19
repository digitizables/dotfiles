# Text login on VT1 starts GNOME when GDM is not already running.
# Kept from ~/.bash_profile so the login shell change does not drop it.
if [[ -z ${WAYLAND_DISPLAY-} && -z ${DISPLAY-} && ${XDG_VTNR-} == 1 ]]; then
	if ! pgrep -x gdm >/dev/null 2>&1 && [[ -x /usr/bin/gnome-session && -x ${HOME}/.local/bin/start-gnome ]]; then
		exec "${HOME}/.local/bin/start-gnome"
	fi
fi
