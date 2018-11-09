pause()
{
    local           \
        paddedText  \
        unpause

    # Basic pause screen
    navigateTo ${FIELD_OPTIONS[pause,y]} ${FIELD_OPTIONS[pause,x]}
    renderText "${FIELD_OPTIONS[pause]}"
    while read -rsn1 unpause; do
        [[ "$unpause" == $'\e' ]] && break
    done
    navigateTo ${FIELD_OPTIONS[pause,y]} ${FIELD_OPTIONS[pause,x]}
    printf -v paddedText "%${#FIELD_OPTIONS[pause]}s"
    renderText "$paddedText"
}

levelUp()
{
    local paddedText

    (( _level++ ))
    navigateTo ${FIELD_OPTIONS[level,y]} ${FIELD_OPTIONS[level,x]}
    printf -v paddedText "%${FIELD_OPTIONS[level,length]}s" $_level
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

    navigateTo ${FIELD_OPTIONS[lines,y]} ${FIELD_OPTIONS[lines,x]}
    printf -v paddedText "%${FIELD_OPTIONS[lines,length]}s" $_lines
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
    removePiece "$_currentPiece" ${NEXT_PIECE[$_currentPiece,y]} ${NEXT_PIECE[$_currentPiece,x]}
    renderPiece "$_nextPiece" ${NEXT_PIECE[$_nextPiece,y]} ${NEXT_PIECE[$_nextPiece,x]}
}

navigateTo()
{
    printf '\e[%s;%sH' $1 $2
}

renderText()
{
    printf "${COLOURS[0]}%b\e[0m\n" "$@"
}
