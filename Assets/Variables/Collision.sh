lockPiece ()
{
    local -- coord
    local -- pieceKey=$_currentPiece
    local -- xPos=$_pieceX
    local -- yPos=$_pieceY

    local -a -- toCheck=()
    local -n -- piece="$pieceKey"

    for coord in ${piece[$_rotation]}; do
        toCheck[(( $yPos + ${coord#*,} ))]= # Save as keys to avoid duplicates
        setCollision $(( $yPos + ${coord#*,} )) $(( $xPos + (${coord%,*} * 2) )) ${COLOURS_LOOKUP[$pieceKey]}
    done

    checkLines ${!toCheck[@]}
}
