################################## GENERAL #####################################

declare -rg PS4='+(${LINENO}) ${FUNCNAME[0]}(): '
declare -rg LOG_DIR='/var/games/tetris'
declare -rg HIGHSCORE_LOG="$LOG_DIR/highscores.ths"
declare -rg SETTINGS_LOG="$LOG_DIR/settings.txt"
declare -rg ERROR_LOG="$LOG_DIR/error.log"
declare -rg DEBUG_LOG="$LOG_DIR/debug.log"
declare -rg INPUT_LOG="$LOG_DIR/input.log"
declare -rg UP='A'
declare -rg DOWN='B'
declare -rg RIGHT='C'
declare -rg LEFT='D'
declare -rg CEILING=2
declare -rg FLOOR=23
declare -rg R_WALL=20
declare -rg L_WALL=2
eval declare -arg X_POSITIONS=({$L_WALL..$R_WALL..2})

if (( ${BASH_VERSINFO[0]} == 4 && ${BASH_VERSINFO[1]} < 4 )); then
    declare -rg LEGACY=true
else
    declare -rg LEGACY=false
fi

################################## Screens #####################################

if ! $_inTTY; then
    declare -arg MAIN_SCREEN=(
        '┌────────────────────────────────────────┐'
        '│                                        │'
        '│  █▛██▜█ ██ ▜█ █▛██▜█ ██ █▙  ██  ▟▙ ▜█  │'
        '│  ▛ ██ ▜ ██  ▜ ▛ ██ ▜ ██ ██  ██  ▜█▙ ▜  │'
        '│    ██   ██ █    ██   ██ ▛   ██   ▜█▙   │'
        '│    ██   ██  ▟   ██   ██ ▙   ██  ▙ ▜█▙  │'
        '│    ██   ██ ▟█   ██   ██ █▙  ██  █▙ ▜▛  │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                           © Ben Pitman │'
        '└────────────────────────────────────────┘'
    )
    declare -arg FIELD_SCREEN=(
        '┌────────────────────┬───────────────────┐'
        '│                    │  ╔═════════════╗  │'
        '│                    ├──╢  S C O R E  ╟──┤'
        '│                    │  ╚═════════════╝  │'
        '│                    ╞═══════════════════╡'
        '│                    │             0     │'
        '│                    ╞═══════════════════╡'
        '│                    │                   │'
        '│                    │  ╔═════════════╗  │'
        '│                    │  ║  L E V E L  ║  │'
        '│                    │  ║          0  ║  │'
        '│                    │  ╚═════════════╝  │'
        '│                    │  ╔═════════════╗  │'
        '│                    │  ║  L I N E S  ║  │'
        '│                    │  ║          0  ║  │'
        '│                    │  ╚═════════════╝  │'
        '│                    │                   │'
        '│                    │  ╔══════════╗     │'
        '│                    │  ║          ║     │'
        '│                    │  ║          ║     │'
        '│                    │  ║          ║     │'
        '│                    │  ║          ║     │'
        '│                    │  ╚══════════╝     │'
        '└────────────────────┴───────────────────┘'
    )
    declare -arg SCORES_SCREEN=(
        '┌────────────────────────────────────────┐'
        '│            ╔═════════════╗             │'
        '├────────────╢ S C O R E S ╟─────────────┤'
        '│            ╚═════════════╝             │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '└────────────────────────────────────────┘'
    )
    declare -arg SETTINGS_SCREEN=(
        '┌────────────────────────────────────────┐'
        '│          ╔═════════════════╗           │'
        '├──────────╢ S E T T I N G S ╟───────────┤'
        '│          ╚═════════════════╝           │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                      ┌──────────────┐  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      └──────────────┘  │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '└────────────────────────────────────────┘'
    )
