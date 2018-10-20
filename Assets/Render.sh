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
    (( _level++ ))
    printf "\e[%s;%sH%${fieldOptions[level,width]}s" ${fieldOptions[level,y]} ${fieldOptions[level,x]} $_level
}

renderPiece()
{
    return
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
    $_inTTY && screen="$mainCLI" || screen="$mainGUI"
    printf '%s' "$screen"

    navigateMenu 'mainOptions'
    case $? in
        0)  _state=1;; # New game
        1)  _state=2;; # Scores
        2)  _state=3;; # Settings
        3)  exit 0;
    esac
}

renderField()
{
    $_inTTY && screen="$fieldCLI" || screen="$fieldGUI"
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
    local -n piece="$1"
    local                   \
        bit=0               \
        code                \
        length              \
        reset=${2:-true}    \
        yAx=0

    $reset && renderNextPiece 'R' false
    printf "${colours[$_inTTY,$1]}"

    for (( ; $yAx < 4; bit += ${piece[0]}, yAx++ )); do

        code="${piece[1]:$bit:${piece[0]}}"
        [ -z "$code" ] && continue

        code="${code//0/\\u0020\\u0020}"
        code="${code//1/\\u2588\\u2588}"

        printf '\e[%s;%sH%b' $(( ${nextPiece[$1,y]} + $yAx )) ${nextPiece[$1,x]} "$code"
    done

    $reset && printf "${colours[reset]}"
}
