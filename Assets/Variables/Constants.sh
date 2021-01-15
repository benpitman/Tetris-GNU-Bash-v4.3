################################## GENERAL #####################################

declare -rg -- LOG_DIR="${HOME}/.config/tetris"
declare -rg -- REPLAY_DIR="${LOG_DIR}/replays"

declare -rg -- PS4='+(${LINENO}) ${FUNCNAME[0]}(): '
declare -rg -- BASH_XTRACEFD=5 2>/dev/null

declare -rg -- HIGHSCORE_LOG="$LOG_DIR/highscores.ths"
declare -rg -- SETTINGS="$LOG_DIR/settings.txt"
declare -rg -- ERROR_LOG="$LOG_DIR/error.log"
declare -rg -- DEBUG_LOG="$LOG_DIR/debug.log"
declare -rg -- INPUT_LOG="$LOG_DIR/input.log"

declare -rg -- KEY_UP="A"
declare -rg -- KEY_DOWN="B"
declare -rg -- KEY_RIGHT="C"
declare -rg -- KEY_LEFT="D"
declare -rg -- KEY_SELECT='(^$| )'
declare -rg -- KEY_PAUSE="[Pp]"

declare -rg -- CEILING=2
declare -rg -- FLOOR=23
declare -rg -- RIGHT_WALL=20
declare -rg -- LEFT_WALL=2

declare -rg -- BLANK="\u0020\u0020"
declare -rg -- GHOST="\u2592\u2592"
declare -rg -- BLOCK="\u2588\u2588"

declare -arg -- X_POSITIONS=({2..20..2})

if (( ${BASH_VERSINFO[0]} == 4 && ${BASH_VERSINFO[1]} < 4 )); then
    declare -rg -- LEGACY=1
else
    declare -rg -- LEGACY=0
fi

if [[ -s "$SETTINGS" ]] && (( $_replay == 0 )); then
    source "$SETTINGS"
fi

############################### Menu Navigation ################################

declare -rg -- START_Y=2
declare -rg -- START_X=8

declare -Arg -- MAIN_MENU=(
    ["MAX"]=4
    ["PADDING"]=" "

    ["0,Y"]=11
    ["0,X"]=12
    ["0,TEXT"]="N E W   G A M E"
    ["0,RUN"]="setFieldState"

    ["1,Y"]=13
    ["1,X"]=14
    ["1,TEXT"]="S C O R E S"
    ["1,RUN"]="setScoresState"

    ["2,Y"]=15
    ["2,X"]=12
    ["2,TEXT"]="S E T T I N G S"
    ["2,RUN"]="setSettingsState"

    ["3,Y"]=17
    ["3,X"]=15
    ["3,TEXT"]="A B O U T"
    ["3,RUN"]="setAboutState"

    ["4,Y"]=19
    ["4,X"]=16
    ["4,TEXT"]="Q U I T"
    ["4,RUN"]="die"
)

declare -Arg -- ABOUT_MENU=(
    ["MAX"]=0

    ["0,Y"]=0
    ["0,X"]=0
    ["0,RUN"]="setMainState"
)

# Settings menu options
declare -Arg -- SETTINGS_MENU=(
    ["MAX"]=3
    ["PADDING"]=" "

    ["0,Y"]=10
    ["0,X"]=5
    ["0,TEXT"]="COLOUR MODE"

    ["1,Y"]=12
    ["1,X"]=5
    ["1,TEXT"]="GAME MODE"

    ["2,Y"]=14
    ["2,X"]=5
    ["2,TEXT"]="CONSTANTS"
    ["2,RUN"]="setConstantsState"

    ["3,Y"]=22
    ["3,X"]=5
    ["3,TEXT"]="BACK"
    ["3,RUN"]="setMainState"
)

# Opens up the submenu for selection
declare -Arg -- SETTINGS_CLEAR_SUB_MENU=(
    ["MAX"]=11

    ["Y"]=8
    ["X"]=25

     ["0"]="┌────────────┐"
     ["1"]="│            │"
     ["2"]="│            │"
     ["3"]="│            │"
     ["4"]="│            │"
     ["5"]="│            │"
     ["6"]="│            │"
     ["7"]="│            │"
     ["8"]="│            │"
     ["9"]="│            │"
    ["10"]="└────────────┘"
)

# Clears the chosen items for repopulation
declare -Arg -- SETTINGS_SUB_MENU=(
    ["MAX"]=2
    ["WIDTH"]=11

    ["0,Y"]=10
    ["0,X"]=26
    ["0,LOAD"]="getReadableColourMode"

    ["1,Y"]=12
    ["1,X"]=26
    ["1,LOAD"]="getReadableGameMode"

    ["2,Y"]=14
    ["2,X"]=25
    ["2,TEXT"]="CUSTOMISE"

    ["CLEAR"]="              "
    ["CLEAR,Y"]=9
    ["CLEAR,X"]=25
    ["CLEAR,MAX"]=11
)

