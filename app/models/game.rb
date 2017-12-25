class Game < ApplicationRecord
  serialize :score_board
  serialize :winner
  serialize :player

  has_many :frames

  validates :players , :numericality => { :only_integer => true, :less_than_or_equal_to => 5, :greater_than_or_equal_to => 1}, :presence => true
  validates_presence_of :players

  # initialises the score board and turn value
  def init
    self.score_board = {}
    self.winner = {}
    self.game_turn = 1
  end

  # Adds players to game
  def add_players(players_list=[])
    self.init()
    players_list.each do |player|
      self.score_board[player.to_i] = 0
    end
    self.players = players_list.size
  end

end
