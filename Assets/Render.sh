renderScreen()
{
    local $screen=''

    case $1 in
        1)  $inCLI && screen="$mainCLI" || screen="$mainGUI";;
        2)  return;;
        3)  $inCLI && screen="$fieldCLI" || screen="$fieldGUI";;
        4)  return;;
    esac

    printf '\e[2J\e[1;1H%s' "$screen"
}

renderNextPiece()
{
    local -n shape="$1"
    local                   \
        bit                 \
        code                \
        length              \
        reset=${2:-true}    \
        yAx

    $reset && showNext 'R' false

    echo -e "${colours[$inCLI,$1]}"

    for (( yAx=0, bit=0; yAx<4; bit+=${shape[0]}, yAx++ )); do
        code="${shape[1]:$bit:${shape[0]}}"
        [ -z "$code" ] && continue
        code="${code//0/\\u0020\\u0020}"
        code="${code//1/\\u2588\\u2588}"
        printf '\e[%s;%sH%b' $(( ${next[$1,y]} + yAx )) ${next[$1,x]} "$code"
    done
}
