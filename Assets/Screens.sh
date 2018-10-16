read -r -d '' mainGUI << MAIN_GUI
┌────────────────────────────────────────┐
│┌──────────────────────────────────────┐│
││ █▛██▜█ ██ ▜█ █▛██▜█ ██ █▙  ██  ▟▙ ▜█ ││
││ ▛ ██ ▜ ██  ▜ ▛ ██ ▜ ██ ██  ██  ▜█▙ ▜ ││
││   ██   ██ █    ██   ██ ▛   ██   ▜█▙  ││
││   ██   ██  ▟   ██   ██ ▙   ██  ▙ ▜█▙ ││
││   ██   ██ ▟█   ██   ██ █▙  ██  █▙ ▜▛ ││
│└──────────────────────────────────────┘│
│                                        │
│                                        │
│                                        │
│            1   P L A Y E R             │
│                                        │
│                                        │
│            2   P L A Y E R             │
│                                        │
│                                        │
│                                        │
│                Q U I T                 │
│                                        │
│                                        │
│                                        │
│                           © Ben Pitman │
└────────────────────────────────────────┘
MAIN_GUI

read -r -d '' mainCLI << MAIN_CLI
┌────────────────────────────────────────┐
│┌──────────────────────────────────────┐│
││ ██████ █████ ██████ █████  ██  █████ ││
││   ██   ██      ██   ██  ██ ██ ██     ││
││   ██   ████    ██   ████   ██   ██   ││
││   ██   ██      ██   ██  ██ ██     ██ ││
││   ██   █████   ██   ██  ██ ██ █████  ││
│└──────────────────────────────────────┘│
│                                        │
│                                        │
│                                        │
│            1   P L A Y E R             │
│                                        │
│                                        │
│            2   P L A Y E R             │
│                                        │
│                                        │
│                                        │
│                Q U I T                 │
│                                        │
│                                        │
│                                        │
│                           © Ben Pitman │
└────────────────────────────────────────┘
MAIN_CLI

declare -A mainOptions

mainOptions['max']=2

mainOptions['0,y']=12
mainOptions['0,x']=14
mainOptions['0,text']='1   P L A Y E R'

mainOptions['1,y']=15
mainOptions['1,x']=14
mainOptions['1,text']='2   P L A Y E R'

mainOptions['2,y']=19
mainOptions['2,x']=18
mainOptions['2,text']='Q U I T'

read -r -d '' fieldGUI << FIELD_GUI
┌────────────────────┬───────────────────┐
│                    │  ╔═════════════╗  │
│                    ├──╢  S C O R E  ╟──┤
│                    │  ╚═════════════╝  │
│                    ╞═══════════════════╡
│                    │             0     │
│                    ╞═══════════════════╡
│                    │                   │
│                    │  ╔═════════════╗  │
│                    │  ║  L E V E L  ║  │
│                    │  ║          0  ║  │
│                    │  ╚═════════════╝  │
│                    │  ╔═════════════╗  │
│                    │  ║  L I N E S  ║  │
│                    │  ║          0  ║  │
│                    │  ╚═════════════╝  │
│                    │                   │
│                    │  ╔══════════╗     │
│                    │  ║          ║     │
│                    │  ║          ║     │
│                    │  ║          ║     │
│                    │  ║          ║     │
│                    │  ╚══════════╝     │
└────────────────────┴───────────────────┘
FIELD_GUI

read -r -d '' fieldCLI << FIELD_CLI
┌────────────────────┬───────────────────┐
│                    │  ┌─────────────┐  │
│                    ├──┤  S C O R E  ├──┤
│                    │  └─────────────┘  │
│                    ├───────────────────┤
│                    │             0     │
│                    ├───────────────────┤
│                    │                   │
│                    │  ┌─────────────┐  │
│                    │  │  L E V E L  │  │
│                    │  │          0  │  │
│                    │  └─────────────┘  │
│                    │  ┌─────────────┐  │
│                    │  │  L I N E S  │  │
│                    │  │          0  │  │
│                    │  └─────────────┘  │
│                    │                   │
│                    │  ┌──────────┐     │
│                    │  │          │     │
│                    │  │          │     │
│                    │  │          │     │
│                    │  │          │     │
│                    │  └──────────┘     │
└────────────────────┴───────────────────┘
FIELD_CLI

declare -A nextPiece

# Reset
nextPiece['R,x']=26
nextPiece['R,y']=19

nextPiece['I,x']=27
nextPiece['I,y']=19
nextPiece['J,x']=28
nextPiece['J,y']=20
nextPiece['L,x']=28
nextPiece['L,y']=20
nextPiece['O,x']=29
nextPiece['O,y']=20
nextPiece['S,x']=28
nextPiece['S,y']=20
nextPiece['T,x']=28
nextPiece['T,y']=20
nextPiece['Z,x']=28
nextPiece['Z,y']=20

# tput civis
# source ~/Git/Public/Tetris-GNU-Bash-v4/Assets/Tetrominoes
# tput clear
# echo "$fieldCLI"
# for n in I J L O S T Z; do
#     renderNext $n false
#     read
# done
