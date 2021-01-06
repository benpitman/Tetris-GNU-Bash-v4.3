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
    holdEnabled && printf -v $1 "%s" "ACTIVE" || printf -v $1 "%s" "INACTIVE"
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

getReadableUI ()
{
    unicodeEnabled && printf -v $1 "%s" "NORMAL" || printf -v $1 "%s" "SIMPLE"
}

################################# COLLISION ####################################

hasCollision ()
{
    (( ${_lock[$1,$2]} ))
}

getLockColourID ()
{
    return ${_lock[$1,$2,COLOUR]}
}

getNextLockID ()
{
    return $(( ++_lockID ))
}

################################## PSEUDO ######################################

holdEnabled ()
{
    (( ${_gameBooleans[hold]} ))
}

nextEnabled ()
{
    (( ${_gameBooleans[next]} ))
}

ghostEnabled ()
{
    (( ${_gameBooleans[ghost]} ))
}

recordEnabled ()
{
    (( ${_gameBooleans[record]} ))
}

rotateEnabled ()
{
    (( ${_gameBooleans[rotate]} ))
}

memoryEnabled ()
{
    (( ${_gameBooleans[memory]} ))
}

unicodeEnabled ()
{
    (( ${_gameBooleans[unicode]} ))
}

################################## IS SETS #####################################

debuggingIsSet ()
{
    (( $_debug ))
}

colourModeIsSet ()
{
    [[ -n "$_colourMode" ]]
}
