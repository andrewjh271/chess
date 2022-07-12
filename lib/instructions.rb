# sample game that provides input formatting instructions
module Instructions
  def show_instructions
    clear_board
    hide_cursor
    sample = Board.new
    sample.display
    instruct('Input moves using Chess Algebraic Notation.')
    return if STDIN.getch == 'q'

    info = 'Only enter the target square coordinates for a move. For pawns, nothing else is needed.'
    return unless move_sequence(sample, %w[e4 e5], info)

    info = 'Begin with K, Q, R, B, or N to move a King, Queen, Rook, Bishop, or Knight, respectively.'
    return unless move_sequence(sample, %w[Bc4 Nf6], info)

    info = 'For a capture, add an x just before the target square.'
    return unless move_sequence(sample, %w[Nf3 Nxe4 Nc3 Nxc3], info)

    info = "To capture with a pawn, begin with that pawn's file."
    return unless move_sequence(sample, ['dxc3'], info)

    info = 'For kingside castling, enter O-O; for queenside, O-O-O.'
    return unless move_sequence(sample, %w[f6 O-O], info)

    info = "For en passant, enter capture as though the opponent's pawn had only moved 1 square."
    return unless move_sequence(sample, %w[d6 b4 Bg4 b5 c5 bxc6], info)

    info = 'Specify the current file or rank of the piece if more than one of that type could make the desired move.'
    return unless move_sequence(sample, %w[Qe7 Ba3 Na6 Qxd6 g5 Rad1], info)

    info = 'To promote a pawn, add =Q, =R, =B, or =N after the target square.'
    return unless move_sequence(sample, %w[Bh6 cxb7 f5 bxa8=R+], info)

    info = 'Optionally add + or # to indicate check or checkmate respectively. (It will be present in the move list regardless.)'
    return unless move_sequence(sample, %w[Qd8 Qxd8#], info)

    sample.display
    move_up(1)
    puts 'Press any key to return to game.'.green
    puts 'Look up Chess Algebraic Notation for more info.'
    STDIN.getch
  end

  def instruct(string)
    move_up(1)
    puts 'Press any letter key to begin tutorial or q to exit.'.green
    puts string
  end

  def clear_board
    move_up(28)
    28.times { puts_clear }
  end

  # puts current instruction after every #display call
  def move_sequence(sample, array, string)
    move_up(2)
    print_clear
    puts 'Press any letter key to enter next move or q to exit.'.magenta
    puts string
    return false if STDIN.getch == 'q'
    array.each do |move|
      sample.move(move)
      sample.display
      move_up(1)
      puts move == array.last ? 'Press any letter key for next instruction or q to exit.'.green
                              : 'Press any letter key to enter next move or q to exit.'.magenta
      puts string
      return false if STDIN.getch == 'q'
    end
    true
  end
end
