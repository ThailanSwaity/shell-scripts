export EDITOR="vim"
export CDHIST="$HOME/.cd_history"
export TWITCHHIST="$HOME/.twitch_history"

function cd() {
	builtin cd "$1" && echo "$PWD" >> $CDHIST
}

function config() {
	$TEXTEDITOR "$HOME/bin/scripts/shell-scripts/thai.zsh"
}

function vif() {
	$TEXTEDITOR $(fzf --walker-root=$HOME)
}

function rec() {
	cd "$(tac $CDHIST | awk '!seen[$0]++' | fzy)"
}

function gg() {
	local RES=(curl -s http://www.gamerpower.com/api/giveaways)
	local SELECTION=$($RES | jq '.[] | .title' | fzy)
	if [ -n "$SELECTION" ]; then
		local LINK=$($RES | jq ".[] | select(.title==$SELECTION) | .open_giveaway")
		xdg-open ${LINK//\"/} < /dev/null &>/dev/null & disown
	fi
}

function tunein() {
	if [ -n "$1" ]; then
		echo "$1" >> $TWITCHHIST;
		xdg-open "https://www.twitch.tv/$1" < /dev/null &>/dev/null & disown
	else
		local SELECTION=$(tac $TWITCHHIST | awk '!seen[$0]++' | fzy)
		if [ -n "$SELECTION" ]; then xdg-open "https://www.twitch.tv/$SELECTION" < /dev/null &>/dev/null & disown; fi
	fi
}

function link() {
	if [ -n "$1" ]; then
		echo "$1" >> $TWITCHHIST;
		if [ -n "$(curl -s https://www.twitch.tv/$1 | grep isLiveBroadcast)" ]; then
			tmux new -s "$1 stream" -d -- "streamlink https://www.twitch.tv/$1 best";
		else
			echo "$1 is not live."
		fi
	fi
}

function linkf() {
	SELECTION="$(tac $TWITCHHIST | awk '!seen[$0]++' | fzy)"
	if [ -n "$SELECTION" ]; then
		link "$SELECTION"
	fi
}

function islive() {
	echo "$1" >> $TWITCHHIST;
	if [ -n "$(curl -s https://www.twitch.tv/$1 | grep isLiveBroadcast)" ]; then
		echo "$1 is live!"
	else
		echo "$1 is not live."
	fi
}

function twitchdesc() {
	curl "https://www.twitch.tv/$1" | sed 's/<[^>]*>//g; s/function.*//; s/{/{\n/g; s/\,/\,\n/g; s/}/\n}/g'
}

function whoislive() {
	for i in $(tac $TWITCHHIST | awk '!seen[$0]++'); do islive "$i"; done
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
		tmux new -A -s "$SESSIONNAME" -d -- "$TEXTEDITOR $FILENAME";
		tmux switch-client -t "$SESSIONNAME"
	else
		tmux new -A -s "$SESSIONNAME" -- "$TEXTEDITOR $FILENAME"
	fi
}

function brightness() {
	local BRIGHTNESS=$(brightnessctl i | awk -F'[()]' '{print $2}')
}

function tmrec() {
	local SESSIONNAME=$(tmux ls | awk -F':' '{ print $1 }' | fzy)
	
	if [ -n "$TMUX" ]; then
		tmux switch-client -t "$SESSIONNAME"
	else
		tmux attach -t "$SESSIONNAME"
	fi
}

function playlist() {
	tmux new -s "vlc" -d -- "vlc --intf rc --rc-host 127.0.0.1:44500";
}

function quit_playlist() {
	echo "quit" | nc -N 127.0.0.1 44500
}

function add_songf() {
	echo "add  $(fzf --walker-root=$HOME/Music --walker=dir,file,follow,hidden)" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function q_songf() {
	echo "enqueue  $(fzf --walker-root=$HOME/Music --walker=dir,file,follow,hidden)" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function add_song() {
	echo "add $1" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function q_song() {
	echo "enqueue $1" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function next() {
	echo "next" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function prev() {
	echo "prev" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function play() {
	echo "play" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function pause() {
	echo "pause" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function stop() {
	echo "stop" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function volume() {
	echo "volume $1" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function shuffle() {
	echo "random" | nc -N 127.0.0.1 44500 >/dev/null 2>&1
}

function status() {
	echo "status" | nc -N 127.0.0.1 44500
}
