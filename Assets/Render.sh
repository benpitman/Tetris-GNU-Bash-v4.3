pause()
{
    #TODO pause screen needs aligning
    local unpause
    # Basic pause screen
    tput cup 18 21
    printf '\e[1m PAUSE \e[0m'
    while read -rsn1 unpause; do
        [[ "$unpause" == $'\e' ]] && break
    done
    tput cup 18 21
    printf '%7s' ''
}

levelUp()
{
    #TODO level up needs to be on the right
    (( _level++ ))
    tput cup 19 21
    printf "\e[1mLEVEL $_level\e[0m"
    sleep 2
    tput cup 19 21
    printf "         "
}

renderPiece()
{

}

navigateMenu()
{
    local -n menuOptions="$1"
    local           \
        key1        \
        key2        \
        key3        \
        selected=0  \
        m

    while true; do
        for (( m = 0; $m < (${menuOptions[max]} + 1); m++ )); do
            (( $m == $selected )) && text='\e[7m' || text='\e[0m'
            text+="${menuOptions[$m,text]}\e[0m"
            printf '\e[%s;%sH%b' ${menuOptions[$m,y]} ${menuOptions[$m,x]} "$text"
        done

        IFS= read -srn 1 key1
        IFS= read -srn 1 -t 0.001 key2
        IFS= read -srn 1 -t 0.001 key3

        [ -z "$key1" ] && break

        case $key3 in
            A)  (( $selected == 0 ? selected = ${menuOptions[max]} : selected-- ));; # Up
            B)  (( $selected == ${menuOptions[max]} ? selected = 0 : selected++ ));; # Down
        esac
    done

    return $selected
}

renderMain()
{
    $inCLI && screen="$mainCLI" || screen="$mainGUI"
    printf '%s' "$screen"

    navigateMenu 'mainOptions'
    case $? in
        0)  _state=1;; # New game
        1)  _state=2;; # Scores
        3)  _state=3;; # Settings
        4)  exit 0;
    esac
}

renderField()
{
    $inCLI && screen="$fieldCLI" || screen="$fieldGUI"
    printf '%s' "$screen"
}

renderScreen()
{
    local screen=''

    printf '\e[2J\e[1;1H'

    case $_state in
        0)  renderMain;;
        1)  renderField;;
        2)  return;;
        3)  return;;
    esac
}

renderNextPiece()
{
    local -n piece="$_nextPiece"
    local                   \
        bit=0               \
        code                \
        length              \
        reset=${2:-true}    \
        yAx=0

    $reset && renderNextPiece 'R' false


    for (( ; $yAx < 4; bit += ${piece[0]}, yAx++ )); do
        printf "${colours[$inCLI,$1]}"

        code="${piece[1]:$bit:${piece[0]}}"
        [ -z "$code" ] && continue

        code="${code//0/\\u0020\\u0020}"
        code="${code//1/\\u2588\\u2588}"

        printf '\e[%s;%sH%b' $(( ${nextPiece[$1,y]} + $yAx )) ${nextPiece[$1,x]} "$code"
    done
}
