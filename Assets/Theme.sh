stage1()
{
    beep -f $E5 -l $lShort -D $dShort  \
        -nf $B4                        \
        -nf $C5                        \
        -nf $D5 -l $lShort -D $dShort  \
        -nf $C5                        \
        -nf $B4                        \
        -nf $A4 -l $lShort -D $dShort  \
        -nf $A4                        \
        -nf $C5                        \
        -nf $E5 -l $lShort -D $dShort  \
        -nf $D5                        \
        -nf $C5                        \
        -nf $B4 -l $lShort -D $dLong   \
        -nf $C5                        \
        -nf $D5 -l $lShort -D $dShort  \
        -nf $E5 -l $lShort -D $dShort  \
        -nf $C5 -l $lShort -D $dShort  \
        -nf $A4 -l $lShort -D $dShort  \
        -nf $A4 -l $lShort -D $lStride \
        -nf $D5 -l $lShort -D $dShort  \
        -nf $F5                        \
        -nf $A5 -l $lShort -D $dShort  \
        -nf $G5                        \
        -nf $F5                        \
        -nf $E5 -l $lShort -D $dLong   \
        -nf $C5                        \
        -nf $E5 -l $lShort -D $dShort  \
        -nf $D5                        \
        -nf $C5                        \
        -nf $B4 -l $lShort -D $dShort  \
        -nf $B4                        \
        -nf $C5                        \
        -nf $D5 -l $lShort -D $dShort  \
        -nf $E5 -l $lShort -D $dShort  \
        -nf $C5 -l $lShort -D $dShort  \
        -nf $A4 -l $lShort -D $dShort  \
        -nf $A4 -l $lShort -D $dBreak
    return

    # siggen and pulseaudio-utils
    padsp tones -abs 1 \
        ${E5%.*}:$lShort 1:$dShort  \
        ${B4%.*}:200                \
        ${C5%.*}:200                \
        ${D5%.*}:$lShort 1:$dShort  \
        ${C5%.*}:200                \
        ${B4%.*}:200                \
        ${A4%.*}:$lShort 1:$dShort  \
        ${A4%.*}:200                \
        ${C5%.*}:200                \
        ${E5%.*}:$lShort 1:$dShort  \
        ${D5%.*}:200                \
        ${C5%.*}:200                \
        ${B4%.*}:$lShort 1:$dLong   \
        ${C5%.*}:200                \
        ${D5%.*}:$lShort 1:$dShort  \
        ${E5%.*}:$lShort 1:$dShort  \
        ${C5%.*}:$lShort 1:$dShort  \
        ${A4%.*}:$lShort 1:$dShort  \
        ${A4%.*}:$lShort 1:$lStride \
        ${D5%.*}:$lShort 1:$dShort  \
        ${F5%.*}:200                \
        ${A5%.*}:$lShort 1:$dShort  \
        ${G5%.*}:200                \
        ${F5%.*}:200                \
        ${E5%.*}:$lShort 1:$dLong   \
        ${C5%.*}:200                \
        ${E5%.*}:$lShort 1:$dShort  \
        ${D5%.*}:200                \
        ${C5%.*}:200                \
        ${B4%.*}:$lShort 1:$dShort  \
        ${B4%.*}:200                \
        ${C5%.*}:200                \
        ${D5%.*}:$lShort 1:$dShort  \
        ${E5%.*}:$lShort 1:$dShort  \
        ${C5%.*}:$lShort 1:$dShort  \
        ${A4%.*}:$lShort 1:$dShort  \
        ${A4%.*}:$lShort 1:$dBreak
}

stage2()
{
    beep -f $E5 -l $lStride              \
        -nf $C5 -l $lStride              \
        -nf $D5 -l $lStride              \
        -nf $B4 -l $lStride              \
        -nf $C5 -l $lStride              \
        -nf $A4 -l $lStride              \
        -nf $Ab4 -l $lStride             \
        -nf $B4 -l $lBreak -D $dLong     \
        -nf $E5 -l $lStride              \
        -nf $C5 -l $lStride              \
        -nf $D5 -l $lStride              \
        -nf $B4 -l $lStride              \
        -nf $C5 -l $lLong                \
        -nf $E5 -l $lLong                \
        -nf $A5 -l $lStride              \
        -nf $Ab5 -l $lStride -D $dStride
    return

    padsp tones -abs 1 \
        ${E5%.*}:$lStride             \
        ${C5%.*}:$lStride             \
        ${D5%.*}:$lStride             \
        ${B4%.*}:$lStride             \
        ${C5%.*}:$lStride             \
        ${A4%.*}:$lStride             \
        ${Ab4%.*}:$lStride            \
        ${B4%.*}:$lBreak 1:$dLong     \
        ${E5%.*}:$lStride             \
        ${C5%.*}:$lStride             \
        ${D5%.*}:$lStride             \
        ${B4%.*}:$lStride             \
        ${C5%.*}:$lLong               \
        ${E5%.*}:$lLong               \
        ${A5%.*}:$lStride             \
        ${Ab5%.*}:$lStride 1:$dStride
}

playTheme()
{
    local               \
        Ab4='415.30'    \
        A4='440.00'     \
        B4='493.88'     \
        C5='523.25'     \
        D5='587.33'     \
        E5='659.25'     \
        F5='698.46'     \
        G5='783.99'     \
        Ab5='830.61'    \
        A5='880.00'     \
        lShort='250'    \
        lLong='400'     \
        lBreak='480'    \
        lStride='800'   \
        dShort='150'    \
        dLong='320'     \
        dBreak='600'    \
        dStride='850'

    while true; do
        stage1
        stage1
        stage2
    done
}
