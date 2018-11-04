pause()
{
    local           \
        paddedText  \
        unpause

    # Basic pause screen
    navigateTo ${fieldOptions[pause,y]} ${fieldOptions[pause,x]}
    renderText "${fieldOptions[pause]}"
    while read -rsn1 unpause; do
        [[ "$unpause" == $'\e' ]] && break
    done
    navigateTo ${fieldOptions[pause,y]} ${fieldOptions[pause,x]}
    printf -v paddedText "%${#fieldOptions[pause]}s"
    renderText "$paddedText"
}

levelUp()
{
    local paddedText

    (( _level++ ))
    navigateTo ${fieldOptions[level,y]} ${fieldOptions[level,x]}
    printf -v paddedText "%${fieldOptions[level,length]}s" $_level
    renderText "$paddedText"
}

lineUp()
{
    local           \
        l           \
        paddedText

    for (( l = 0; l < $1; l++ )); do
        (( ++_lines % 10 == 0 )) && levelUp
    done

    navigateTo ${fieldOptions[lines,y]} ${fieldOptions[lines,x]}
    printf -v paddedText "%${fieldOptions[lines,length]}s" $_lines
    renderText "$paddedText"
}

destroyLines()
{
    local           \
        cleanPid    \
        colour      \
        offset=1    \
        tileType    \
        xPlus       \
        xPos        \
        yPlus       \
        yPos        \
        zeroes=0

    if ! [[ "$_colourMode" =~ (NOIR|BLEACH) ]]; then
        for xPos in {2..20..2}; do
            for yPos in $*; do
                navigateTo $yPos $xPos
                renderText "${colours[${coloursLookup[W]}]}${block}${colours[${coloursLookup[R]}]}"
            done
            sleep 0.02
        done
        sleep 0.04
    fi

    for xPos in {2..20..2}; do
        for yPos in $*; do
            navigateTo $yPos $xPos
            renderText "${colours[${coloursLookup[W]}]}${blank}${colours[${coloursLookup[R]}]}"
            _lock[$yPos,$xPos]=0
        done
        sleep 0.02
    done

    for (( yPlus = ${@: -1} - 1; yPlus > 1; yPlus-- )); do
        if [[ " $* " =~ " $yPlus " ]]; then
            (( offset++ ))
            continue
        fi

        for xPlus in {2..20..2}; do
            colour=${_lock[$yPlus,$xPlus]}
            if (( $colour )); then
                navigateTo $yPlus $xPlus
                renderText "${colours[${coloursLookup[W]}]}${blank}${colours[${coloursLookup[R]}]}"
                navigateTo $(( $yPlus + $offset )) $xPlus
                renderText "${colours[$colour]}${block}${colours[${coloursLookup[R]}]}"
                _lock[$yPlus,$xPlus]=0
            else
                (( zeroes++ ))
            fi
            _lock[$(( $yPlus + $offset )),$xPlus]=$colour
        done

        (( $zeroes == 10 )) && break || zeroes=0    # Blank line detected (no further lines above can have colour)
    done
}

