export EDITOR="vim"
export CDHIST="$HOME/.cd_history"

function cd() {
	builtin cd "$1" && echo "$PWD" >> $CDHIST
}

function vif() {
	vim $(fzf --walker-root=$HOME)
}

function rec() {
	cd $(tac $CDHIST | awk '!seen[$0]++' | fzy)
}

function gg() {
	local RES=(curl -s http://www.gamerpower.com/api/giveaways)
	local SELECTION=$($RES | jq '.[] | .title' | fzy)
	if [ -n "$SELECTION" ]; then
		local LINK=$($RES | jq ".[] | select(.title==$SELECTION) | .open_giveaway")
		xdg-open ${LINK//\"/} < /dev/null &>/dev/null & disown
	fi
}

function reload() {
	source "$HOME/bin/scripts/shell-scripts/thai.zsh"
}

function cdf() {
	cd $(fzf --walker-root=$HOME --walker=dir,follow,hidden)
}

function open() {
	local FILENAME="$1"
	local SESSIONNAME="${FILENAME//./_}"

	if [ -n "$TMUX" ]; then
		echo "In a tmux session"
		tmux new -A -s "$SESSIONNAME" -d -- "vim $FILENAME";
		tmux switch-client -t "$SESSIONNAME"
	else
		tmux new -A -s "$SESSIONNAME" -- "vim $FILENAME"
	fi
}

function tmrec() {
	local SESSIONNAME=$(tmux ls | awk -F':' '{ print $1 }' | fzy)
	
	if [ -n "$TMUX" ]; then
		tmux switch-client -t "$SESSIONNAME"
	else
		tmux attach -t "$SESSIONNAME"
	fi
}
