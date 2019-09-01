#################################### COLOUR ####################################

setNormalColourMode ()
{
    setColourMode 0
}

setSimpleColourMode ()
{
    setColourMode 1
}

setBleachColourMode ()
{
    setColourMode 2
}

setShadowColourMode ()
{
    setColourMode 3
}

setColourMode ()
{
    _colourMode=$1
}

#################################### OTHER #####################################

setGameMode ()
{
    _gameMode=$1
}

setState ()
{
    _state=${STATES[$1]}
}


################################### TOGGLES ####################################

toggleGhost ()
{
    toggleBoolean "ghost"
}

toggleRecord()
{
    toggleBoolean "record"
}

toggleHold ()
{
    toggleBoolean "hold"
}

toggleNext ()
{
    toggleBoolean "next"
}

toggleRotate ()
{
    toggleBoolean "rotate"
}

toggleMemory ()
{
    toggleBoolean "memory"
}

toggleBoolean ()
{
    (( _gameBooleans[$1] ^= 1 ))
}
