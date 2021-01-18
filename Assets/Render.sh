clearPlayingField ()
{
    local -- yPos=
    local -- xPos=

    for (( yPos = $CEILING; yPos <= $FLOOR; yPos++ )); do
        xPos=$LEFT_WALL
        navigateTo $yPos $xPos

        for (( ; xPos <= $RIGHT_WALL; xPos += 2 )); do
            renderBlankTile
        done
    done
}

refreshPlayingField ()
{
    local -- yPos=
    local -- xPos=

    for (( yPos = $CEILING; yPos <= $FLOOR; yPos++ )); do
        xPos=$LEFT_WALL
        navigateTo $yPos $xPos

        for (( ; xPos <= $RIGHT_WALL; xPos += 2 )); do

            if hasCollision $yPos $xPos; then
                getLockColourID $yPos $xPos
                renderBlockTile $?
            else
                renderBlankTile
            fi
        done
    done

    renderPiece
    ghostEnabled && renderGhost
}

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
                    [[ "$key1" =~ $unstick ]] || \
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

renderPerfectClear ()
{
    local -- perfectIndex=0

    while (( $perfectIndex <= ${FIELD_OPTIONS[PERFECT,MAX]} )); do
        navigateTo ${FIELD_OPTIONS[PERFECT,$perfectIndex,Y]} ${FIELD_OPTIONS[PERFECT,$perfectIndex,X]}
        renderText "${FIELD_OPTIONS[PERFECT,$perfectIndex,TEXT]}"

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
    (( _level++ ))
    navigateTo ${FIELD_OPTIONS[LEVEL,Y]} ${FIELD_OPTIONS[LEVEL,X]}
    renderPaddedText "$_level" ${FIELD_OPTIONS[LEVEL,WIDTH]}
}

scoreUp ()
{
    local -- modifier
    local -- numLines=$1
    local -- perfect=${2:-0}

    modifier=${SCORE_MODIFIERS[$numLines]}

    (( modifier *= ($_level + 1) ))
    (( $perfect && (modifier *= 2) ))
    (( _score += $modifier ))

    navigateTo ${FIELD_OPTIONS[SCORE,Y]} ${FIELD_OPTIONS[SCORE,X]}
    renderPaddedText "$_score" ${FIELD_OPTIONS[SCORE,WIDTH]}
}

lineUp ()
{
    local -- lineIndex=0
    local -- numLines=$1
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
    renderPaddedText "$_lines" ${FIELD_OPTIONS[LINES,WIDTH]}

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
                renderBlockTile ${COLOURS_LOOKUP[W]}
            done
            sleep 0.02
        done
        sleep 0.04
    fi

    # Clear the line
    for xPos in ${X_POSITIONS[@]}; do
        for yPos in ${lineIndexes[@]}; do
            navigateTo $yPos $xPos
            renderBlankTile
            setCollision $yPos $xPos ${COLOURS_LOOKUP[R]} 0
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
            getLockColourID $yPlus $xPlus
            colour=$?

            if hasCollision $yPlus $xPlus; then
                navigateTo $yPlus $xPlus
                renderBlankTile
                navigateTo $(( $yPlus + $offset )) $xPlus
                renderBlockTile $colour
                setCollision $yPlus $xPlus ${COLOURS_LOOKUP[R]} 0
                setCollision $(( $yPlus + $offset )) $xPlus $colour
            else
                (( zeroes++ ))
                setCollision $(( $yPlus + $offset )) $xPlus $colour 0
            fi

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
            if ! hasCollision $yPos $xPos; then
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
                if hasCollision $perfectYCheck $xPos; then
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
        if hasCollision $yAx $xAx; then
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

    for coord in ${piece[$_rotation]}; do
        navigateTo $(( $yPos + ${coord#*,} )) $(( $xPos + (${coord%,*} * 2) ))
        renderTile $tileType ${COLOURS_LOOKUP[$pieceKey]}
    done
}

renderGhost ()
{
    renderObject "$_currentPiece" $_ghostY $_pieceX 1
}

removeGhost ()
{
    renderObject "$_currentPiece" $_ghostY $_pieceX 2
}

renderPiece ()
{
    renderObject "$_currentPiece" $_pieceY $_pieceX 0
}

removePiece ()
{
    renderObject "$_currentPiece" $_pieceY $_pieceX 2
}

renderNextPiece ()
{
    renderObject "$_currentPiece" ${NEXT_PIECE[$_currentPiece,Y]} ${NEXT_PIECE[$_currentPiece,X]} 2
    renderObject "$_nextPiece" ${NEXT_PIECE[$_nextPiece,Y]} ${NEXT_PIECE[$_nextPiece,X]} 0
}

navigateTo ()
{
    printf '\e[%s;%sH' $1 $2
}

renderText ()
{
    (( $# > 1 )) && printf "${COLOURS[${COLOURS_LOOKUP[R]}]}%b\e[0m\n" "${@:1:$#-1}"
    printf "${COLOURS[${COLOURS_LOOKUP[R]}]}%b\e[0m" "${@: -1}"
}

renderPaddedText ()
{
    local -- paddedText=
    local -- padWidth=$2
    local -- text="$1"

    printf -v paddedText "%${padWidth}s" "$text"
    renderText "$paddedText"
}

renderTile ()
{
    local -- tile

    case $1 in
        (0) tile=$BLOCK;;
        (1) tile=$GHOST;;
        (2) tile=$BLANK;;
    esac

    renderText "${COLOURS[$2]}${tile}${COLOURS[${COLOURS_LOOKUP[R]}]}"
}

renderBlockTile ()
{
    renderTile 0 $1
}

renderGhostTile ()
{
    renderTile 1 $1
}

renderBlankTile ()
{
    renderTile 2 ${COLOURS_LOOKUP[W]}
}
