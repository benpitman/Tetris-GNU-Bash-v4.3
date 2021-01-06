declare -g -- _alertTimeout=0
declare -g -- _currentPiece=
declare -g -- _debug=${1:-0}
declare -g -- _direction=
declare -g -- _ghostY=
declare -g -- _level=
declare -g -- _lines=
declare -g -- _lockID= #Unused currently, was for fading pieces
declare -g -- _newPiece=1
declare -g -- _nextPiece=
declare -g -- _pieceX=
declare -g -- _pieceY=
declare -g -- _replay=0
declare -g -- _replayIndex=
declare -g -- _rotation=
declare -g -- _score=0
declare -g -- _state=0

declare -g -- _gameMode=0
declare -g -- _colourMode=

declare -ag -- _replayInputs=()

declare -Ag -- _lock=()

declare -Ag _selected=(
    ["main"]=0
    ["settings"]=0
    ["constants"]=0
)

# zero is true for these because they are exit statuses
declare -Ag -- _gameBooleans=(
    ["hold"]=0
    ["next"]=0
    ["ghost"]=0
    ["record"]=0
    ["memory"]=1
    ["rotate"]=1
)

declare -Ag -- _gameModes=(
    ["difficulty"]=0
    ["colour"]=0
)
