declare -A colours

colours['RESET']='\e[0m'
colours['WHITE']='\e[0;37m'

colours['false,R']='\e[0m'  # White
colours['true,R']='\e[0m'   # White

# GUI
colours['false,I']='\e[38;5;43m'    # Cyan
colours['false,J']='\e[38;5;27m'    # Blue
colours['false,L']='\e[38;5;166m'   # Orange
colours['false,O']='\e[38;5;178m'   # Yellow
colours['false,S']='\e[38;5;76m'    # Green
colours['false,T']='\e[38;5;128m'   # Purple
colours['false,Z']='\e[38;5;160m'   # Red

# CLI
colours['true,I']='\e[38;5;27m'     # Blue
colours['true,J']='\e[38;5;128m'    # Purple
colours['true,L']='\e[38;5;178m'    # Yellow
colours['true,O']='\e[38;5;76m'     # Green
colours['true,S']='\e[38;5;43m'     # Cyan
colours['true,T']='\e[38;5;205m'    # Pink
colours['true,Z']='\e[38;5;160m'    # Red

pieces=( 'I' 'J' 'L' 'O' 'S' 'T' 'Z' )

I=(
    4
    '0000111100000000'
    '0010001000100010'
    '0000000011110000'
    '0100010001000100'
)

J=(
    3
    '100111000'
    '011010010'
    '000111100'
    '010010110'
)

L=(
    3
    '001111000'
    '010010011'
    '000111100'
    '110010010'
)

O=(
    2
    '1111'
    '1111'
    '1111'
    '1111'
)

S=(
    3
    '011110000'
    '010011001'
    '000011110'
    '100110010'
)

T=(
    3
    '010111000'
    '010110010'
    '000111010'
    '010011010'
)

Z=(
    3
    '110011000'
    '001011010'
    '000110011'
    '010110100'
)

R=(
    5
    '0000000000000000000000000'
    '0000000000000000000000000'
    '0000000000000000000000000'
    '0000000000000000000000000'
)

# for shape in I J L O S T Z; do
#     declare -n tet="$shape"
#     echo -e "${colours[X,$shape]}"
#     for (( i=0; i<( ${tet[0]} ** 2); i+=${tet[0]})); do
#         C="${tet[1]:$i:${tet[0]}}"
#         C="${C//0/\\u0020\\u0020}"
#         C="${C//1/\\u2588\\u2588}"
#         echo -e "$C"
#     done
# done
