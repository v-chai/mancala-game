class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @player1 = name1
    @player2 = name2
    @cups = Array.new(14) {[:stone, :stone, :stone, :stone] }
    remove_stones
  end

  def remove_stones
    @cups[6] = []
    @cups[13] = []
  end

  def valid_move?(start_pos)
    if !(0..5).include?(start_pos) && !(7..12).include?(start_pos)
      raise "Invalid starting cup"
    elsif @cups[start_pos].length == 0
      raise "Starting cup is empty"
    else
      return true
    end
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos]
    @cups[start_pos] = []
    next_cup = start_pos
    until stones.empty?
      next_cup += 1
      next_cup = 0 if next_cup > 13
      if next_cup == 6
        @cups[next_cup] << stones.pop if current_player_name == @player1
      elsif next_cup == 13
        @cups[next_cup] << stones.pop if current_player_name == @player2
      else
        @cups[next_cup] << stones.pop
      end
    end

    self.render
    next_turn(next_cup)
    
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    elsif @cups[ending_cup_idx].count == 1
      :switch
    else
      ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all? {|cup| cup.empty?} || @cups[7..12].all? {|cup| cup.empty?}
  end

  def winner
    if @cups[6].length > @cups[13].length
      return @player1
    elsif @cups[6].length == @cups[13].length
      return :draw
    else
      return @player2
    end
  end
end
