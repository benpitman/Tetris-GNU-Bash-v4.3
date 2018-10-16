navigateMenu()
{
    local -n menuOptions="$1"
    local selected=0 m

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
    return $?
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

    case $1 in
        0)  renderMain;;
        1)  return;;
        2)  renderField;;
        3)  return;;
    esac

    return $?
}

renderNextPiece()
{
    local -n shape="$1"
    local                   \
        bit=0               \
        code                \
        length              \
        reset=${2:-true}    \
        yAx=0

    $reset && showNext 'R' false

    echo -e "${colours[$inCLI,$1]}"

    for (( ; $yAx < 4; bit += ${shape[0]}, yAx++ )); do
        code="${shape[1]:$bit:${shape[0]}}"
        [ -z "$code" ] && continue

        code="${code//0/\\u0020\\u0020}"
        code="${code//1/\\u2588\\u2588}"

        printf '\e[%s;%sH%b' $(( ${next[$1,y]} + $yAx )) ${next[$1,x]} "$code"
    done
}
