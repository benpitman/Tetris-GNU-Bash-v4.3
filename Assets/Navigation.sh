navigateMenu()
{
    local -n menuOptions="$1"
    local                   \
        key1                \
        key2                \
        key3                \
        optionText          \
        selected=${2:-0}    \
        m

    while true; do
        for (( m = 0; $m < (${menuOptions[MAX]} + 1); m++ )); do
            (( $m == $selected )) && optionText='\e[7m' || optionText='\e[27m'
            optionText+="${menuOptions[$m]}\e[27m"
            navigateTo ${menuOptions[$m,Y]} ${menuOptions[$m,X]}
            renderText "$optionText"
        done

        IFS= read -srn 1 key1
        IFS= read -srn 1 -t 0.001 key2
        IFS= read -srn 1 -t 0.001 key3

        test -z "$key1" && break

        case $key3 in
            A)  (( $selected == 0 ? selected = ${menuOptions[MAX]} : selected-- ));; # Up
            B)  (( $selected == ${menuOptions[MAX]} ? selected = 0 : selected++ ));; # Down
        esac
    done

    return $selected
}

clearSubMenu()
{
    local -n subClear="$1"
    local s

    for (( s = 0; $s < ${subClear[MAX]}; s++ )); do
        navigateTo $(( ${subClear[Y]} + $s )) ${subClear[X]}
        renderText "${subClear[$s]}"
    done
}

renderPartial()
{
    local -n partialOptions="$1"
    local           \
        c           \
        half        \
        optionText  \
        p

    for (( c = 0; $c < ${partialOptions[CLEAR,MAX]}; c++ )); do
        navigateTo $(( ${partialOptions[CLEAR,Y]} + $c )) ${partialOptions[CLEAR,X]}
        renderText "${partialOptions[CLEAR]}"
    done

    for (( p = 0; $p < ${partialOptions[CLEAR,MAX]}; p++ )); do
        optionText="${!partialOptions[$p]}"
        half=$(( (${partialOptions[WIDTH]} - ${#optionText}) / 2 ))
        navigateTo ${partialOptions[$p,Y]} $(( ${partialOptions[$p,X]} + $half + 1 ))
        renderText "$optionText"
    done
}

renderMain()
{
    renderText "${MAIN_SCREEN[@]}"

    navigateMenu 'MAIN_OPTIONS' ${_selected[main]}
    _selected['main']=$?
    case ${_selected[main]} in
        0)  setState 'FIELD';;      # New game
        1)  setState 'SCORES';;     # Scores
        2)  setState 'SETTINGS';;   # Settings
        3)  exit 0;;
    esac
}

renderField()
{
    renderText "${FIELD_SCREEN[@]}"
}

renderScores()
{
    setState 'MAIN'
}

renderSettings()
{
    renderText "${SETTINGS_SCREEN[@]}"

    renderPartial 'SETTINGS_SUB_MENU'
    navigateMenu 'SETTINGS_OPTIONS' ${_selected[settings]}
    _selected['settings']=$?

    case ${_selected[settings]} in
        0|1)    clearSubMenu 'SETTINGS_CLEAR_SUB_MENU';;&
        0)      navigateMenu 'SETTINGS_COLOUR_SUB_OPTIONS'
                _colourMode=${COLOUR_MODES[$?]}
                setColours;;
        1)      navigateMenu 'SETTINGS_GAME_SUB_OPTIONS';;
        2)      setState 'MAIN'
                _selected['settings']=0
                return;; # Return to main menu
    esac
}

renderEnd()
{
    clearBuffer
    setState 'MAIN'
}

renderScreen()
{
    local screen=''

    clearScreen

    case $_state in
        0)  renderMain;;
        1)  renderField;;
        2)  renderScores;;
        3)  renderSettings;;
        4)  renderEnd;;
    esac
}

clearScreen()
{
    printf '\e[2J\e[1;1H'
}

clearBuffer()
{
    read -n10000 -t0.0001 # Clear input buffer
}
