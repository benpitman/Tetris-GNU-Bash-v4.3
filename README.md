# Tetris

![tetris](https://user-images.githubusercontent.com/26070332/104516528-66300d00-55ec-11eb-83fe-a347db8a51a8.gif)

## ------------------------{ About }--------------------------

It's just Tetris, really, with some additional features:

- There are some colour alternatives, including a reduced colour set for if you want to play on your server.
- There's a hard mode where you can only rotate a piece up to 3 times.
- Ghost pieces so you can see where it's going to drop. (This can cause flicker, especially if you're playing over ssh)
- Record mode where all your inputs are captured so it can play it back to you with `tetris -r`. I have yet to implement a system to rename and move that input file so it's not overwritten every time.

## ---------------------{ Installation }----------------------

Download the latest Release [here](https://github.com/benpitman/Tetris-GNU-Bash-v4.3/releases/latest) and run the tetris-install file.

## ------------------------{ Usage }--------------------------

To run:
```bash
tetris
```

To replay the last recorded playthrough:
```bash
tetris -r /var/games/tetris/input.log
```
