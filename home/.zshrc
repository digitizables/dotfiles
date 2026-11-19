# Interactive shells only. scp and other non-interactive callers must stay quiet.
[[ $- == *i* ]] || return

# Same prompt as /etc/bash/bashrc.d/10-gentoo-color.bash.
# Bold green user@host, bold blue full path and $, trailing space uncolored.
# Root is bold red hostname. %~ is bash \w. %(!.#.$) is bash \$.
__gentoo_color=0
if [[ -z ${NO_COLOR-} ]]; then
	if [[ ${COLORTERM-} == truecolor || ${COLORTERM-} == 24bit ]]; then
		__gentoo_color=1
	else
		case ${TERM-} in
			*color*|*direct*|*ghostty|[Ekx]term*|alacritty|aterm|contour|dtterm|foot*|jfbterm|linux|mlterm|rxvt*|screen*|tmux*|wsvt25*)
				__gentoo_color=1
				;;
			*)
				__gentoo_color=$(tput colors 2>/dev/null || echo 0)
				;;
		esac
	fi
fi

if (( __gentoo_color <= 0 )); then
	if (( EUID == 0 )); then
		PS1='%m %~ %(!.#.$) '
	else
		PS1='%n@%m %~ %(!.#.$) '
	fi
elif (( EUID == 0 )); then
	PS1=$'%{\e[01;31m%}%m%{\e[01;34m%} %~ %(!.#.$)%{\e[00m%} '
else
	PS1=$'%{\e[01;32m%}%n@%m%{\e[01;34m%} %~ %(!.#.$)%{\e[00m%} '
fi
unset __gentoo_color

# Same command colors as /etc/bash/bashrc.d/10-gentoo-color.bash.
# ls then shows directories in blue, executables in green, and so on.
if [[ -z ${NO_COLOR-} ]]; then
	for _name in diff dir grep ls vdir; do
		if [[ $(whence -w $_name 2>/dev/null) == "${_name}: command" ]]; then
			alias $_name="$_name --color=auto"
		fi
	done
	unset _name
	if (( $+commands[dircolors] )); then
		if [[ -f ${HOME}/.dir_colors ]]; then
			eval "$(COLORTERM=1 dircolors -b -- ${HOME}/.dir_colors)"
		elif [[ -f /etc/DIR_COLORS ]]; then
			eval "$(COLORTERM=1 dircolors -b /etc/DIR_COLORS)"
		else
			eval "$(COLORTERM=1 dircolors -b)"
		fi
	fi
fi

# Window title text from /etc/bash/bashrc.d/10-gentoo-title.bash.
# Basename unless PROMPT_DIRTRIM is set, then the full path.
genfun_set_win_title() {
	if [[ -n ${PROMPT_DIRTRIM-} ]]; then
		print -Pn '\e]0;%n@%m %~\a'
	else
		print -Pn '\e]0;%n@%m %1~\a'
	fi
}

case ${TERM-} in
	*ghostty*|alacritty*|contour|foot*|tmux*|rxvt-unicode*|st-256color|xterm*|screen*)
		autoload -Uz add-zsh-hook
		add-zsh-hook precmd genfun_set_win_title
		;;
esac

# User programs, then the grok CLI.
export PATH="${HOME}/.local/bin:${HOME}/.grok/bin:${PATH}"
if [[ -d ${HOME}/.grok/completions/zsh ]]; then
	fpath=("${HOME}/.grok/completions/zsh" ${fpath})
fi

[[ -d ${HOME}/.cache/zsh ]] || mkdir -p "${HOME}/.cache/zsh"
autoload -Uz compinit
# -u avoids the one-time "insecure directories" prompt.
compinit -u -d "${HOME}/.cache/zsh/compdump"

# Must stay last so the line editor is highlighted.
if [[ -r /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh ]]; then
	source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
fi