declare -Arg -- NOTE=(
    ["CLEAR"]="                                        "
    ["Y"]=6
    ["X"]=22
)

# Settings colour mode submenu options
declare -Arg -- SETTINGS_COLOUR_SUB_MENU=(
    ["MAX"]=3
    ["PADDING"]="  "

    ["0,Y"]=10
    ["0,X"]=27
    ["0,TEXT"]="NORMAL"
    ["0,NOTE"]="Original Tetris colours"
    ["0,RUN"]="setNormalColourMode"

    ["1,Y"]=12
    ["1,X"]=27
    ["1,TEXT"]="SIMPLE"
    ["1,NOTE"]="Reduced colours for lower colour depth"
    ["1,RUN"]="setSimpleColourMode"

    ["2,Y"]=14
    ["2,X"]=27
    ["2,TEXT"]="SHADOW"
    ["2,NOTE"]="White on black"
    ["2,RUN"]="setShadowColourMode"

    ["3,Y"]=16
    ["3,X"]=27
    ["3,TEXT"]="BLEACH"
    ["3,NOTE"]="Black on white"
    ["3,RUN"]="setBleachColourMode"
)

declare -Arg -- SETTINGS_GAME_SUB_MENU=(
    ["MAX"]=0
    ["PADDING"]="  "

    ["0,Y"]=11
    ["0,X"]=27
    ["0,NOTE"]="It's just Tetris"
    ["0,TEXT"]="NORMAL"

    ["1,Y"]=13
    ["1,X"]=27
    ["1,TEXT"]=" HARD "
    # Dunno yet
)

# Settings menu options
declare -Arg -- CONSTANTS_MENU=(
    ["MAX"]=7
    ["PADDING"]=" "

    ["0,Y"]=9
    ["0,X"]=5
    ["0,TEXT"]="SHOW NEXT"
    ["0,RUN"]="toggleNext"

    ["1,Y"]=10
    ["1,X"]=5
    ["1,NOTE"]="In development"
    ["1,TEXT"]="SHOW HOLD"
    ["1,RUN"]="toggleHold"

    ["2,Y"]=11
    ["2,X"]=5
    ["2,NOTE"]="(Can cause flicker)"
    ["2,TEXT"]="GHOST"
    ["2,RUN"]="toggleGhost"

    ["3,Y"]=12
    ["3,X"]=5
    ["3,NOTE"]="All inputs logged for playback"
    ["3,TEXT"]="RECORD INPUTS"
    ["3,RUN"]="toggleRecord"

    ["4,Y"]=13
    ["4,X"]=5
    ["4,NOTE"]="Choose your rotations wisely"
    ["4,TEXT"]="ROTATE THRICE"
    ["4,RUN"]="toggleRotate"

    ["5,Y"]=14
    ["5,X"]=5
    ["5,NOTE"]="In development"
    ["5,TEXT"]="MEMORY GAME"
    ["5,RUN"]="toggleMemory"

    ["6,Y"]=15
    ["6,X"]=5
    ["6,NOTE"]="UI available for no unicode support"
    ["6,TEXT"]="INTERFACE"
    ["6,RUN"]="toggleUI"

    ["7,Y"]=22
    ["7,X"]=5
    ["7,TEXT"]="BACK"
    ["7,RUN"]="setSettingsState"
)

declare -Arg -- CONSTANTS_SUB_MENU=(
    ["MAX"]=6
    ["WIDTH"]=11

    ["0,Y"]=9
    ["0,X"]=26
    ["0,LOAD"]="getReadableNext"

    ["1,Y"]=10
    ["1,X"]=26
    ["1,LOAD"]="getReadableHold"

    ["2,Y"]=11
    ["2,X"]=26
    ["2,LOAD"]="getReadableGhost"

    ["3,Y"]=12
    ["3,X"]=26
    ["3,LOAD"]="getReadableRecord"

    ["4,Y"]=13
    ["4,X"]=26
    ["4,LOAD"]="getReadableRotate"

    ["5,Y"]=14
    ["5,X"]=26
    ["5,LOAD"]="getReadableMemory"

    ["6,Y"]=15
    ["6,X"]=26
    ["6,LOAD"]="getReadableUI"

    ["CLEAR"]="              "
    ["CLEAR,Y"]=9
    ["CLEAR,X"]=25
    ["CLEAR,MAX"]=11
)

declare -Arg -- SCORES_MENU=(
    ["MAX"]=0
    ["PADDING"]=" "

    ["0,Y"]=22
    ["0,X"]=18
    ["0,TEXT"]="BACK"
    ["0,RUN"]="setMainState"
)

