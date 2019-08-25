loadPiece ()
{
    (( $_loggingIsSet )) && logLoad
}

translatePiece ()
{
    (( $_loggingIsSet )) && logTranslate

    local -- nextX=$_pieceX
    local -- nextY=$_pieceY

    case $_direction in
        ($DOWN) {
            timeTaken=0 # Reset timer
            (( nextY++ ))
        };;
        ($RIGHT) {
            (( nextX += 2 ))
        };;
        ($LEFT) {
            (( nextX -= 2 ))
        };;
    esac

    canRender "$_currentPiece" $nextY $nextX

    if (( $? == 0 )); then
        removePiece
        [[ "$_direction" != "$DOWN" ]] && (( $_ghostingIsSet )) && removeGhost

        _pieceX=$nextX
        _pieceY=$nextY

        [[ "$_direction" != "$DOWN" ]] && (( $_ghostingIsSet )) && ghostPiece
        renderPiece
    elif [[ "$_direction" == "$DOWN" ]]; then
        lockPiece
        _newPiece=1
    fi
}

rotatePiece ()
{
    # (( $_gameMode == 1 && $_rotation == 3 )) && return
    if [[ "$_gameMode" == "ROTATE" ]]; then
        (( $_rotation == 3 )) && return
    fi
    (( $_loggingIsSet )) && logRotate

    local -- captureRotation=$_rotation
    local -- xPos=$_pieceX
    local -- yPos=$_pieceY

    removePiece
    (( $_ghostingIsSet )) && removeGhost

    (( _rotation == 3 ? _rotation = 0 : _rotation++ ))

    while true; do
        canRender "$_currentPiece" $yPos $xPos

        case $? in
            (0) {
                break
            };;
            (1) {
                (( xPos -= 2 ))
            };; # Right wall
            (3) {
                (( xPos += 2 ))
            };; # Left wall
            (2|4) {
                _rotation=$captureRotation
                renderPiece
                return
            };; # Floor or another tetromino
        esac
    done

    _pieceX=$xPos
    _pieceY=$yPos

    (( $_ghostingIsSet )) && ghostPiece
    renderPiece
}

dropPiece ()
{
    (( $_loggingIsSet )) && logTranslate

    local -- nextY=$_pieceY

    removePiece

    while canRender "$_currentPiece" $(( ++nextY )) $_pieceX; do
        _pieceY=$nextY
    done

    renderPiece
    lockPiece
    _newPiece=1
}

logInput ()
{
    case "$1" in
        (0) {
            printf "%s" $_currentPiece
        };;
        (1) {
            printf "%s" $_direction
        };;
        (2) {
            printf "%s" "R"
        };;
    esac >> "$INPUT_LOG"
}

logLoad ()
{
    logInput 0
}

logTranslate ()
{
    logInput 1
}

logRotate ()
{
    logInput 2
}
