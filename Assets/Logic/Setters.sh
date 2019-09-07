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

toggleRecord()
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

setColours()
{
    case $_colourMode in
        (0) {
            declare -ag -- COLOURS=(
                [0]=$'\e[0m'        # Default
                [1]=$'\e[38;5;43m'  # Cyan
                [2]=$'\e[38;5;27m'  # Blue
                [3]=$'\e[38;5;166m' # Orange
                [4]=$'\e[38;5;178m' # Yellow
                [5]=$'\e[38;5;76m'  # Green
                [6]=$'\e[38;5;128m' # Purple
                [7]=$'\e[38;5;160m' # Red
                [8]=$'\e[0;97m'     # White
            )
        };;
        (1) {
            declare -ag -- COLOURS=(
                [0]=$'\e[0m'        # Default
                [1]=$'\e[38;5;27m'  # Blue
                [2]=$'\e[38;5;128m' # Purple
                [3]=$'\e[38;5;178m' # Yellow
                [4]=$'\e[38;5;76m'  # Green
                [5]=$'\e[38;5;43m'  # Cyan
                [6]=$'\e[38;5;205m' # Pink
                [7]=$'\e[38;5;160m' # Red
                [8]=$'\e[0;97m'     # White
            )
        };;
        (2) {
            declare -ag -- COLOURS=(
                [0]=$'\e[0;97m'   # white
                [1]=$'\e[0;97m'
                [2]=$'\e[0;97m'
                [3]=$'\e[0;97m'
                [4]=$'\e[0;97m'
                [5]=$'\e[0;97m'
                [6]=$'\e[0;97m'
                [7]=$'\e[0;97m'
                [8]=$'\e[0;97m'
            )
        };;
        (3) {
            declare -ag -- COLOURS=(
                [0]=$'\e[38;5;232;47m'   # Inverted white
                [1]=$'\e[38;5;232;47m'
                [2]=$'\e[38;5;232;47m'
                [3]=$'\e[38;5;232;47m'
                [4]=$'\e[38;5;232;47m'
                [5]=$'\e[38;5;232;47m'
                [6]=$'\e[38;5;232;47m'
                [7]=$'\e[38;5;232;47m'
                [8]=$'\e[38;5;232;47m'
            )
        };;
    esac
}
