alert()
{
    local                   \
        paddedText          \
        sticky=${2:-false}  \
        key1

    navigateTo ${FIELD_OPTIONS[ALERT,Y]} ${FIELD_OPTIONS[ALERT,X]}
    renderText "\e[1m${FIELD_OPTIONS[ALERT,$1]}\e[0m"

    if $sticky; then
        while IFS= read -rsn1 key1; do
            IFS= read -rsn1 -t0.0001 key2
            test -z "$key2" && [[ "$key1" == $'\e' ]] && break
        done
    else
        sleep 2
    fi

    navigateTo ${FIELD_OPTIONS[ALERT,Y]} ${FIELD_OPTIONS[ALERT,X]}
    printf -v paddedText "%${#FIELD_OPTIONS[ALERT,$1]}s"
    renderText "$paddedText"
}

pause()
{
    alert 'PAUSED' true
}

levelUp()
{
    local paddedText

    (( _level++ ))
    navigateTo ${FIELD_OPTIONS[LEVEL,Y]} ${FIELD_OPTIONS[LEVEL,X]}
    printf -v paddedText "%${FIELD_OPTIONS[LEVEL,WIDTH]}s" $_level
    renderText "$paddedText"
}

scoreUp()
{
    local modifier paddedText

    case $1 in
        1)  modifier=40;;
        2)  modifier=100;;
        3)  modifier=300;;
        4)  modifier=1200;;
    esac

    (( _score += $modifier * ($_level + 1) ))
    navigateTo ${FIELD_OPTIONS[SCORE,Y]} ${FIELD_OPTIONS[SCORE,X]}
    printf -v paddedText "%${FIELD_OPTIONS[SCORE,WIDTH]}s" $_score
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

    scoreUp $1
    case $1 in
        1)  alert 'SINGLE' &;;
        2)  alert 'DOUBLE' &;;
        3)  alert 'TRIPLE' &;;
        4)  alert 'TETRIS' &;;
    esac

    navigateTo ${FIELD_OPTIONS[LINES,Y]} ${FIELD_OPTIONS[LINES,X]}
    printf -v paddedText "%${FIELD_OPTIONS[LINES,WIDTH]}s" $_lines
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
                renderText "${COLOURS[${COLOURS_LOOKUP[W]}]}${BLOCK}${COLOURS[${COLOURS_LOOKUP[R]}]}"
            done
            sleep 0.02
        done
        sleep 0.04
    fi

    for xPos in {2..20..2}; do
        for yPos in $*; do
            navigateTo $yPos $xPos
            renderText "${COLOURS[${COLOURS_LOOKUP[W]}]}${BLANK}${COLOURS[${COLOURS_LOOKUP[R]}]}"
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
                renderText "${COLOURS[${COLOURS_LOOKUP[W]}]}${BLANK}${COLOURS[${COLOURS_LOOKUP[R]}]}"
                navigateTo $(( $yPlus + $offset )) $xPlus
                renderText "${COLOURS[$colour]}${BLOCK}${COLOURS[${COLOURS_LOOKUP[R]}]}"
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

    if (( ${#toDestroy[@]} )); then
        destroyLines ${!toDestroy[@]}
        lineUp ${#toDestroy[@]}
    fi
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
        _lock[$(( $y + $yAx )),$(( $x + ($xAx * 2) ))]=${COLOURS_LOOKUP[$1]}
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
            return 4
        elif (( $xAx > 20 )); then # Right wall
            return 1
        elif (( $xAx < 2 )); then # Left wall
            return 3
        elif (( $yAx > 23 )); then # Floor
            return 2
        fi
    done

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
            tile="${BLANK}"
        else
            tile="${COLOURS[${COLOURS_LOOKUP[$1]}]}${BLOCK}${COLOURS[${COLOURS_LOOKUP[R]}]}"
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
    removePiece "$_currentPiece" ${NEXT_PIECE[$_currentPiece,Y]} ${NEXT_PIECE[$_currentPiece,X]}
    renderPiece "$_nextPiece" ${NEXT_PIECE[$_nextPiece,Y]} ${NEXT_PIECE[$_nextPiece,X]}
}

navigateTo()
{
    printf '\e[%s;%sH' $1 $2
}

renderText()
{
    printf "${COLOURS[0]}%b\e[0m\n" "$@"
}
