module Instructions
  def show_instructions
    clear
    sample = Board.new
    sample.display
    instruct('Input moves using Standard Algebraic Notation.')
    return if STDIN.getch == 'q'
    info = 'Only enter the target square for a move. For pawns, nothing else is needed.'
    move_sequence(sample, ['e4', 'e5'], info)
    return if STDIN.getch == 'q'
    info = 'Begin with K Q R B, or N to move a King Queen Rook Bishop or Knight, respectively.'
    move_sequence(sample, ['Bc4', 'Nf6'], info)
    return if STDIN.getch == 'q'
    info = 'For a capture, add an x before the target square.'
    move_sequence(sample, ['Nf3', 'Nxe4', 'Nc3', 'Nxc3'], info)
    return if STDIN.getch == 'q'
    info = "For a pawn capture, begin with the pawn's file."
    move_sequence(sample, ['dxc3'], info)
    return if STDIN.getch == 'q'
    info = 'For kingside castling enter O-O; for queenside, O-O-O.'
    move_sequence(sample, ['f6', 'O-O'], info)
    return if STDIN.getch == 'q'
    info = "For en passant, enter capture as though the opponent's pawn had only moved 1 square."
    move_sequence(sample, ['d6', 'b4', 'Bg4', 'b5', 'c5', 'bxc6'], info)
    return if STDIN.getch == 'q'
    info = "Specify the file or rank if there are more than one piece that could make move."
    move_sequence(sample, ['Qe7', 'Ba3', 'Na6', 'Qxd6', 'g5', 'Rad1'], info)
    return if STDIN.getch == 'q'
    info = "To promote a pawn, add =Q =R =B or =N after target square."
    move_sequence(sample, ['Bh6', 'cxb7', 'f5', 'bxa8=R+'], info)
    return if STDIN.getch == 'q'
    info = "Optionally add + or # for check or checkmate. (It will be present in move list regardless.)"
    move_sequence(sample, ['Qd8', 'Qxd8#'], info)
    return if STDIN.getch == 'q'
    sample.display
    puts 'Press any key to return to game.'.green
    STDIN.getch
    clear
  end

  def instruct(string)
    move_up(1)
    puts 'Press any key for next instruction, or q to exit...'.green
    puts string
  end

  def clear
    move_up(28)
    28.times { puts_clear }
  end

  def move_sequence(sample, array, string)
    array.each do |move|
      sample.move(move)
      sample.display
      instruct(string)
      sleep(1)
    end
  end
end