checkLines()
{
    local               \
        line            \
        toDestroy=()    \
        xPos            \
        yPos

    for yPos in $*; do
        line=true
        for xPos in {2..20..2}; do
            if ! (( ${_lock[$yPos,$xPos]} )); then
                line=false
                break
            fi
        done
        $line && toDestroy[$yPos]=
    done

    (( ${#toDestroy[@]} )) && destroyLines ${!toDestroy[@]}
    lineUp ${#toDestroy[@]}
}

lockPiece()
{
    local -n piece="$1"
    local           \
        coord       \
        toCheck=()  \
        x=$3        \
        xAx         \
        y=$2        \
        yAx

    for coord in ${piece[$_rotation]}; do
        IFS=, read -r xAx yAx <<< "$coord"
        toCheck[(( $y + $yAx ))]= # Save as keys to avoid duplicates
        _lock[$(( $y + $yAx )),$(( $x + ($xAx * 2) ))]=${coloursLookup[$1]}
    done

    checkLines ${!toCheck[@]}
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
        elif (( $xAx > 20 )); then # Right wall
            collides=1
            return 1
        elif (( $xAx < 2 )); then # Left wall
            collides=3
            return 1
        elif (( $yAx > 23 )); then # Floor
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
        tile                \
        reset=${4:-false}   \
        x=$3                \
        xAx                 \
        y=$2                \
        yAx

    for coord in ${piece[$_rotation]}; do
        IFS=, read -r xAx yAx <<< "$coord"
        if $reset; then
            tile="${blank}"
        else
            tile="${colours[${coloursLookup[$1]}]}${block}${colours[${coloursLookup[R]}]}"
        fi
        navigateTo $(( $y + $yAx )) $(( $x + ($xAx * 2) ))
        renderText "$tile"
    done
}

removePiece()
{
    renderPiece "$1" $2 $3 true
}

renderNextPiece()
{
    removePiece "$_currentPiece" ${nextPiece[$_currentPiece,y]} ${nextPiece[$_currentPiece,x]}
    renderPiece "$_nextPiece" ${nextPiece[$_nextPiece,y]} ${nextPiece[$_nextPiece,x]}
}

navigateMenu()
{
    local -n menuOptions="$1"
    local           \
        key1        \
        key2        \
        key3        \
        optionText  \
        selected=0  \
        m

    while true; do
        for (( m = 0; $m < (${menuOptions[max]} + 1); m++ )); do
            # if [[ "$_colourMode" == "BLEACH" ]]; then
            #     (( $m == $selected )) && optionText='\e[27m' || optionText='\e[7m'
            # else
            # fi
            (( $m == $selected )) && optionText='\e[7m' || optionText='\e[27m'
            optionText+="${menuOptions[$m]}\e[27m"
            navigateTo ${menuOptions[$m,y]} ${menuOptions[$m,x]}
            renderText "$optionText"
        done

        IFS= read -srn 1 key1 <&6
        IFS= read -srn 1 -t 0.001 key2 <&6
        IFS= read -srn 1 -t 0.001 key3 <&6

        test -z "$key1" && break

        case $key3 in
            A)  (( $selected == 0 ? selected = ${menuOptions[max]} : selected-- ));; # Up
            B)  (( $selected == ${menuOptions[max]} ? selected = 0 : selected++ ));; # Down
        esac
    done

    return $selected
}

renderSubMenu()
{
    local -n subOptions="$1"
    local           \
        optionText  \
        selected=0  \
        s

    navigateTo ${subOptions[y]} ${subOptions[x]}
    renderText "${subOptions[top]}"
    for (( s = 1; $s < ${subOptions[max]}; s++ )); do
        navigateTo $(( ${subOptions[y]} + $s )) ${subOptions[x]}
        renderText "${subOptions[middle]}"
    done
    navigateTo $(( ${subOptions[y]} + $s )) ${subOptions[x]}
    renderText "${subOptions[bottom]}"

    navigateMenu 'settingsColourSubOptions'
    case $? in
        0)  _colourMode='NORMAL';;
        1)  _colourMode='SIMPLE';;
        2)  _colourMode='NOIR';;
        3)  _colourMode='BLEACH';;
    esac
}

renderPartial()
{
    local -n partialOptions="$1"
    local           \
        c           \
        half        \
        optionText  \
        p

    for (( c = 0; $c < ${partialOptions[clear,max]}; c++ )); do
        navigateTo $(( ${partialOptions[clear,y]} + $c )) ${partialOptions[clear,x]}
        renderText "${partialOptions[clear]}"
    done

    for (( p = 0; $p < ${partialOptions[clear,max]}; p++ )); do
        optionText="${!partialOptions[$p]}"
        half=$(( (${partialOptions[width]} - ${#optionText}) / 2 ))
        navigateTo ${partialOptions[$p,y]} $(( ${partialOptions[$p,x]} + $half + 1 ))
        renderText "$optionText"
    done
}

renderMain()
{
    renderText "${mainScreen[@]}"

    navigateMenu 'mainOptions'
    case $? in
        0)  _state=1;; # New game
        1)  _state=2;; # Scores
        2)  _state=3;; # Settings
        3)  exit 0;;
    esac
}

renderField()
{
    renderText "${fieldScreen[@]}"
}

renderScores()
{
    return
}

renderSettings()
{
    renderText "${settingsScreen[@]}"

    renderPartial 'settingsSubMenu'
    navigateMenu 'settingsOptions'
    case $? in
        0)  renderSubMenu 'settingsColourSub';;
        1)  _state=0
            return;; # Return to main menu
    esac
}

renderScreen()
{
    local screen=''

    setColours
    clearScreen

    case $_state in
        0)  renderMain;;
        1)  renderField;;
        2)  return;;
        3)  renderSettings;;
    esac
}

clearScreen()
{
    printf '\e[2J\e[1;1H'
}

navigateTo()
{
    printf '\e[%s;%sH' $1 $2
}

renderText()
{
    printf "${colours[0]}%b\e[0m\n" "$@"
}
