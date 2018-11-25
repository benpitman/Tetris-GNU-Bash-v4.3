navigateMenu()
{
    local -n menu="$1"
    local -n menuOptions="${menu[OPTIONS]}"
    local                   \
        key1                \
        key2                \
        key3                \
        optionText          \
        selected=${2:-0}    \
        m

    while true; do
        for (( m = 0; $m < (${menu[MAX]} + 1); m++ )); do
            (( $m == $selected )) && optionText='\e[7m' || optionText='\e[27m'
            optionText+="${menu[PADDING]}${menuOptions[$m]}${menu[PADDING]}\e[27m"
            navigateTo ${menu[$m,Y]} ${menu[$m,X]}
            renderText "$optionText"
        done

        if test -n "${menu[$selected,NOTE]}"; then
            navigateTo ${NOTE[Y]} $(( ${NOTE[X]} - (${#menu[$selected,NOTE]} / 2) ))
            renderText "${menu[$selected,NOTE]}"
        fi

        IFS= read -srn 1 key1
        IFS= read -srn 1 -t 0.001 key2
        IFS= read -srn 1 -t 0.001 key3

        test -z "$key1" && break

        if test -n "${menu[$selected,NOTE]}"; then
            navigateTo ${NOTE[Y]} $(( ${NOTE[X]} - (${#NOTE[CLEAR]} / 2) ))
            renderText "${NOTE[CLEAR]}"
        fi

        case $key3 in
            $UP)    (( $selected == 0 ? selected = ${menu[MAX]} : selected-- ));;
            $DOWN)  (( $selected == ${menu[MAX]} ? selected = 0 : selected++ ));;
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

    for (( p = 0; $p < (${partialOptions[MAX]} + 1); p++ )); do
        optionText="${!partialOptions[$p]}"
        half=$(( (${partialOptions[WIDTH]} - ${#optionText}) / 2 ))
        navigateTo ${partialOptions[$p,Y]} $(( ${partialOptions[$p,X]} + $half + 1 ))
        renderText "$optionText"
    done
}

renderMain()
{
    renderText "${MAIN_SCREEN[@]}"

    navigateMenu 'MAIN_MENU' ${_selected[main]}
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
    local                   \
        editableIndex       \
        editableRow         \
        line                \
        newScore=false      \
        playername          \
        score               \
        scores              \
        scoreShown=false    \
        userNames=()        \
        userScores=()

    (( $_score > 0 )) && newScore=true

    renderText "${SCORES_SCREEN[@]}"

    if $LEGACY; then
        IFS=$'\n' read -d '' -ra scores < "$HIGHSCORE_LOG"
    else
        readarray -t scores < "$HIGHSCORE_LOG"
    fi

    for (( line = 0; $line < ${#scores[@]}; line++ )); do
        userScores[$line]=${scores[$line]/*\,/}
        userNames[$line]=${scores[$line]/\,*/}

        if ! $scoreShown && $newScore && (( ${userScores[$line]} <= $_score )); then
            scoreShown=true
            editableIndex=$line
        fi
    done

    if $newScore; then
        test -z "$editableIndex" && editableIndex=${#scores[@]}
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
        if $newScore && (( $score == $editableIndex )); then
            editableRow=$scoreRow
        else
            printScore $scoreRow ${SCORES[X]} $(( $score + 1 )) "${userNames[$score]}" ${userScores[$score]}
        fi
    done

    if $newScore; then
        test -z "$editableRow" && editableRow=$(( ${SCORES[Y]} + ${SCORES[MAX]} ))

        printScore $editableRow ${SCORES[X]} $(( $editableIndex + 1 )) "" $_score true
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
    local                   \
        bit                 \
        bold=${6:-false}    \
        hrScore             \
        index=$3            \
        name="$4"           \
        pad                 \
        paddedScore         \
        score=$5            \
        spacer              \
        y=$1                \
        x=$2

    # Make the score human readable
    for (( bit = ${#score}; bit > 0; bit-- )); do
        (( $bit < ${#score} && $bit % 3 == 0 )) && hrScore+=","
        hrScore+="${score: -$bit:1}"
    done

    (( pad = ${SCORES[WIDTH]} - (4 + ${#name} + ${#hrScore}) ))
    eval printf -v spacer '%.0s.' {1..$pad}
    printf -v paddedScore '%-4s%s%s%s' "$index" "$name" "$spacer" "$hrScore"
    $bold && paddedScore="\e[1m$paddedScore"

    navigateTo $y $x
    renderText "$paddedScore"
}

textEntry()
{
    local               \
        inputString     \
        key             \
        maxLength=$3    \
        nameRef=$4      \
        y=$1            \
        x=$2

    navigateTo $y $x false

    # Turn echo back on for text input
    stty echo
    tput cvvis
    printf "\e[1m${COLOURS[${COLOURS_LOOKUP[R]}]}"
    clearBuffer

    # Clear IFS to avoid whitespace treated as null
    while IFS= read -sn1 key; do
        if [ -z "$key" ]; then
            if (( ${#inputString} )); then
                break
            else
                navigateTo $y $x false
            fi
        # If backspace character is pressed, remove last entry
        elif [[ "$key" == $'\177' ]]; then
            if (( ${#inputString} )); then
                printf '\b.\b'
                inputString=${inputString:0: -1}
            fi
        elif (( ${#inputString} > $maxLength )); then
            continue
        elif [[ "$key" == [\ _] ]]; then
            # Replace spaces with underscores
            printf '_'
            inputString+="_"
        elif [[ "$key" == [[:punct:]] ]]; then
            # Disallow punctuation
            continue
        elif [[ "$key" == [[:alnum:]] ]]; then
            printf "$key"
            inputString+="$key"
        fi
    done

    printf -v "$nameRef" '%s' "$inputString"
    printf "${COLOURS[${COLOURS_LOOKUP[R]}]}"
    tput civis
    stty -echo
}

renderSettings()
{
    renderText "${SETTINGS_SCREEN[@]}"

    renderPartial 'SETTINGS_SUB_MENU'
    navigateMenu 'SETTINGS_MENU' ${_selected[settings]}
    _selected['settings']=$?

    case ${_selected[settings]} in
        0|1)    clearSubMenu 'SETTINGS_CLEAR_SUB_MENU';;&
        0)      navigateMenu 'SETTINGS_COLOUR_SUB_MENU'
                setColourMode $?
                setColours;;
        1)      navigateMenu 'SETTINGS_GAME_SUB_MENU'
                setGameMode $?;;
        2)      toggleGhosting;;
        3)      toggleLogging;;
        4)      setState 'MAIN'
                _selected['settings']=0
                return;; # Return to main menu
    esac
}

renderScreen()
{
    case $_state in
        *)  clearScreen;;&
        0)  renderMain;;
        1)  renderField;;
        2)  renderScores;;
        3)  renderSettings;;
    esac
}

clearScreen()
{
    printf '\e[2J\e[1;1H'
}

clearBuffer()
{
    read -n10000 -t0.001 # Clear input buffer
}
