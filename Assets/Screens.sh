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
│            N E W   G A M E             │
│                                        │
│                                        │
│              S C O R E S               │
│                                        │
│                                        │
│            S E T T I N G S             │
│                                        │
│                                        │
│                Q U I T                 │
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
│            N E W   G A M E             │
│                                        │
│                                        │
│              S C O R E S               │
│                                        │
│                                        │
│            S E T T I N G S             │
│                                        │
│                                        │
│                Q U I T                 │
│                                        │
│                                        │
│                           © Ben Pitman │
└────────────────────────────────────────┘
MAIN_CLI

declare -A mainOptions

mainOptions['max']=3

mainOptions['0,y']=11
mainOptions['0,x']=14
mainOptions['0,text']='N E W   G A M E'

mainOptions['1,y']=14
mainOptions['1,x']=16
mainOptions['1,text']='S C O R E S'

mainOptions['2,y']=17
mainOptions['2,x']=14
mainOptions['2,text']='S E T T I N G S'

mainOptions['3,y']=20
mainOptions['3,x']=18
mainOptions['3,text']='Q U I T'

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

declare -A fieldOptions

fieldOptions['score,x']=28
fieldOptions['score,y']=6
fieldOptions['score,width']=9

fieldOptions['level,x']=28
fieldOptions['level,y']=11
fieldOptions['level,width']=9

fieldOptions['lines,x']=28
fieldOptions['lines,y']=15
fieldOptions['lines,width']=9

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
# source ~/Git/Public/Tetris-GNU-Bash-v4/Assets/Tetrominoes.sh
# source ~/Git/Public/Tetris-GNU-Bash-v4/Assets/Render.sh
# tput clear
# echo "$fieldCLI"
# inCLI=false
# for n in I J L O S T Z; do
#     renderNextPiece $n true
#     read
# done
