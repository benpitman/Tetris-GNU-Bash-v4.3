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
lLong='720'
lBreak='870'
dBreak='620'
dLong='310'
dShort='155'

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
        -nf $A4 -l $lShort -D $dBreak   \
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
    beep -f $E5 -l $lBreak              \
        -nf $C5 -l $lBreak              \
        -nf $D5 -l $lBreak              \
        -nf $B4 -l $lBreak              \
        -nf $C5 -l $lBreak              \
        -nf $A4 -l $lBreak              \
        -nf $Ab4 -l $lBreak             \
        -nf $B4 -l $lBreak              \
        -nf $E5 -l $lBreak              \
        -nf $C5 -l $lBreak              \
        -nf $D5 -l $lBreak              \
        -nf $B4 -l $lBreak              \
        -nf $C5 -l $lLong               \
        -nf $E5 -l $lLong               \
        -nf $A5 -l $lBreak              \
        -nf $Ab5 -l $lBreak -D $dBreak
}

while true; do
    stage1
    stage1
    stage2
done

:<<THEME
    https://pages.mtu.edu/~suits/notefreqs.html
    https://www.piano-keyboard-guide.com/how-to-play-the-tetris-theme-song-easy-piano-tutorial-korobeiniki/

    E B C D C B A
    A C E D C B
    C D E C A A
    D F A G F E
    C E D C B
    B C D E C A A

    E C D B C A Ab B
    E C D B C E A Ab
THEME
