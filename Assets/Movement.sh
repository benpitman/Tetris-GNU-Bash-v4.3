movePiece ()
{
    local moveType=$1
    local moveConstant=

    case $moveType in
        (0) {
            translatePiece
            moveConstant="TRANSLATE"
        };;
        (1) {
            rotatePiece
            moveConstant="ROTATE"
        };;
        (2) {
            dropPiece
            moveConstant="TRANSLATE"
        };;
        (3) {
            moveConstant="LOAD"
        };;
    esac

    $_loggingIsSet && logInput $moveConstant
}

translatePiece ()
{
    local               \
        nextX=$_pieceX  \
        nextY=$_pieceY

    case $direction in
        $DOWN)  timeTaken=0 # Reset timer
                (( nextY++ ));;
        $RIGHT) (( nextX += 2 ));;
        $LEFT)  (( nextX -= 2 ));;
    esac

    canRender "$_currentPiece" $nextY $nextX

    if (( $? == 0 )); then
        removePiece "$_currentPiece" $_pieceY $_pieceX
        [[ "$direction" != "$DOWN" ]] && $_ghostingIsSet && removePiece "$_currentPiece" $_ghostY $_pieceX

        _pieceX=$nextX
        _pieceY=$nextY

        [[ "$direction" != "$DOWN" ]] && $_ghostingIsSet && ghostPiece
        renderPiece "$_currentPiece" $_pieceY $_pieceX
    elif [[ "$direction" == "$DOWN" ]]; then
        lockPiece "$_currentPiece" $_pieceY $_pieceX
        newPiece=true
    fi
}

rotatePiece ()
{
    (( $_gameMode == 1 && $_rotation == 3 )) && return

    local                           \
        captureRotation=$_rotation  \
        posX=$_pieceX               \
        posY=$_pieceY

    removePiece "$_currentPiece" $_pieceY $_pieceX
    $_ghostingIsSet && removePiece "$_currentPiece" $_ghostY $_pieceX

    (( _rotation == 3 ? _rotation = 0 : _rotation++ ))

    while true; do
        canRender "$_currentPiece" $posY $posX

        case $? in
            0)      break;;
            1)      (( posX -= 2 ));; # Right wall
            3)      (( posX += 2 ));; # Left wall
            2|4)    _rotation=$captureRotation
                    renderPiece "$_currentPiece" $_pieceY $_pieceX
                    return;; # Floor or another tetromino
        esac
    done

    _pieceX=$posX
    _pieceY=$posY

    $_ghostingIsSet && ghostPiece
    renderPiece "$_currentPiece" $_pieceY $_pieceX
}

dropPiece ()
{
    local nextY=$_pieceY

    removePiece "$_currentPiece" $_pieceY $_pieceX

    while canRender "$_currentPiece" $(( ++nextY )) $_pieceX; do
        _pieceY=$nextY
    done

    renderPiece "$_currentPiece" $_pieceY $_pieceX
    lockPiece "$_currentPiece" $_pieceY $_pieceX
    newPiece=true
    $_loggingIsSet && logInput 'TRANSLATE'
}

logInput ()
{
    case "$1" in
        ('LOAD')      printf '%s' $_currentPiece;;
        ('TRANSLATE') printf '%s' $direction;;
        ('ROTATE')    printf '%s' 'R';;
    esac >> "$INPUT_LOG"
}
