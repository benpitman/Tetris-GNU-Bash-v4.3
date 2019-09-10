#################################### STATES ####################################

setMainState ()
{
    setState 0
}

setFieldState ()
{
    setState 1
}

setScoresState ()
{
    setState 2
}

setSettingsState ()
{
    setState 3
}

setConstantsState ()
{
    setState 4
}

setAboutState ()
{
    setState 5
}

setState ()
{
    _state=$1
}

#################################### OTHER #####################################

setGameMode ()
{
    _gameMode=$1
}

setReplayMode ()
{
    _replay=1
    _replayInputs=( $( fold -b1 "$1" ) )

    _gameBooleans=(
        ["hold"]=1
        ["next"]=1
        ["ghost"]=1
        ["record"]=1
        ["memory"]=1
        ["rotate"]=1
    )
}

################################### TOGGLES ####################################

toggleNext ()
{
    toggleBoolean "next"
}

toggleHold ()
{
    return
    # toggleBoolean "hold"
}

toggleGhost ()
{
    toggleBoolean "ghost"
}

toggleRecord ()
{
    toggleBoolean "record"
}

toggleRotate ()
{
    toggleBoolean "rotate"
}

toggleMemory ()
{
    return
    # toggleBoolean "memory"
}

toggleBoolean ()
{
    (( _gameBooleans[$1] ^= 1 ))
}

################################### COLOURS ####################################

setNormalColourMode ()
{
    setColourMode 0
}

setSimpleColourMode ()
{
    setColourMode 1
}

setShadowColourMode ()
{
    setColourMode 3
}

setBleachColourMode ()
{
    setColourMode 2
}

setColourMode ()
{
    _colourMode=$1
}

setColours ()
{
    case $_colourMode in
        (0) {
            declare -Ag -- COLOURS_LOOKUP=(
                [R]=0 # Reset
                [I]=2
                [J]=1
                [L]=7
                [O]=5
                [S]=3
                [T]=4
                [Z]=6
                [W]=9 # White
            )
        };;
        (1) {
            declare -Ag -- COLOURS_LOOKUP=(
                [R]=0 # Reset
                [I]=1
                [J]=4
                [L]=5
                [O]=3
                [S]=2
                [T]=8
                [Z]=7
                [W]=9 # White
            )
        };;
        (2) {
            declare -Ag -- COLOURS_LOOKUP=(
                [R]=0 # Reset
                [I]=9
                [J]=9
                [L]=9
                [O]=9
                [S]=9
                [T]=9
                [Z]=9
                [W]=9 # White
            )
        };;
        (3) {
            declare -Ag -- COLOURS_LOOKUP=(
                [R]=0 # Reset
                [I]=10
                [J]=10
                [L]=10
                [O]=10
                [S]=10
                [T]=10
                [Z]=10
                [W]=10 # White
            )
        };;
    esac
}
