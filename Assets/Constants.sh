#################################### Logs ######################################

declare -rg PS4='+(${LINENO}) ${FUNCNAME[0]}(): '
declare -rg LOG_DIR='/var/games/tetris'
declare -rg HIGHSCORE_LOG="$LOG_DIR/highscores.ths"
declare -rg SETTINGS_LOG="$LOG_DIR/settings.txt"
declare -rg ERROR_LOG="$LOG_DIR/error.log"
declare -rg DEBUG_LOG="$LOG_DIR/debug.log"

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

############################### Menu Navigation ################################

declare -rg START_POSITION='2,8'
declare -arg COLOUR_MODES=(
    'NORMAL'
    'SIMPLE'
    'NOIR'
    'BLEACH'
)
declare -arg GAME_MODES=(
    'NORMAL'
)

declare -Arg MAIN_OPTIONS=(
    ['max']=3

    ['0']=' N E W   G A M E '
    ['0,y']=11
    ['0,x']=13

    ['1']=' S C O R E S '
    ['1,y']=14
    ['1,x']=15

    ['2']=' S E T T I N G S '
    ['2,y']=17
    ['2,x']=13

    ['3']=' Q U I T '
    ['3,y']=20
    ['3,x']=17
)

# Settings menu options
declare -Arg SETTINGS_OPTIONS=(
    ['max']=2

    ['0']=' COLOUR  MODE '
    ['0,y']=10
    ['0,x']=6

    ['1']=' GAME  MODE '
    ['1,y']=12
    ['1,x']=7

    ['2']=' BACK '
    ['2,y']=22
    ['2,x']=10
)

# Opens up the submenu for selection
declare -Arg SETTINGS_CLEAR_SUB_MENU=(
    ['max']=11

    ['y']=9
    ['x']=25

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
    ['max']=0
    ['width']=11

    ['0']='_colourMode'
    ['0,y']=10
    ['0,x']=26

    ['clear']='              '
    ['clear,y']=9
    ['clear,x']=25
    ['clear,max']=11
)

# Settings colour mode submenu options
declare -Arg SETTINGS_COLOUR_SUB_OPTIONS=(
    ['max']=3

    ['0']='  NORMAL  '
    ['0,y']=11
    ['0,x']=27

    ['1']='  SIMPLE  '
    ['1,y']=13
    ['1,x']=27

    ['2']='   NOIR   '
    ['2,y']=15
    ['2,x']=27

    ['3']='  BLEACH  '
    ['3,y']=17
    ['3,x']=27
)

declare -Arg SETTINGS_GAME_SUB_OPTIONS=(
    ['max']=1

    ['0']='  NORMAL  '
    ['0,y']=11
    ['0,x']=27
)

declare -Arg FIELD_OPTIONS=(
    ['score,x']=28
    ['score,y']=6
    ['score,length']=9

    ['level,x']=28
    ['level,y']=11
    ['level,length']=9

    ['lines,x']=28
    ['lines,y']=15
    ['lines,length']=9

    ['pause']='P A U S E'
    ['pause,x']=28
    ['pause,y']=8
)

declare -Arg NEXT_PIECE=(
    ['R,x']=26  # Reset
    ['R,y']=19

    ['I,x']=27
    ['I,y']=19

    ['J,x']=28
    ['J,y']=20

    ['L,x']=28
    ['L,y']=20

    ['O,x']=29
    ['O,y']=20

    ['S,x']=28
    ['S,y']=20

    ['T,x']=28
    ['T,y']=20

    ['Z,x']=28
    ['Z,y']=20
)

################################ Tetrominoes ###################################

declare -rg BLANK='\u0020\u0020'
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
        'NOIR')
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