else
    declare -arg MAIN_SCREEN=(
        '┌────────────────────────────────────────┐'
        '│                                        │'
        '│  ██████ █████ ██████ █████  ██  █████  │'
        '│    ██   ██      ██   ██  ██ ██ ██      │'
        '│    ██   ████    ██   ████   ██   ██    │'
        '│    ██   ██      ██   ██  ██ ██     ██  │'
        '│    ██   █████   ██   ██  ██ ██ █████   │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                           © Ben Pitman │'
        '└────────────────────────────────────────┘'
    )
    declare -arg FIELD_SCREEN=(
        '┌────────────────────┬───────────────────┐'
        '│                    │  ┌─────────────┐  │'
        '│                    ├──┤  S C O R E  ├──┤'
        '│                    │  └─────────────┘  │'
        '│                    ├───────────────────┤'
        '│                    │             0     │'
        '│                    ├───────────────────┤'
        '│                    │                   │'
        '│                    │  ┌─────────────┐  │'
        '│                    │  │  L E V E L  │  │'
        '│                    │  │          0  │  │'
        '│                    │  └─────────────┘  │'
        '│                    │  ┌─────────────┐  │'
        '│                    │  │  L I N E S  │  │'
        '│                    │  │          0  │  │'
        '│                    │  └─────────────┘  │'
        '│                    │                   │'
        '│                    │  ┌──────────┐     │'
        '│                    │  │          │     │'
        '│                    │  │          │     │'
        '│                    │  │          │     │'
        '│                    │  │          │     │'
        '│                    │  └──────────┘     │'
        '└────────────────────┴───────────────────┘'
    )
    declare -arg SCORES_SCREEN=(
        '┌────────────────────────────────────────┐'
        '│            ┌─────────────┐             │'
        '├────────────┤ S C O R E S ├─────────────┤'
        '│            └─────────────┘             │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '└────────────────────────────────────────┘'
    )
    declare -arg SETTINGS_SCREEN=(
        '┌────────────────────────────────────────┐'
        '│          ┌─────────────────┐           │'
        '├──────────┤ S E T T I N G S ├───────────┤'
        '│          └─────────────────┘           │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '│                      ┌──────────────┐  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      │              │  │'
        '│                      └──────────────┘  │'
        '│                                        │'
        '│                                        │'
        '│                                        │'
        '└────────────────────────────────────────┘'
    )
fi

############################## States and Modes ################################

setColourMode()
{
    _colourMode=${COLOUR_MODES[$1]}
}

setGameMode()
{
    _gameMode=${GAME_MODES[$1]}
}

toggleGhosting()
{
    ghostingIsOn && _ghosting=${GHOST_MODES[1]} || _ghosting=${GHOST_MODES[0]}
}

ghostingIsOn()
{
    [[ "$_ghosting" == 'ACTIVE' ]] && true || false
}

loggingIsOn()
{
    [[ "$_logging" == 'ACTIVE' ]] && true || false
}

toggleLogging()
{
    loggingIsOn && _logging=${LOG_MODES[1]} || _logging=${LOG_MODES[0]}
}

declare -Arg STATES=(
    ['MAIN']=0
    ['FIELD']=1
    ['SCORES']=2
    ['SETTINGS']=3
    ['GAME_OVER']=4
)

setState()
{
    _state=${STATES[$1]}
}

############################### Menu Navigation ################################

declare -rg START_POSITION='2,8'

declare -arg MAIN_OPTIONS=(
    'N E W   G A M E'
    'S C O R E S'
    'S E T T I N G S'
    'Q U I T'
)

declare -Arg MAIN_MENU=(
    ['MAX']=3
    ['OPTIONS']='MAIN_OPTIONS'
    ['PADDING']=' '

    ['0,Y']=11
    ['0,X']=12

    ['1,Y']=14
    ['1,X']=14

    ['2,Y']=17
    ['2,X']=12

    ['3,Y']=20
    ['3,X']=16
)

declare -arg SETTINGS_OPTIONS=(
    'COLOUR  MODE'
    'GAME  MODE'
    'GHOSTING'
    'RECORD'
    'BACK'
)

