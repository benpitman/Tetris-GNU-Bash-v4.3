getReadableColourMode ()
{
    printf -v $1 ${COLOUR_MODES[$_colourMode]}
}

getReadableGameMode ()
{
    printf -v $1 ${GAME_MODES[$_gameMode]}
}

################################ READABLES #####################################

getReadableHold ()
{
    holdEnabled && printf -v $1 "ACTIVE" || printf -v $1 "INACTIVE"
}

################################## PSEUDO ######################################

holdEnabled ()
{
    return ${_gameBooleans["hold"]}
}

nextEnabled ()
{
    return ${_gameBooleans["next"]}
}

ghostEnabled ()
{
    return ${_gameBooleans["ghost"]}
}

recordEnabled ()
{
    return ${_gameBooleans["record"]}
}

memoryEnabled ()
{
    return ${_gameBooleans["memory"]}
}

rotateEnabled ()
{
    return ${_gameBooleans["rotate"]}
}
