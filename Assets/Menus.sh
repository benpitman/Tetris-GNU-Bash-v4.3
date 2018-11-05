

declare -A mainOptions=(
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
declare -A settingsOptions=(
    ['max']=1

    ['0']=' COLOUR  MODE '
    ['0,y']=9
    ['0,x']=6

    ['1']=' BACK '
    ['1,y']=21
    ['1,x']=10
)

# Clears the chosen items for repopulation
declare -A settingsSubMenu=(
    ['max']=0
    ['width']=11

    ['0']='_colourMode'
    ['0,y']=9
    ['0,x']=26

    ['clear']='              '
    ['clear,y']=8
    ['clear,x']=25
    ['clear,max']=11
)

# Opens up the submenu for selection
declare -A settingsColourSub=(
    ['max']=10

    ['y']=8
    ['x']=25

    ['top']='┌────────────┐'
    ['middle']='│            │'
    ['bottom']='└────────────┘'
)

# Settings colour mode submenu options
declare -A settingsColourSubOptions=(
    ['max']=3

    ['0']='  NORMAL  '
    ['0,y']=10
    ['0,x']=27

    ['1']='  SIMPLE  '
    ['1,y']=12
    ['1,x']=27

    ['2']='   NOIR   '
    ['2,y']=14
    ['2,x']=27

    ['3']='  BLEACH  '
    ['3,y']=16
    ['3,x']=27
)

startPosition='2,8'

declare -A fieldOptions=(
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

declare -A nextPiece=(
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