# Settings menu options
declare -Arg SETTINGS_MENU=(
    ['MAX']=4
    ['OPTIONS']='SETTINGS_OPTIONS'
    ['PADDING']=' '

    ['0,Y']=10
    ['0,X']=5

    ['1,Y']=12
    ['1,X']=6

    ['2,Y']=14
    ['2,X']=7
    ['2,NOTE']='(Can cause flicker)'

    ['3,Y']=16
    ['3,X']=8
    ['3,NOTE']='All inputs logged for playback'

    ['4,Y']=22
    ['4,X']=9
)

# Opens up the submenu for selection
declare -Arg SETTINGS_CLEAR_SUB_MENU=(
    ['MAX']=11

    ['Y']=9
    ['X']=25

     ['0']='┌────────────┐'
     ['1']='│            │'
     ['2']='│            │'
     ['3']='│            │'
     ['4']='│            │'
     ['5']='│            │'
     ['6']='│            │'
     ['7']='│            │'
     ['8']='│            │'
     ['9']='│            │'
    ['10']='└────────────┘'
)

# Clears the chosen items for repopulation
declare -Arg SETTINGS_SUB_MENU=(
    ['MAX']=3
    ['WIDTH']=11

    ['0']='_colourMode'
    ['0,Y']=10
    ['0,X']=26

    ['1']='_gameMode'
    ['1,Y']=12
    ['1,X']=26

    ['2']='_ghosting'
    ['2,Y']=14
    ['2,X']=26

    ['3']='_logging'
    ['3,Y']=16
    ['3,X']=26

    ['CLEAR']='              '
    ['CLEAR,Y']=9
    ['CLEAR,X']=25
    ['CLEAR,MAX']=11
)

declare -Arg NOTE=(
    ['CLEAR']='                                        '
    ['Y']=6
    ['X']=22
)

declare -arg COLOUR_MODES=(
    'NORMAL'
    'SIMPLE'
    'SHADOW'
    'BLEACH'
)

# Settings colour mode submenu options
declare -Arg SETTINGS_COLOUR_SUB_MENU=(
    ['MAX']=3
    ['OPTIONS']='COLOUR_MODES'
    ['PADDING']='  '

    ['0,Y']=11
    ['0,X']=27
    ['0,NOTE']="Original Tetris colours"

    ['1,Y']=13
    ['1,X']=27
    ['1,NOTE']="Reduced colours for lower colour depth"

    ['2,Y']=15
    ['2,X']=27
    ['2,NOTE']="White on black"

    ['3,Y']=17
    ['3,X']=27
    ['3,NOTE']="Black on white"
)

declare -arg GAME_MODES=(
    'NORMAL'
    'ROTATE'
    'FORGET'    # May not be implemented
)

declare -Arg SETTINGS_GAME_SUB_MENU=(
    ['MAX']=1
    ['OPTIONS']='GAME_MODES'
    ['PADDING']='  '

    ['0,Y']=11
    ['0,X']=27
    ['0,NOTE']="It's just Tetris"

    ['1,Y']=13
    ['1,X']=27
    ['1,NOTE']="Limited to 3 rotations per tetromino"

    ['2,Y']=17
    ['2,X']=27
    ['2,NOTE']="Placed tetrominoes fade out over time"
)

declare -arg GHOST_MODES=(
    'ACTIVE'
    'INACTIVE'
)

declare -arg LOG_MODES=(
    'ACTIVE'
    'INACTIVE'
)

declare -arg SCORES_OPTIONS=(
    'BACK'
)

declare -Arg SCORES_MENU=(
    ['MAX']=0
    ['OPTIONS']='SCORES_OPTIONS'
    ['PADDING']=' '

    ['0,Y']=22
    ['0,X']=18
)

declare -Arg SCORES=(
    ['MAX']=13
    ['WIDTH']=30

    ['Y']=7
    ['X']=7
)

