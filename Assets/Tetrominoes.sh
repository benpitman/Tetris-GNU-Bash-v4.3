blank='\u0020'
block='\u2588'

declare -A colours

colours['reset']=$'\e[0m'
colours['white']=$'\e[0;37m'

colours[R]=$'\e[0m'  # Default

if ! $_inTTY; then
    # GUI
    colours[I]=$'\e[38;5;43m'    # Cyan
    colours[J]=$'\e[38;5;27m'    # Blue
    colours[L]=$'\e[38;5;166m'   # Orange
    colours[O]=$'\e[38;5;178m'   # Yellow
    colours[S]=$'\e[38;5;76m'    # Green
    colours[T]=$'\e[38;5;128m'   # Purple
    colours[Z]=$'\e[38;5;160m'   # Red
else
    # CLI
    colours[I]=$'\e[38;5;27m'    # Blue
    colours[J]=$'\e[38;5;128m'   # Purple
    colours[L]=$'\e[38;5;178m'   # Yellow
    colours[O]=$'\e[38;5;76m'    # Green
    colours[S]=$'\e[38;5;43m'    # Cyan
    colours[T]=$'\e[38;5;205m'   # Pink
    colours[Z]=$'\e[38;5;160m'   # Red
fi

pieces=( 'I' 'J' 'L' 'O' 'S' 'T' 'Z' )

# TODO restructure these so read is not needed
I=(
    '0,1 1,1 2,1 3,1'
    '2,0 2,1 2,2 2,3'
    '0,2 1,2 2,2 3,2'
    '1,0 1,1 1,2 1,3'
)

J=(
    '0,0 0,1 1,1 2,1'
    '1,0 2,0 1,1 1,2'
    '0,1 1,1 2,1 2,2'
    '1,0 1,1 0,2 1,2'
)

L=(
    '2,0 0,1 1,1 2,1'
    '1,0 1,1 1,2 2,2'
    '0,1 1,1 2,1 0,2'
    '0,0 1,0 1,1 1,2'
)

O=(
    '0,0 1,0 0,1 1,1'
    '0,0 1,0 0,1 1,1'
    '0,0 1,0 0,1 1,1'
    '0,0 1,0 0,1 1,1'
)

S=(
    '1,0 2,0 0,1 1,1'
    '1,0 1,1 2,1 2,2'
    '1,1 2,1 0,2 1,2'
    '0,0 0,1 1,1 1,2'
)

T=(
    '1,0 0,1 1,1 2,1'
    '1,0 0,1 1,1 1,2'
    '0,1 1,1 2,1 1,2'
    '1,0 1,1 2,1 1,2'
)

Z=(
    '0,0 1,0 1,1 2,1'
    '2,0 1,1 2,1 1,2'
    '0,1 1,1 1,2 2,2'
    '1,0 0,1 1,1 0,2'
)

R='00000'