declare -Arg -- SCORES=(
    ["MAX"]=13
    ["WIDTH"]=30

    ["Y"]=7
    ["X"]=7
)

declare -Arg -- FIELD_OPTIONS=(
    ["SCORE,X"]=28
    ["SCORE,Y"]=6
    ["SCORE,WIDTH"]=9

    ["LEVEL,X"]=28
    ["LEVEL,Y"]=11
    ["LEVEL,WIDTH"]=9

    ["LINES,X"]=28
    ["LINES,Y"]=15
    ["LINES,WIDTH"]=9

    ["ALERT,Y"]=8
    ["ALERT,X"]=27
    ["ALERT,PAUSED"]="P A U S E D"
    ["ALERT,SINGLE"]="S I N G L E"
    ["ALERT,DOUBLE"]="D O U B L E"
    ["ALERT,TRIPLE"]="T R I P L E"
    ["ALERT,TETRIS"]="T E T R I S"
    ["ALERT,GAME_OVER"]=" GAME OVER "
    ["ALERT,END_REPLAY"]="END  REPLAY"
    ["ALERT,CLEAR"]="           "

    ["PERFECT,MAX"]=1
    ["PERFECT,0,Y"]=11
    ["PERFECT,0,X"]=5
    ["PERFECT,0,TEXT"]="P E R F E C T"
    ["PERFECT,0,CLEAR"]="             "

    ["PERFECT,1,Y"]=13
    ["PERFECT,1,X"]=7
    ["PERFECT,1,TEXT"]="C L E A R"
    ["PERFECT,1,CLEAR"]="         "
)

declare -Arg -- NEXT_PIECE=(
    ["R,Y"]=19
    ["R,X"]=26  # Reset

    ["I,Y"]=19
    ["I,X"]=27

    ["J,Y"]=20
    ["J,X"]=28

    ["L,Y"]=20
    ["L,X"]=28

    ["O,Y"]=20
    ["O,X"]=29

    ["S,Y"]=20
    ["S,X"]=28

    ["T,Y"]=20
    ["T,X"]=28

    ["Z,Y"]=20
    ["Z,X"]=28
)

################################ Tetrominoes ###################################

declare -arg -- COLOURS=(
     [0]=$'\e[0m'           # Default
     [1]=$'\e[38;5;27m'     # Blue
     [2]=$'\e[38;5;43m'     # Cyan
     [3]=$'\e[38;5;76m'     # Green
     [4]=$'\e[38;5;128m'    # Purple
     [5]=$'\e[38;5;178m'    # Yellow
     [6]=$'\e[38;5;160m'    # Red
     [7]=$'\e[38;5;166m'    # Orange
     [8]=$'\e[38;5;205m'    # Pink
     [9]=$'\e[0;97m'        # White
    [10]=$'\e[38;5;232;47m' # Inverted white
)

declare -arg -- SCORE_MODIFIERS=(
    [1]=40
    [2]=100
    [3]=300
    [4]=1200
)

declare -arg -- PIECES=( "I" "J" "L" "O" "S" "T" "Z" )

declare -arg -- I=(
    "0,1 1,1 2,1 3,1"
    "2,0 2,1 2,2 2,3"
    "0,2 1,2 2,2 3,2"
    "1,0 1,1 1,2 1,3"
)

declare -arg -- J=(
    "0,0 0,1 1,1 2,1"
    "1,0 2,0 1,1 1,2"
    "0,1 1,1 2,1 2,2"
    "1,0 1,1 0,2 1,2"
)

declare -arg -- L=(
    "2,0 0,1 1,1 2,1"
    "1,0 1,1 1,2 2,2"
    "0,1 1,1 2,1 0,2"
    "0,0 1,0 1,1 1,2"
)

declare -arg -- O=(
    "0,0 1,0 0,1 1,1"
    "0,0 1,0 0,1 1,1"
    "0,0 1,0 0,1 1,1"
    "0,0 1,0 0,1 1,1"
)

declare -arg -- S=(
    "1,0 2,0 0,1 1,1"
    "1,0 1,1 2,1 2,2"
    "1,1 2,1 0,2 1,2"
    "0,0 0,1 1,1 1,2"
)

declare -arg -- T=(
    "1,0 0,1 1,1 2,1"
    "1,0 0,1 1,1 1,2"
    "0,1 1,1 2,1 1,2"
    "1,0 1,1 2,1 1,2"
)

declare -arg -- Z=(
    "0,0 1,0 1,1 2,1"
    "2,0 1,1 2,1 1,2"
    "0,1 1,1 1,2 2,2"
    "1,0 0,1 1,1 0,2"
)
