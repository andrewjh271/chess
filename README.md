# Chess

Command line chess program written in Ruby. View on [Repl.it](https://chess.andrewjh271.repl.run/) (But view a faster and more stable version by cloning the repo.)

------

[Standard Algebraic Notation](https://en.wikipedia.org/wiki/Algebraic_notation_(chess)) with [PGN](https://en.wikipedia.org/wiki/Portable_Game_Notation) standards is used for both display and input. A few clarifying notes regarding input:

- When inputting a move that comes with check or checkmate, + and # respectively should be appended to the end of the input, but are not required. The move list will show the symbols regardless.
- O-O and O-O-O are used for castling (captial o, not zero)
- En passant capture is entered as if capturing a pawn that had only moved 1 square (no e.p. at end)
- Disambiguation is required if more than one of the specified piece can move to the target square (e.g. Nbd2 to specify that the Knight on the b file is meant to move to d2; R1e1 to specify that the Rook on  the 1st rank is meant to move to e1)
- Promote to Queen, Rook, Bishop, or Knight by appending to move =Q, =R, =B, or =N respectively

Enforces the rules of chess, including, but not limited to:

- King cannot move into or ignore check
- Castling is only legal if:
  - King is not in check
  - Neither piece has moved
  - King will not move into check along the path to its destination square
- En passant is only legal immediately following opponent's two-square pawn move
- Checkmate if player to move has no legal moves and their King is in check
- Stalemate if player to move has no legal moves and their King is not in check
- Threefold repetition if position has occured three times, including the following considerations:
  - Same player to move
  - Same castling rights
  - Same en passant rights
- Draw if during the last 50 moves no capture or pawn move has occurred
- Draw if insufficient mating material

User can enter any of the following commands instead of a move:

- **help** - show commands
- **flip** - flip board
- **draw** - offer opponent a draw (the engine will never accept a draw offer (i.e. it's counting on you to blunder))
- **resign** (the engine will never resign (i.e. it never loses hope and has nowhere to be))
- **quit** (also **q** or **exit**)
- **save**
- **tutorial** - shows instructions and examples on inputting moves

A note on display: the pieces are tragically small, but the display I ended up with is the best of quite a few worse options I tried. The pieces can get a bit larger depending on the font in terminal.

------

The chess engine uses a minimax algorithm with alpha beta pruning, but only very modest depths are searched within a reasonable amount of time. A collection of about 4,500 games by [Victor Korchnoi](https://en.wikipedia.org/wiki/Viktor_Korchnoi) is used as the opening database. (Note: The engine depth on Repl.it is by necessity set particularly low.)

![engine](public/screenshots/chess_engine.gif)

------

There is an option to play through games from a handful of major chess events over the last half century. When in this mode, there are the following 4 controls:

- **m** - enter next move
- **p** - play all moves at a moderate tempo (every 2 seconds)
- **z** - zoom through moves at a brisk tempo (every 0.2 seconds)
- **q** - quit

![game_viewer](public/screenshots/game_viewer.gif)

-Andrew Hayhurst