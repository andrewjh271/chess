# https://shiroyasha.svbtle.com/escape-sequences-a-quick-guide-1
# https://stackoverflow.com/questions/1489183/colorized-ruby-output-to-the-terminal

module EscapeSequences
  # Movement

  def move_up(n); print "\e[#{n}A" end # up - moves n lines up
  def move_down(n); print "\e[#{n}B" end # down - moves n lines down
  def move_forward(n);  print "\e[#{n}C" end # forward - moves n characters forward
  def move_backward(n); print "\e[#{n}D" end # backward - moves n character backward

  def move_to_start_down(n); print "\e[#{n}E" end # move to the beginning of n lines down 
  def move_to_end_up(n); print "\e[#{n}F" end # move to the beginning of n lines up

  def move_to_column(x); print "\e[#{x}F" end # move to column x

  def move_to(x, y); print "\e[#{y};#{x}G" end # moves cursor to row y and column x

  def scroll_up(n); print "\e[#{n}S" end # scroll n lines up
  def scroll_down(n); print "\e[#{n}T" end # scroll n lines down
  
  # Erasing the screen

  def puts_clear; puts "\e[0J" end # Clear screen from cursor to the end
  def print_clear; print "\e[0J" end # Clear screen from cursor to the end
  def clear_up_to_cursor; puts "\e[1J" end # Clear screen up to the cursor
  def clear_all; puts "\e[2J" end # Clear entire screen

  def clear_from_cursor; print "\e[0K" end # Clear line from cursor to the end
  def clear_to_cursor; print "\e[1K" end # Clear line up to the cursor
  def clear_line; print "\e[2K" end # Clear entire line

  # Cursor operations

  def show_cursor; print "\e[?25h" end # show cursor
  def hide_cursor; print "\e[?25l" end # hide cursor

  def save_cursor; print "\e[s" end # save the position of the cursor
  def restore_cursor; print "\e[u" end # restore the position of the cursor
end