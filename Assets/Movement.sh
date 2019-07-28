movePiece ()
{
    local -- moveType=$1
    local -- moveConstant=

    case $moveType in
        (0) {
            translatePiece
            (( $_loggingIsSet )) && logTranslate
        };;
        (1) {
            rotatePiece
            (( $_loggingIsSet )) && logRotate
        };;
        (2) {
            dropPiece
            (( $_loggingIsSet )) && logTranslate
        };;
        (3) {
            (( $_loggingIsSet )) && logLoad
        };;
    esac
}

translatePiece ()
{
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
        removePiece "$_currentPiece" $_pieceY $_pieceX
        [[ "$_direction" != "$DOWN" ]] && (( $_ghostingIsSet )) && removePiece "$_currentPiece" $_ghostY $_pieceX

        _pieceX=$nextX
        _pieceY=$nextY

        [[ "$_direction" != "$DOWN" ]] && (( $_ghostingIsSet )) && ghostPiece
        renderPiece "$_currentPiece" $_pieceY $_pieceX
    elif [[ "$_direction" == "$DOWN" ]]; then
        lockPiece "$_currentPiece" $_pieceY $_pieceX
        _newPiece=1
    fi
}

rotatePiece ()
{
    # (( $_gameMode == 1 && $_rotation == 3 )) && return
    if [[ "$_gameMode" == "ROTATE" ]]; then
        (( $_rotation == 3 )) && return
    fi

    local -- captureRotation=$_rotation
    local -- xPos=$_pieceX
    local -- yPos=$_pieceY

    removePiece "$_currentPiece" $_pieceY $_pieceX
    (( $_ghostingIsSet )) && removePiece "$_currentPiece" $_ghostY $_pieceX

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
                renderPiece "$_currentPiece" $_pieceY $_pieceX
                return
            };; # Floor or another tetromino
        esac
    done

    _pieceX=$xPos
    _pieceY=$yPos

    (( $_ghostingIsSet )) && ghostPiece
    renderPiece "$_currentPiece" $_pieceY $_pieceX
}

dropPiece ()
{
    local -- nextY=$_pieceY

    removePiece "$_currentPiece" $_pieceY $_pieceX

    while canRender "$_currentPiece" $(( ++nextY )) $_pieceX; do
        _pieceY=$nextY
    done

    renderPiece "$_currentPiece" $_pieceY $_pieceX
    lockPiece "$_currentPiece" $_pieceY $_pieceX
    _newPiece=1
}

logInput ()
{
    case "$1" in
        ('LOAD')      printf '%s' $_currentPiece;;
        ('TRANSLATE') printf '%s' $_direction;;
        ('ROTATE')    printf '%s' 'R';;
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
