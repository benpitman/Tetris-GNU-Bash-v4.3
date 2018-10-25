Gs4='415.30'
Ab4=$Gs4
A4='440.00'
As4='466.16'
Bb4=$As
B4='493.88'
C5='523.25'
Cs5='554.37'
Db5=$Cs5
D5='587.33'
Ds5='622.25'
Eb5=$Ds5
E5='659.25'
F5='698.46'
Fs5='739.99'
Gb5=$Fs5
G5='783.99'
Gs5='830.61'
Ab5=$Gs5
A5='880.00'
As5='932.33'
Bb5=$As5
B5='987.77'

lShort='250'
lLong='400'
lBreak='480'
lStride='800'
dShort='150'
dLong='320'
dBreak='600'
dStride='850'

stage1()
{
    beep -f $E5 -l $lShort -D $dShort   \
        -nf $B4                         \
        -nf $C5                         \
        -nf $D5 -l $lShort -D $dShort   \
        -nf $C5                         \
        -nf $B4                         \
        -nf $A4 -l $lShort -D $dShort   \
        -nf $A4                         \
        -nf $C5                         \
        -nf $E5 -l $lShort -D $dShort   \
        -nf $D5                         \
        -nf $C5                         \
        -nf $B4 -l $lShort -D $dLong    \
        -nf $C5                         \
        -nf $D5 -l $lShort -D $dShort   \
        -nf $E5 -l $lShort -D $dShort   \
        -nf $C5 -l $lShort -D $dShort   \
        -nf $A4 -l $lShort -D $dShort   \
        -nf $A4 -l $lShort -D $lStride  \
        -nf $D5 -l $lShort -D $dShort   \
        -nf $F5                         \
        -nf $A5 -l $lShort -D $dShort   \
        -nf $G5                         \
        -nf $F5                         \
        -nf $E5 -l $lShort -D $dLong    \
        -nf $C5                         \
        -nf $E5 -l $lShort -D $dShort   \
        -nf $D5                         \
        -nf $C5                         \
        -nf $B4 -l $lShort -D $dShort   \
        -nf $B4                         \
        -nf $C5                         \
        -nf $D5 -l $lShort -D $dShort   \
        -nf $E5 -l $lShort -D $dShort   \
        -nf $C5 -l $lShort -D $dShort   \
        -nf $A4 -l $lShort -D $dShort   \
        -nf $A4 -l $lShort -D $dBreak
}

stage2()
{
    beep -f $E5 -l $lStride             \
        -nf $C5 -l $lStride             \
        -nf $D5 -l $lStride             \
        -nf $B4 -l $lStride             \
        -nf $C5 -l $lStride             \
        -nf $A4 -l $lStride             \
        -nf $Ab4 -l $lStride            \
        -nf $B4 -l $lBreak -D $dLong    \
        -nf $E5 -l $lStride             \
        -nf $C5 -l $lStride             \
        -nf $D5 -l $lStride             \
        -nf $B4 -l $lStride             \
        -nf $C5 -l $lLong               \
        -nf $E5 -l $lLong               \
        -nf $A5 -l $lStride             \
        -nf $Ab5 -l $lStride -D $dStride
}

while true; do
    stage1
    stage1
    stage2
done
