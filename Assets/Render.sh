alert ()
{
    local -- alertType=$1
    local -- key1
    local -- sticky=${2:-0}
    local -- unstick=${3:-''}

    navigateTo ${FIELD_OPTIONS[ALERT,Y]} ${FIELD_OPTIONS[ALERT,X]}
    renderText "\e[1m${FIELD_OPTIONS[ALERT,$alertType]}\e[0m"

    if (( $sticky )); then
        while IFS= read -rsn1 key1; do
            IFS= read -rsn1 -t0.0001 key2
            if [[ "$key1" == $'\e' && "$key2" == "" ]] || \
                    [[ "$key1" == $unstick ]] || \
                    [[ "$key1" == "" && "$key2" == "" ]]; then
                alert "CLEAR"
                break
            fi
        done
        clearBuffer
    fi

    if [[ "$alertType" == "GAME_OVER" || "$alertType" == "END_REPLAY" ]]; then
        sleep 2
    elif [[ "$alertType" != "CLEAR" || "$alertType" != "PAUSED" ]]; then
        printf -v _alertTimeout "%(%s)T" -1
        (( _alertTimeout += 2 ))
    fi
}

pause ()
{
    local -- pauseIndex

    buildPauseScreen

    for pauseIndex in ${!PAUSE_SCREEN[@]}; do
        navigateTo ${pauseIndex%,*} ${pauseIndex#*,}
        renderText "${COLOURS[${PAUSE_SCREEN[$pauseIndex]}]}$BLOCK${COLOURS[${COLOURS_LOOKUP[W]}]}"
    done

    alert "PAUSED" 1 "[Pp]"

    refreshPlayingField
}

renderPerfectClear ()
{
    local -- perfectIndex=0

    while (( $perfectIndex <= ${FIELD_OPTIONS[PERFECT,MAX]} )); do
        navigateTo ${FIELD_OPTIONS[PERFECT,$perfectIndex,Y]} ${FIELD_OPTIONS[PERFECT,$perfectIndex,X]}
        renderText "${FIELD_OPTIONS[PERFECT,$perfectIndex]}"

        (( perfectIndex++ ))
    done

    sleep 2
    perfectIndex=0

    while (( $perfectIndex <= ${FIELD_OPTIONS[PERFECT,MAX]} )); do
        navigateTo ${FIELD_OPTIONS[PERFECT,$perfectIndex,Y]} ${FIELD_OPTIONS[PERFECT,$perfectIndex,X]}
        renderText "${FIELD_OPTIONS[PERFECT,$perfectIndex,CLEAR]}"

        (( perfectIndex++ ))
    done
}

levelUp ()
{
    local -- paddedText

    (( _level++ ))
    navigateTo ${FIELD_OPTIONS[LEVEL,Y]} ${FIELD_OPTIONS[LEVEL,X]}
    printf -v paddedText "%${FIELD_OPTIONS[LEVEL,WIDTH]}s" $_level
    renderText "$paddedText"
}

scoreUp ()
{
    local -- modifier
    local -- numLines=$1
    local -- paddedText
    local -- perfect=${2:-0}

    case $1 in
        1)  modifier=40;;
        2)  modifier=100;;
        3)  modifier=300;;
        4)  modifier=1200;;
    esac

    (( modifier *= ($_level + 1) ))
    (( $perfect && (modifier *= 2) ))
    (( _score += $modifier ))

    navigateTo ${FIELD_OPTIONS[SCORE,Y]} ${FIELD_OPTIONS[SCORE,X]}
    printf -v paddedText "%${FIELD_OPTIONS[SCORE,WIDTH]}s" $_score
    renderText "$paddedText"
}

lineUp ()
{
    local -- lineIndex=0
    local -- numLines=$1
    local -- paddedText
    local -- perfect=${2:-0}

    scoreUp $numLines $perfect
    while (( lineIndex++ < $numLines )); do
        (( ++_lines % 10 )) || levelUp
    done

    case $numLines in
        (1) {
            alert "SINGLE"
        };;
        (2) {
            alert "DOUBLE"
        };;
        (3) {
            alert "TRIPLE"
        };;
        (4) {
            alert "TETRIS"
        };;
    esac

    navigateTo ${FIELD_OPTIONS[LINES,Y]} ${FIELD_OPTIONS[LINES,X]}
    printf -v paddedText "%${FIELD_OPTIONS[LINES,WIDTH]}s" $_lines
    renderText "$paddedText"

    (( $perfect )) && renderPerfectClear
}

destroyLines ()
{
    local -- colour
    local -- offset=1
    local -- tileType
    local -- xPlus
    local -- xPos
    local -- yPlus
    local -- yPos
    local -- zeroes=0

    local -a -- lineIndexes=($*)

    # If we're in a colour mode, show a white strip before clearing the line
    if (( $_colourMode == 0 || $_colourMode == 1 )); then
        for xPos in ${X_POSITIONS[@]}; do
            for yPos in $*; do
                navigateTo $yPos $xPos
                renderText "${COLOURS[${COLOURS_LOOKUP[W]}]}${BLOCK}${COLOURS[${COLOURS_LOOKUP[R]}]}"
            done
            sleep 0.02
        done
        sleep 0.04
    fi

    # Clear the line
    for xPos in ${X_POSITIONS[@]}; do
        for yPos in ${lineIndexes[@]}; do
            navigateTo $yPos $xPos
            renderText "${COLOURS[${COLOURS_LOOKUP[W]}]}${BLANK}${COLOURS[${COLOURS_LOOKUP[R]}]}"
            _lock[$yPos,$xPos]=0
        done
        sleep 0.02
    done

    # Redraw all the lines above down to act as gravity
    # Start one line above the lowest line been deleted
    for (( yPlus = ${lineIndexes[@]: -1} - 1; yPlus > 1; yPlus-- )); do
        if [[ " ${lineIndexes[@]} " =~ " $yPlus " ]]; then
            (( offset++ ))
            continue
        fi

        for xPlus in ${X_POSITIONS[@]}; do
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

        (( $zeroes == 10 )) && break || zeroes=0 # Blank line detected (no further lines above can have colour)
    done
}

