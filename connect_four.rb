require 'colorize'

class Board
	
  attr_accessor :paths
  attr_reader :rows, :columns, :winner, :grid
	
  def initialize
	@grid = create_board
	@rows = ("A".."F").to_a
	@columns = ("1".."7").to_a
	@paths = {:N =>[-1,0],:NE =>[-1,1],:E =>[0,1],:SE =>[1,1],:S =>[1,0],:SW =>[1,-1],:W =>[0,-1],:NW =>[-1,-1]}
  end

  def cell(a1,column = nil)
	a1.is_a?(String) ? @grid[@rows.index(a1[0].upcase)][@columns.index(a1[1])] : @grid[a1][column]
  end

  def offset(cell_x_y, x_offset, y_offset)
	@grid[cell_x_y.row + x_offset][cell_x_y.column + y_offset]
  end

  private
	
  def look_for_wins(cell)
    cell.sequence(:N) if cell.row > 2    
    cell.sequence(:NE) if (cell.row > 2) && (cell.column < 4)
    cell.sequence(:E) if cell.column < 4
    cell.sequence(:SE) if (cell.row < 3) && (cell.column < 4)
    cell.sequence(:S) if cell.row < 3
	cell.sequence(:SW) if (cell.row < 3) && (cell.column > 2)
	cell.sequence(:W) if (cell.column > 2)
	cell.sequence(:NW) if (cell.row > 2) && (cell.column > 2)
  end
  
  def create_board
	board = Array.new(6){Array.new(7)}
	board.each_with_index do |row,rindex|
	  row.each_index do |cindex|
		board[rindex][cindex] = Cell.new({:row => rindex,:column => cindex})
		look_for_wins(board[rindex][cindex])
	  end
	end
	board
  end
  
end

class Player
  attr_accessor :symbol, :name, :color, :moves

  def initialize
    @name = nil
	@symbol = nil
	@moves = []
  end

  def add_move(cell)
	@moves << cell
  end
end

class Cell

  attr_accessor :state
  attr_reader :row, :column, :search_paths
	
  def initialize(args)
    @state = " " 
	@row = args[:row] 
	@column = args[:column]
	@search_paths = [] 
  end

  def sequence(path)
	@search_paths << path
  end
	
end

class Game
	
  attr_accessor :p1,:p2, :current_player, :second_player, :board

  def initialize
	@board = Board.new 
	@p1 = Player.new 
	@p2 = Player.new 
	@current_player = first_turn
	@second_player = second_player
	@game_over = false 
	@winner = nil
	@moves_remaining = 42 
  end
	
  def start_game
    puts "Welcome to Connect Four"
	
	puts "\nPlayer 1, please enter your name: "
	@p1.name = gets.chomp
	puts "\nPlayer 2, please enter your name: "
	@p2.name = gets.chomp
    puts "\n"
	
	assign_symbols

	puts "#{@current_player.name} will go first, and their symbol is #{@current_player.symbol}."
    puts "#{@second_player.name} will go second, and their symbol is #{@second_player.symbol}."
	puts "\n"

  end

  def assign_symbols
	@p1.symbol = ["X".red, "O".blue].shuffle.first
	@p2.symbol = (@p1.symbol == "X".red) ? "O".blue : "X".red
  end

  def first_turn
	[@p1, @p2].shuffle.first
  end

  def second_player
	@current_player == @p1 ? @p2 : @p1
  end

  def take_turns
	buffer = @current_player
	@current_player = @second_player
	@second_player = buffer
  end

  def state(pos)
	@board.cell(pos).state
  end

  def print_board
    @letter = "A"
	@num = 1
	puts "==============================="
   
    while @letter < "G"
      print "||"
      while @num < 8
        print " #{state("#{@letter}#{@num}")} |"
        @num += 1
      end
    
	  puts "|"
      puts "-------------------------------"
      @letter = @letter.next.ord.chr
      @num = 1
    end
  
    puts "   1   2   3   4   5   6   7   "
  
  end

  def new_line
	puts "\n"
  end

  def legal_move(column)
  
	if (1..7).include?(column)
	  for i in 0..5
	  
		if (i == 5) && (@board.cell(0, column-1).state != " ")
	  	  print "That column is full! Pick a different column: "
		  input = gets.chomp.to_i
		  legal_move(input)
		end
		
		if @board.cell(5 - i, column - 1).state == " "
		  @board.cell(5 - i, column - 1).state = @current_player.symbol 
		  @current_player.add_move(@board.cell(5 - i, column - 1)) 
		  break	
	    end
		
	  end
	  
	else
      print "Please enter a valid column number:"
	  input = gets.chomp.to_i
	  legal_move(input)	
	end
	
  end
	
  def turn
	puts "\nIt is #{@current_player.name}'s turn. You can move by entering a column number(1-7): "
	number = gets.chomp.to_i
	legal_move(number)
	check_win
	take_turns
  end

  def check_win

	@current_player.moves.each do |m|
	  m.search_paths.each do |p|
	    counter = 1
		for i in 1..3
		  counter += 1 if @current_player.moves.any?{|x| x == @board.offset(m, i*(@board.paths[p][0]), i*(@board.paths[p][1]))}
		  if counter == 4
		    @game_over = true
			@winner = @current_player
			break
		  end
		end
	  end
	end

	@game_over = true if (@game_over == false) && (@p1.moves.length + @p2.moves.length == 42)

  end

  def play
	new_line
	start_game
	
	while @game_over == false
	  print_board
	  turn
      new_line
	end
	
	print_board
	
	if @winner==nil
	  puts "\nDraw!"
	else
	  puts "\nCongratulations #{@winner.name}, you've won!"
	end
  end
  
end

game = Game.new
game.play