declare -Arg FIELD_OPTIONS=(
    ['SCORE,X']=28
    ['SCORE,Y']=6
    ['SCORE,WIDTH']=9

    ['LEVEL,X']=28
    ['LEVEL,Y']=11
    ['LEVEL,WIDTH']=9

    ['LINES,X']=28
    ['LINES,Y']=15
    ['LINES,WIDTH']=9

    ['ALERT,PAUSED']='P A U S E D'
    ['ALERT,SINGLE']='S I N G L E'
    ['ALERT,DOUBLE']='D O U B L E'
    ['ALERT,TRIPLE']='T R I P L E'
    ['ALERT,TETRIS']='T E T R I S'
    ['ALERT,GAME_OVER']='GAME   OVER'
    ['ALERT,END_REPLAY']='END  REPLAY'
    ['ALERT,CLEAR']='           '
    ['ALERT,X']=27
    ['ALERT,Y']=8
)

declare -Arg NEXT_PIECE=(
    ['R,X']=26  # Reset
    ['R,Y']=19

    ['I,X']=27
    ['I,Y']=19

    ['J,X']=28
    ['J,Y']=20

    ['L,X']=28
    ['L,Y']=20

    ['O,X']=29
    ['O,Y']=20

    ['S,X']=28
    ['S,Y']=20

    ['T,X']=28
    ['T,Y']=20

    ['Z,X']=28
    ['Z,Y']=20
)

################################ Tetrominoes ###################################

declare -rg BLANK='\u0020\u0020'
declare -rg GHOST='\u2592\u2592'
declare -rg BLOCK='\u2588\u2588'

setColours()
{
    case $_colourMode in
        'NORMAL')
            declare -ag COLOURS=(
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
        ;;
        'SIMPLE')
            declare -ag COLOURS=(
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
        ;;
        'SHADOW')
            declare -ag COLOURS=(
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
        ;;
        'BLEACH')
            declare -ag COLOURS=(
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
        ;;
    esac
}

declare -Arg COLOURS_LOOKUP=(
    [R]=0   # Reset
    [I]=1
    [J]=2
    [L]=3
    [O]=4
    [S]=5
    [T]=6
    [Z]=7
    [W]=8   # White
)

declare -arg PIECES=( 'I' 'J' 'L' 'O' 'S' 'T' 'Z' )

declare -arg I=(
    '0,1 1,1 2,1 3,1'
    '2,0 2,1 2,2 2,3'
    '0,2 1,2 2,2 3,2'
    '1,0 1,1 1,2 1,3'
)

declare -arg J=(
    '0,0 0,1 1,1 2,1'
    '1,0 2,0 1,1 1,2'
    '0,1 1,1 2,1 2,2'
    '1,0 1,1 0,2 1,2'
)

declare -arg L=(
    '2,0 0,1 1,1 2,1'
    '1,0 1,1 1,2 2,2'
    '0,1 1,1 2,1 0,2'
    '0,0 1,0 1,1 1,2'
)

declare -arg O=(
    '0,0 1,0 0,1 1,1'
    '0,0 1,0 0,1 1,1'
    '0,0 1,0 0,1 1,1'
    '0,0 1,0 0,1 1,1'
)

declare -arg S=(
    '1,0 2,0 0,1 1,1'
    '1,0 1,1 2,1 2,2'
    '1,1 2,1 0,2 1,2'
    '0,0 0,1 1,1 1,2'
)

declare -arg T=(
    '1,0 0,1 1,1 2,1'
    '1,0 0,1 1,1 1,2'
    '0,1 1,1 2,1 1,2'
    '1,0 1,1 2,1 1,2'
)

declare -arg Z=(
    '0,0 1,0 1,1 2,1'
    '2,0 1,1 2,1 1,2'
    '0,1 1,1 1,2 2,2'
    '1,0 0,1 1,1 0,2'
)
