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
	source "$HOME/bin/scripts/thai.zsh"
}
