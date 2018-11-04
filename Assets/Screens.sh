if ! $_inTTY; then
    mainScreen=(
        [0]='┌────────────────────────────────────────┐'
        [1]='│                                        │'
        [2]='│  █▛██▜█ ██ ▜█ █▛██▜█ ██ █▙  ██  ▟▙ ▜█  │'
        [3]='│  ▛ ██ ▜ ██  ▜ ▛ ██ ▜ ██ ██  ██  ▜█▙ ▜  │'
        [4]='│    ██   ██ █    ██   ██ ▛   ██   ▜█▙   │'
        [5]='│    ██   ██  ▟   ██   ██ ▙   ██  ▙ ▜█▙  │'
        [6]='│    ██   ██ ▟█   ██   ██ █▙  ██  █▙ ▜▛  │'
        [7]='│                                        │'
        [8]='│                                        │'
        [9]='│                                        │'
        [10]='│            N E W   G A M E             │'
        [11]='│                                        │'
        [12]='│                                        │'
        [13]='│              S C O R E S               │'
        [14]='│                                        │'
        [15]='│                                        │'
        [16]='│            S E T T I N G S             │'
        [17]='│                                        │'
        [18]='│                                        │'
        [19]='│                Q U I T                 │'
        [20]='│                                        │'
        [21]='│                                        │'
        [22]='│                           © Ben Pitman │'
        [23]='└────────────────────────────────────────┘'
    )
    fieldScreen=(
        [0]='┌────────────────────┬───────────────────┐'
        [1]='│                    │  ╔═════════════╗  │'
        [2]='│                    ├──╢  S C O R E  ╟──┤'
        [3]='│                    │  ╚═════════════╝  │'
        [4]='│                    ╞═══════════════════╡'
        [5]='│                    │             0     │'
        [6]='│                    ╞═══════════════════╡'
        [7]='│                    │                   │'
        [8]='│                    │  ╔═════════════╗  │'
        [9]='│                    │  ║  L E V E L  ║  │'
        [10]='│                    │  ║          0  ║  │'
        [11]='│                    │  ╚═════════════╝  │'
        [12]='│                    │  ╔═════════════╗  │'
        [13]='│                    │  ║  L I N E S  ║  │'
        [14]='│                    │  ║          0  ║  │'
        [15]='│                    │  ╚═════════════╝  │'
        [16]='│                    │                   │'
        [17]='│                    │  ╔══════════╗     │'
        [18]='│                    │  ║          ║     │'
        [19]='│                    │  ║          ║     │'
        [20]='│                    │  ║          ║     │'
        [21]='│                    │  ║          ║     │'
        [22]='│                    │  ╚══════════╝     │'
        [23]='└────────────────────┴───────────────────┘'
    )
    settingsScreen=(
        [0]='┌────────────────────────────────────────┐'
        [1]='│          ╔═════════════════╗           │'
        [2]='├──────────╢ S E T T I N G S ╟───────────┤'
        [3]='│          ╚═════════════════╝           │'
        [4]='│                                        │'
        [5]='│                       ┌──────────────┐ │'
        [6]='│                       │              │ │'
        [7]='│     COLOUR  MODE      │    NORMAL    │ │'
        [8]='│                       │              │ │'
        [9]='│                       │              │ │'
        [10]='│                       │              │ │'
        [11]='│                       │              │ │'
        [12]='│                       │              │ │'
        [13]='│                       │              │ │'
        [14]='│                       │              │ │'
        [15]='│                       │              │ │'
        [16]='│                       │              │ │'
        [17]='│                       │              │ │'
        [18]='│                       │              │ │'
        [19]='│                       │              │ │'
        [20]='│                       │              │ │'
        [21]='│                       └──────────────┘ │'
        [22]='│                                        │'
        [23]='└────────────────────────────────────────┘'
    )
else
    mainScreen=(
        [0]='┌────────────────────────────────────────┐'
        [1]='│                                        │'
        [2]='│  ██████ █████ ██████ █████  ██  █████  │'
        [3]='│    ██   ██      ██   ██  ██ ██ ██      │'
        [4]='│    ██   ████    ██   ████   ██   ██    │'
        [5]='│    ██   ██      ██   ██  ██ ██     ██  │'
        [6]='│    ██   █████   ██   ██  ██ ██ █████   │'
        [7]='│                                        │'
        [8]='│                                        │'
        [9]='│                                        │'
        [10]='│            N E W   G A M E             │'
        [11]='│                                        │'
        [12]='│                                        │'
        [13]='│              S C O R E S               │'
        [14]='│                                        │'
        [15]='│                                        │'
        [16]='│            S E T T I N G S             │'
        [17]='│                                        │'
        [18]='│                                        │'
        [19]='│                Q U I T                 │'
        [20]='│                                        │'
        [21]='│                                        │'
        [22]='│                           © Ben Pitman │'
        [23]='└────────────────────────────────────────┘'
    )
    fieldScreen=(
        [0]='┌────────────────────┬───────────────────┐'
        [1]='│                    │  ┌─────────────┐  │'
        [2]='│                    ├──┤  S C O R E  ├──┤'
        [3]='│                    │  └─────────────┘  │'
        [4]='│                    ├───────────────────┤'
        [5]='│                    │             0     │'
        [6]='│                    ├───────────────────┤'
        [7]='│                    │                   │'
        [8]='│                    │  ┌─────────────┐  │'
        [9]='│                    │  │  L E V E L  │  │'
        [10]='│                    │  │          0  │  │'
        [11]='│                    │  └─────────────┘  │'
        [12]='│                    │  ┌─────────────┐  │'
        [13]='│                    │  │  L I N E S  │  │'
        [14]='│                    │  │          0  │  │'
        [15]='│                    │  └─────────────┘  │'
        [16]='│                    │                   │'
        [17]='│                    │  ┌──────────┐     │'
        [18]='│                    │  │          │     │'
        [19]='│                    │  │          │     │'
        [20]='│                    │  │          │     │'
        [21]='│                    │  │          │     │'
        [22]='│                    │  └──────────┘     │'
        [23]='└────────────────────┴───────────────────┘'
    )
    settingsScreen=(
        [0]='┌────────────────────────────────────────┐'
        [1]='│          ┌─────────────────┐           │'
        [2]='├──────────┤ S E T T I N G S ├───────────┤'
        [3]='│          └─────────────────┘           │'
        [4]='│                                        │'
        [5]='│                                        │'
        [6]='│                       ┌──────────────┐ │'
        [7]='│                       │┌────────────┐│ │'
        [8]='│     COLOUR  MODE      ││            ││ │'
        [9]='│                       ││   NORMAL   ││ │'
        [10]='│                       ││            ││ │'
        [11]='│                       ││   SIMPLE   ││ │'
        [12]='│                       ││            ││ │'
        [13]='│                       ││    NOIR    ││ │'
        [14]='│                       ││            ││ │'
        [15]='│                       ││  BLEACH  ││ │'
        [16]='│                       ││            ││ │'
        [17]='│                       │└────────────┘│ │'
        [18]='│                       └──────────────┘ │'
        [19]='│                                        │'
        [20]='│         BACK                           │'
        [21]='│                                        │'
        [22]='│                                        │'
        [23]='└────────────────────────────────────────┘'
    )
fi
