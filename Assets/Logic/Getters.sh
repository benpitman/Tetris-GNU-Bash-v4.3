getReadableColourMode ()
{
    printf -v $1 ${COLOUR_MODE[$_colourMode]}
}

getReadableGameMode ()
{
    printf -v $1 ${GAME_MODE[$_gameMode]}
}

################################ READABLES #####################################

getReadableNext ()
{
    nextEnabled && printf -v $1 "%s" "ACTIVE" || printf -v $1 "%s" "INACTIVE"
}

getReadableHold ()
{
    # holdEnabled && printf -v $1 "%s" "ACTIVE" || printf -v $1 "%s" "INACTIVE"
    printf -v $1 "%s" "DISABLED"
}

getReadableGhost ()
{
    ghostEnabled && printf -v $1 "%s" "ACTIVE" || printf -v $1 "%s" "INACTIVE"
}

getReadableRecord ()
{
    recordEnabled && printf -v $1 "%s" "ACTIVE" || printf -v $1 "%s" "INACTIVE"
}

getReadableRotate ()
{
    rotateEnabled && printf -v $1 "%s" "ACTIVE" || printf -v $1 "%s" "INACTIVE"
}

getReadableMemory ()
{
    # memoryEnabled && printf -v $1 "%s" "ACTIVE" || printf -v $1 "%s" "INACTIVE"
    printf -v $1 "%s" "DISABLED"
}

################################## PSEUDO ######################################

holdEnabled ()
{
    return ${_gameBooleans[hold]}
}

nextEnabled ()
{
    return ${_gameBooleans[next]}
}

ghostEnabled ()
{
    return ${_gameBooleans[ghost]}
}

recordEnabled ()
{
    return ${_gameBooleans[record]}
}

rotateEnabled ()
{
    return ${_gameBooleans[rotate]}
}

memoryEnabled ()
{
    return ${_gameBooleans[memory]}
}
