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

toggleUI ()
{
    toggleBoolean "unicode"
    loadScreens
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
    loadScreens
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
                [R]=10 # Reset
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
                [R]=9 # Reset
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

################################## Screens #####################################

setNormalUI ()
{
    declare -ag -- MAIN_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│                                        │"
        "│  █▛██▜█ ██ ▜█ █▛██▜█ ██ █▙  ██  ▟▙ ▜█  │"
        "│  ▛ ██ ▜ ██  ▜ ▛ ██ ▜ ██ ██  ██  ▜█▙ ▜  │"
        "│    ██   ██ █    ██   ██ ▛   ██   ▜█▙   │"
        "│    ██   ██  ▟   ██   ██ ▙   ██  ▙ ▜█▙  │"
        "│    ██   ██ ▟█   ██   ██ █▙  ██  █▙ ▜▛  │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                           © Ben Pitman │"
        "└────────────────────────────────────────┘"
    )
    if holdEnabled; then
        declare -ag -- FIELD_SCREEN=(
            "┌────────────────────┬───────────────────┐"
            "│                    │  ┌─────────────╖  │"
            "│                    │  │  S C O R E  ║  │"
            "│                    │  │          0  ║  │"
            "│                    │  ├─────────────╢  │"
            "│                    │  │  L E V E L  ║  │"
            "│                    │  │          0  ║  │"
            "│                    │  ├─────────────╢  │"
            "│                    │  │  L I N E S  ║  │"
            "│                    │  │          0  ║  │"
            "│                    │  ╘═════════════╝  │"
            "│                    │  ┌──────────╖     │"
            "│                    │  │          ║ H   │"
            "│                    │  │          ║ O   │"
            "│                    │  │          ║ L   │"
            "│                    │  │          ║ D   │"
            "│                    │  ╘══════════╝     │"
            "│                    │  ┌──────────╖     │"
            "│                    │  │          ║ N   │"
            "│                    │  │          ║ E   │"
            "│                    │  │          ║ X   │"
            "│                    │  │          ║ T   │"
            "│                    │  ╘══════════╝     │"
            "└────────────────────┴───────────────────┘"
        )
    else
        declare -ag -- FIELD_SCREEN=(
            "┌────────────────────┬───────────────────┐"
            "│                    │  ┌─────────────╖  │"
            "│                    ├──┤  S C O R E  ╟──┤"
            "│                    │  ╘═════════════╝  │"
            "│                    ├───────────────────┤"
            "│                    │             0     │"
            "│                    ├───────────────────┤"
            "│                    │                   │"
            "│                    │  ┌─────────────╖  │"
            "│                    │  │  L E V E L  ║  │"
            "│                    │  │          0  ║  │"
            "│                    │  ╘═════════════╝  │"
            "│                    │  ┌─────────────╖  │"
            "│                    │  │  L I N E S  ║  │"
            "│                    │  │          0  ║  │"
            "│                    │  ╘═════════════╝  │"
            "│                    │                   │"
            "│                    │  ┌──────────╖     │"
            "│                    │  │          ║ N   │"
            "│                    │  │          ║ E   │"
            "│                    │  │          ║ X   │"
            "│                    │  │          ║ T   │"
            "│                    │  ╘══════════╝     │"
            "└────────────────────┴───────────────────┘"
        )
    fi
    declare -ag -- SCORES_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│            ┌─────────────╖             │"
        "├────────────┤ S C O R E S ╟─────────────┤"
        "│            ╘═════════════╝             │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "└────────────────────────────────────────┘"
    )
    declare -ag -- SETTINGS_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│          ┌─────────────────╖           │"
        "├──────────┤ S E T T I N G S ╟───────────┤"
        "│          ╘═════════════════╝           │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "└────────────────────────────────────────┘"
    )
    declare -ag -- CONSTANTS_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│         ┌───────────────────╖          │"
        "├─────────┤ C O N S T A N T S ╟──────────┤"
        "│         ╘═══════════════════╝          │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "└────────────────────────────────────────┘"
    )
    declare -ag -- ABOUT_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│             ┌───────────╖              │"
        "├─────────────┤ A B O U T ╟──────────────┤"
        "│             ╘═══════════╝              │"
        "│                                        │"
        "│    There's not much to say really.     │"
        "│                                        │"
        "│   Bash has always been my favourite    │"
        "│   language since I was taught it in    │"
        "│   college, and now any chance I get    │"
        "│   to build a new program, no matter    │"
        "│   how complex it may seem, I always    │"
        "│   attempt it in Bash first. Most of    │"
        "│   the time it takes months but that    │"
        "│   does not bother me, and even with    │"
        "│   all its flaws and eccentricities,    │"
        "│   to me it will endlessly intrigue.    │"
        "│                                        │"
        "│   That is why I made Tetris in Bash    │"
        "│                                        │"
        "│                                     /\ │"
        "│   Check out my GitHub at        o--'0 \`│"
        "│   https://github.com/benpitman   \`--.  │"
        "└────────────────────────────────────────┘"
    )
}