checkLines ()
{
    local -- lineIsFull
    local -- perfect=0
    local -- perfectYCheck
    local -- xPos
    local -- yPos

    local -a -- toCheck=($*)
    local -a -- toDestroy=()

    # Calculate lines to destroy
    for yPos in ${toCheck[@]}; do
        lineIsFull=1

        for xPos in ${X_POSITIONS[@]}; do
            # If any block on a line does not have colour, skip this line
            if (( ${_lock[$yPos,$xPos]} == 0 )); then
                lineIsFull=0
                break
            fi
        done

        (( $lineIsFull )) && toDestroy[$yPos]=1
    done

    # If all Y coordinates from the placed tetromino will be removed
    if (( ${#toDestroy[@]} == ${#toCheck[@]} )); then
        perfect=1
        perfectYCheck=$(( ${toCheck[0]} - 1 ))

        # Calculate if the line above is clear
        if (( $perfectYCheck >= $CEILING )); then
            for xPos in ${X_POSITIONS[@]}; do
                # If any block on this line has colour, a clear was not made
                if (( ${_lock[$perfectYCheck,$xPos]} )); then
                    perfect=0
                    break
                fi
            done
        fi
    fi

    if (( ${#toDestroy[@]} )); then
        destroyLines ${!toDestroy[@]}
        lineUp ${#toDestroy[@]} $perfect
    fi
}

lockPiece ()
{
    local -- coord
    local -- pieceKey=$_currentPiece
    local -- xPos=$_pieceX
    local -- xAx
    local -- yPos=$_pieceY
    local -- yAx

    local -a -- toCheck=()
    local -n -- piece="$pieceKey"

    for coord in ${piece[$_rotation]}; do
        IFS=, read -r xAx yAx <<< $coord
        toCheck[(( $yPos + $yAx ))]= # Save as keys to avoid duplicates
        _lock[$(( $yPos + $yAx )),$(( $xPos + ($xAx * 2) ))]=${COLOURS_LOOKUP[$pieceKey]}
    done

    checkLines ${!toCheck[@]}
}

refreshPlayingField ()
{
    local -- lockIndex

    for lockIndex in ${!_lock[@]}; do
        navigateTo ${lockIndex%,*} ${lockIndex#*,}
        if (( ${_lock[$lockIndex]} )); then
            renderText "${COLOURS[${_lock[$lockIndex]}]}$BLOCK${COLOURS[${COLOURS_LOOKUP[W]}]}"
        else
            renderText "$BLANK"
        fi
    done

    renderGhost
    renderPiece
}

canRender ()
{
    local -- coord
    local -- xPos=$3
    local -- xAx
    local -- yPos=$2
    local -- yAx

    local -n -- piece="$1"

    for coord in ${piece[$_rotation]}; do
        (( xAx = $xPos + (${coord%,*} * 2) ))
        (( yAx = $yPos + ${coord#*,} ))

        # Needs to check tetromino collision first for rotation
        if (( ${_lock[$yAx,$xAx]} )); then
            return 4
        elif (( $xAx > $RIGHT_WALL )); then
            return 1
        elif (( $xAx < $LEFT_WALL )); then
            return 3
        elif (( $yAx > $FLOOR )); then # Floor
            return 2
        fi
    done
}

renderObject ()
{
    local -- coord
    local -- pieceKey=$1
    local -- tile
    local -- tileType=$4
    local -- xPos=$3
    local -- yPos=$2

    local -n -- piece="$pieceKey"

    tile="${COLOURS[${COLOURS_LOOKUP[$pieceKey]}]}${!tileType}${COLOURS[${COLOURS_LOOKUP[R]}]}"

    for coord in ${piece[$_rotation]}; do
        navigateTo $(( $yPos + ${coord#*,} )) $(( $xPos + (${coord%,*} * 2) ))
        renderText "$tile"
    done
}

renderGhost ()
{
    renderObject "$_currentPiece" $_ghostY $_pieceX 'GHOST'
}

removeGhost ()
{
    renderObject "$_currentPiece" $_ghostY $_pieceX 'BLANK'
}

renderPiece ()
{
    renderObject "$_currentPiece" $_pieceY $_pieceX 'BLOCK'
}

removePiece ()
{
    renderObject "$_currentPiece" $_pieceY $_pieceX 'BLANK'
}

renderNextPiece ()
{
    renderObject "$_currentPiece" ${NEXT_PIECE[$_currentPiece,Y]} ${NEXT_PIECE[$_currentPiece,X]} 'BLANK'
    renderObject "$_nextPiece" ${NEXT_PIECE[$_nextPiece,Y]} ${NEXT_PIECE[$_nextPiece,X]} 'BLOCK'
}

navigateTo ()
{
    printf '\e[%s;%sH' $1 $2
}

renderText ()
{
    (( $# > 1 )) && printf "${COLOURS[0]}%b\e[0m\n" "${@:1:$#-1}"
    printf "${COLOURS[0]}%b\e[0m" "${@: -1}"
}
