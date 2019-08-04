navigateMenu()
{
    local -- key1
    local -- key2
    local -- key3
    local -- menuIndex
    local -- optionText
    local -- selected=${2:-0}
    local -- text

    local -n -- menu="$1"
    local -n -- menuOptions="${menu[OPTIONS]}"

    while true; do
        for (( menuIndex = 0; $menuIndex < (${menu[MAX]} + 1); menuIndex++ )); do
            (( $menuIndex == $selected )) && optionText="\e[7m" || optionText="\e[27m"

            if [[ -n "${menuOptions[$menuIndex]}" ]]; then
                text=${menuOptions[$menuIndex]}
            elif [[ -n "${menuOptions[$menuIndex,FUNCTION]}" ]]; then
                ${menuOptions[$menuIndex,FUNCTION]} "text"
            fi

            optionText+="${menu[PADDING]}$text${menu[PADDING]}\e[27m"
            navigateTo ${menu[$menuIndex,Y]} ${menu[$menuIndex,X]}
            renderText "$optionText"
        done

        if [[ "${menu[$selected,NOTE]}" != "" ]]; then
            navigateTo ${NOTE[Y]} $(( ${NOTE[X]} - (${#menu[$selected,NOTE]} / 2) ))
            renderText "${menu[$selected,NOTE]}"
        fi

        IFS= read -srn 1 key1
        IFS= read -srn 1 -t 0.0001 key2
        IFS= read -srn 1 -t 0.0001 key3

        [[ "$key1" == "" ]] && break

        if [[ "${menu[$selected,NOTE]}" != "" ]]; then
            navigateTo ${NOTE[Y]} $(( ${NOTE[X]} - (${#NOTE[CLEAR]} / 2) ))
            renderText "${NOTE[CLEAR]}"
        fi

        case $key3 in
            ($UP) {
                (( $selected == 0 ? selected = ${menu[MAX]} : selected-- ))
            };;
            ($DOWN) {
                (( $selected == ${menu[MAX]} ? selected = 0 : selected++ ))
            };;
        esac
    done

    return $selected
}

clearSubMenu()
{
    local -- subIndex

    local -n -- subClear="$1"

    for (( subIndex = 0; $subIndex < ${subClear[MAX]}; subIndex++ )); do
        navigateTo $(( ${subClear[Y]} + $subIndex )) ${subClear[X]}
        renderText "${subClear[$subIndex]}"
    done
}

renderPartial()
{
    local -- clear
    local -- half
    local -- optionText
    local -- partial

    local -n -- partialOptions="$1"

    for (( clear = 0; $clear < ${partialOptions[CLEAR,MAX]}; clear++ )); do
        navigateTo $(( ${partialOptions[CLEAR,Y]} + $clear )) ${partialOptions[CLEAR,X]}
        renderText "${partialOptions[CLEAR]}"
    done

    for (( partial = 0; $partial < (${partialOptions[MAX]} + 1); partial++ )); do
        optionText="${!partialOptions[$partial]}"
        half=$(( (${partialOptions[WIDTH]} - ${#optionText}) / 2 ))
        navigateTo ${partialOptions[$partial,Y]} $(( ${partialOptions[$partial,X]} + $half + 1 ))
        renderText "$optionText"
    done
}

renderMain()
{
    renderText "${MAIN_SCREEN[@]}"

    navigateMenu 'MAIN_MENU' ${_selected[main]}
    _selected['main']=$?
    case ${_selected[main]} in
        (0) {
            setState 'FIELD' # New game
        };;
        (1) {
            setState 'SCORES' # Scores
        };;
        (2) {
            setState 'SETTINGS' # Settings
        };;
        (2) {
            setState 'CONSTANTS' # Constants
        };;
        (3) {
            intrap
        };;
    esac
}

renderField()
{
    renderText "${FIELD_SCREEN[@]}"
}

renderScores()
{
    local -- editableIndex
    local -- editableRow
    local -- line
    local -- newScore=0
    local -- playername
    local -- score
    local -- scoreShown=0

    local -a -- scores
    local -a -- userNames=()
    local -a -- userScores=()

    (( $_score > 0 )) && newScore=1

    renderText "${SCORES_SCREEN[@]}"

    if $LEGACY; then
        IFS=$'\n' read -d "" -ra scores < "$HIGHSCORE_LOG"
    else
        readarray -t scores < "$HIGHSCORE_LOG"
    fi

    for (( line = 0; $line < ${#scores[@]}; line++ )); do
        userScores[$line]=${scores[$line]/*\,/}
        userNames[$line]=${scores[$line]/\,*/}

        if (( $scoreShown == 0 && $newScore && ${userScores[$line]} <= $_score )); then
            scoreShown=1
            editableIndex=$line
        fi
    done

    if (( $newScore )); then
        [[ "$editableIndex" == "" ]] && editableIndex=${#scores[@]}
        # Insert current score into the arrays
        userNames=(
            ${userNames[@]:0:$editableIndex}
            ""
            ${userNames[@]:$editableIndex}
        )
        userScores=(
            ${userScores[@]:0:$editableIndex}
            $_score
            ${userScores[@]:$editableIndex}
        )
    fi

    for (( score = 0; $score < (${SCORES[MAX]} - 1); score++ )); do
        scoreRow=$(( ${SCORES[Y]} + $score ))
        if (( $newScore && $score == $editableIndex )); then
            editableRow=$scoreRow
        else
            printScore $scoreRow ${SCORES[X]} $(( $score + 1 )) "${userNames[$score]}" ${userScores[$score]}
        fi
    done

    if (( $newScore )); then
        [[ "$editableRow" == "" ]] && (( editableRow = ${SCORES[Y]} + ${SCORES[MAX]} ))

        printScore $editableRow ${SCORES[X]} $(( $editableIndex + 1 )) "" $_score 1
        textEntry $editableRow $(( ${SCORES[X]} + 4 )) 8 "playername"

        # Add the new score to the highscores file
        if (( $editableIndex == ${#scores[@]} )); then
            printf '%s,%s\n' "$playername" "$_score" >> "$HIGHSCORE_LOG"
        else
            sed -i "$(( $editableIndex + 1 ))s/^/$playername\,$_score\n/" "$HIGHSCORE_LOG"
        fi

        _score=0
    fi

    navigateMenu 'SCORES_MENU'
    setState 'MAIN'
}

printScore()
{
    local -- bold=${6:-0}
    local -- index=$3
    local -- readableScore
    local -- name="$4"
    local -- pad
    local -- paddedScore
    local -- score=$5
    local -- spacer
    local -- y=$1
    local -- x=$2

    # Make the score human readable
    printf -v readableScore "%'d" $score

    (( pad = ${SCORES[WIDTH]} - (4 + ${#name} + ${#readableScore}) ))
    eval printf -v spacer "%.0s." {1..$pad}
    printf -v paddedScore "%-4s%s%s%s" "$index" "$name" "$spacer" "$readableScore"
    (( $bold )) && paddedScore="\e[1m$paddedScore"

    navigateTo $y $x
    renderText "$paddedScore"
}

textEntry()
{
    local -- inputString
    local -- key
    local -- maxLength=$3
    local -- nameRef=$4
    local -- y=$1
    local -- x=$2

    navigateTo $y $x

    # Turn echo back on for text input
    stty echo
    tput cvvis
    printf "\e[1m${COLOURS[${COLOURS_LOOKUP[R]}]}"
    clearBuffer

    # Clear IFS to avoid whitespace treated as null
    while IFS= read -sn1 key; do
        if [[ -z "$key" ]]; then
            if (( ${#inputString} )); then
                break
            else
                navigateTo $y $x
            fi
        elif [[ "$key" == $'\177' ]]; then
            # If backspace character is pressed, remove last entry
            if (( ${#inputString} )); then
                printf "\b.\b"
                inputString=${inputString:0: -1}
            fi
        elif (( ${#inputString} > $maxLength )); then
            continue
        elif [[ "$key" == [\ _] ]]; then
            # Replace spaces with underscores
            printf "_"
            inputString+="_"
        elif [[ "$key" == [[:punct:]] ]]; then
            # Disallow punctuation
            continue
        elif [[ "$key" == [[:alnum:]] ]]; then
            printf "$key"
            inputString+="$key"
        fi
    done

    printf -v "$nameRef" "%s" "$inputString"
    printf "${COLOURS[${COLOURS_LOOKUP[R]}]}"
    tput civis
    stty -echo
}

saveSettings()
{
    if (( $LEGACY )); then
        printf "%s='%s'\n" _colourMode $_colourMode
        printf "%s='%s'\n" _gameMode $_gameMode
        printf "%s='%s'\n" _ghostingIsSet $_ghostingIsSet
        printf "%s='%s'\n" _holdingIsSet $_holdingIsSet
        printf "%s='%s'\n" _loggingIsSet $_loggingIsSet
    else
        printf "%s\n" ${_colourMode@A} ${_gameMode@A} ${_ghostingIsSet@A} ${_holdingIsSet@A} ${_loggingIsSet@A}
    fi > "$SETTINGS"
}

renderSettings()
{
    renderText "${SETTINGS_SCREEN[@]}"

    renderPartial "SETTINGS_SUB_MENU"
    navigateMenu "SETTINGS_MENU" ${_selected[settings]}
    _selected["settings"]=$?

    case ${_selected[settings]} in
        (0|1) {
            clearSubMenu "SETTINGS_CLEAR_SUB_MENU"
        };;&
        (0) {
            navigateMenu "SETTINGS_COLOUR_SUB_MENU"
            setColourMode $?
            setColours
        };;
        (1) {
            navigateMenu "SETTINGS_GAME_SUB_MENU"
            setGameMode $?
        };;
        (2) {
            setState "CONSTANTS"
            _selected["constants"]=0
        };;
        (4) {
            setState "MAIN" # Return to main menu
            _selected["settings"]=0
        };;
    esac

    saveSettings
}

renderConstants()
{
    renderText "${CONSTANTS_SCREEN[@]}"

    navigateMenu "CONSTANTS_MENU" ${_selected[constants]}
    _selected["constants"]=$?

    case ${_selected[constants]} in
        (5) {
            setState "SETTINGS"
            _selected["constants"]=0
        };;
    esac

    saveSettings
}

renderScreen()
{
    case $_state in
        (*) {
            clearScreen
        };;&
        (0) {
            renderMain
        };;
        (1) {
            renderField
        };;
        (2) {
            renderScores
        };;
        (3) {
            renderSettings
        };;
        (4) {
            renderConstants
        };;
    esac
}

clearScreen()
{
    printf "\e[2J\e[1;1H"
}

clearBuffer()
{
    read -n10000 -t0.0001 # Clear input buffer
}