setSimpleUI ()
{
    declare -ag -- MAIN_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│                                        │"
        "│  ██████ █████ ██████ █████  ██  █████  │"
        "│    ██   ██      ██   ██  ██ ██ ██      │"
        "│    ██   ████    ██   ████   ██   ██    │"
        "│    ██   ██      ██   ██  ██ ██     ██  │"
        "│    ██   █████   ██   ██  ██ ██ █████   │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                           © Ben Pitman │"
        "└────────────────────────────────────────┘"
    )
    if holdEnabled; then
        declare -ag -- FIELD_SCREEN=(
            "┌────────────────────┬───────────────────┐"
            "│                    │  ┌─────────────┐  │"
            "│                    │  │  S C O R E  │  │"
            "│                    │  │          0  │  │"
            "│                    │  ├─────────────┤  │"
            "│                    │  │  L E V E L  │  │"
            "│                    │  │          0  │  │"
            "│                    │  ├─────────────┤  │"
            "│                    │  │  L I N E S  │  │"
            "│                    │  │          0  │  │"
            "│                    │  └─────────────┘  │"
            "│                    │  ┌──────────┐     │"
            "│                    │  │          │ H   │"
            "│                    │  │          │ O   │"
            "│                    │  │          │ L   │"
            "│                    │  │          │ D   │"
            "│                    │  └──────────┘     │"
            "│                    │  ┌──────────┐     │"
            "│                    │  │          │ N   │"
            "│                    │  │          │ E   │"
            "│                    │  │          │ X   │"
            "│                    │  │          │ T   │"
            "│                    │  └──────────┘     │"
            "└────────────────────┴───────────────────┘"
        )
    else
        declare -ag -- FIELD_SCREEN=(
            "┌────────────────────┬───────────────────┐"
            "│                    │  ┌─────────────┐  │"
            "│                    ├──┤  S C O R E  ├──┤"
            "│                    │  └─────────────┘  │"
            "│                    ├───────────────────┤"
            "│                    │             0     │"
            "│                    ├───────────────────┤"
            "│                    │                   │"
            "│                    │  ┌─────────────┐  │"
            "│                    │  │  L E V E L  │  │"
            "│                    │  │          0  │  │"
            "│                    │  └─────────────┘  │"
            "│                    │  ┌─────────────┐  │"
            "│                    │  │  L I N E S  │  │"
            "│                    │  │          0  │  │"
            "│                    │  └─────────────┘  │"
            "│                    │                   │"
            "│                    │  ┌──────────┐     │"
            "│                    │  │          │ N   │"
            "│                    │  │          │ E   │"
            "│                    │  │          │ X   │"
            "│                    │  │          │ T   │"
            "│                    │  └──────────┘     │"
            "└────────────────────┴───────────────────┘"
        )
    fi
    declare -ag -- SCORES_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│            ┌─────────────┐             │"
        "├────────────┤ S C O R E S ├─────────────┤"
        "│            └─────────────┘             │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "└────────────────────────────────────────┘"
    )
    declare -ag -- SETTINGS_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│          ┌─────────────────┐           │"
        "├──────────┤ S E T T I N G S ├───────────┤"
        "│          └─────────────────┘           │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "└────────────────────────────────────────┘"
    )
    declare -ag -- CONSTANTS_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│         ┌───────────────────┐          │"
        "├─────────┤ C O N S T A N T S ├──────────┤"
        "│         └───────────────────┘          │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "│                                        │"
        "└────────────────────────────────────────┘"
    )
    declare -ag -- ABOUT_SCREEN=(
        "┌────────────────────────────────────────┐"
        "│             ┌───────────┐              │"
        "├─────────────┤ A B O U T ├──────────────┤"
        "│             └───────────┘              │"
        "│                                        │"
        "│    There's not much to say really.     │"
        "│                                        │"
        "│   Bash has always been my favourite    │"
        "│   language since I was taught it in    │"
        "│   college, and now any chance I get    │"
        "│   to build a new program, no matter    │"
        "│   how complex it may seem, I always    │"
        "│   attempt it in Bash first. Most of    │"
        "│   the time it takes months but that    │"
        "│   does not bother me, and even with    │"
        "│   all its flaws and eccentricities,    │"
        "│   to me it will endlessly intrigue.    │"
        "│                                        │"
        "│   That is why I made Tetris in Bash    │"
        "│                                        │"
        "│                                     /\ │"
        "│   Check out my GitHub at        o--'0 \`│"
        "│   https://github.com/benpitman   \`--.  │"
        "└────────────────────────────────────────┘"
    )
}
