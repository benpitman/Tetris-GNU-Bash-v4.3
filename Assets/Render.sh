pause()
{
    local unpause
    # Basic pause screen
    printf "\e[%s;%sH%s" ${fieldOptions[pause,y]} ${fieldOptions[pause,x]} "${fieldOptions[pause,text]}"
    while read -rsn1 unpause; do
        [[ "$unpause" == $'\e' ]] && break
    done
    printf "\e[%s;%sH%${#fieldOptions[pause,text]}s" ${fieldOptions[pause,y]} ${fieldOptions[pause,x]}
}

levelUp()
{
    (( _level++ ))
    printf "\e[%s;%sH%${fieldOptions[level,width]}s" ${fieldOptions[level,y]} ${fieldOptions[level,x]} $_level
}

lockPiece()
{
    local -n piece="$1"
    local                   \
        coord               \
        x=$3                \
        xAx                 \
        y=$2                \
        yAx

    for coord in ${piece[$_rotation]}; do
        IFS=, read -r xAx yAx <<< "$coord"
        _lock[$(( $y + $yAx )),$(( $x + ($xAx * 2) ))]=1
    done
}

canRender()
{
    local -n piece="$1"
    local                   \
        coord               \
        x=$3                \
        xAx                 \
        y=$2                \
        yAx

    for coord in ${piece[$_rotation]}; do
        IFS=, read -r xAx yAx <<< "$coord"
        (( xAx = $x + ($xAx * 2) ))
        (( yAx = $y + $yAx ))

        # Needs to check tetromino collision first for rotation
        if (( ${_lock[$yAx,$xAx]} )); then
            collides=4
            return 1
        elif (( $xAx > 20 )); then
            collides=1
            return 1
        elif (( $xAx < 2 )); then
            collides=3
            return 1
        elif (( $yAx > 23 )); then
            collides=2
            return 1
        fi
    done

    collides=0
    return 0
}

renderPiece()
{
    local -n piece="$1"
    local                   \
        coord               \
        pixel               \
        reset=${4:-false}   \
        x=$3                \
        xAx                 \
        y=$2                \
        yAx

    for coord in ${piece[$_rotation]}; do
        IFS=, read -r xAx yAx <<< "$coord"
        if $reset; then
            pixel="${blank}${blank}"
        else
            pixel="${colours[$1]}${block}${block}${colours[R]}"
        fi
        printf '\e[%s;%sH%b' $(( $y + $yAx )) $(( $x + ($xAx * 2) )) "$pixel"
    done
}

removePiece()
{
    renderPiece "$1" $2 $3 true
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
    local y

    for y in {0..3}; do
        printf '\e[%s;%sH%b' $(( ${nextPiece[R,y]} + $y )) ${nextPiece[R,x]} "${R[0]//0/\\u0020\\u0020}"
    done

    renderPiece "$_nextPiece" ${nextPiece[$_nextPiece,y]} ${nextPiece[$_nextPiece,x]}
}
