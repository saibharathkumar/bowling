class Frame < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates :try1 , :numericality => { :only_integer => true, :less_than_or_equal_to => 10,  :greater_than_or_equal_to => 0 }, :presence => true

  validates :try2 , :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :greater_than_or_equal_to => 0}, :presence => true

  validates :turn , :numericality => { :only_integer => true, :greater_than => 0, :less_than_or_equal_to => 10}, :presence => true

  validates_uniqueness_of :turn, scope: [:player_id, :game_id]

  validate :tries_valid?, :global_game_turn_valid?

  before_save :score_frame
  after_save :update_turn


  # calculate score for a frame and update total score in game score_board
  # Updates winner for each turn and ultimately the over all winner after all turns are finished.
  # updates status {strike, spare, none} for each frame played
  def score_frame
    self.score = self.try1 + self.try2
    if ((score) ==  10 && (self.try1 != 0 && self.try2 != 0))
      self.status = "spare"
    elsif ((score) ==  10 && (self.try1 == 0 || self.try2 == 0))
      self.status = "strike"
    else
      self.status = "none"
    end
    total_score = self.game.score_board[self.player_id]
    total_score += self.score

    if (self.turn > 1 && self.turn < 11)
      last_frame = Frame.where("turn = ? and player_id = ? and game_id = ?", (self.turn-1), self.player_id, self.game_id).last
      if (last_frame.status == "strike")
        new_score = last_frame.score + self.score
        last_frame.update_column(:score, new_score)
        total_score += self.score
      elsif (last_frame.status == "spare")
        new_score = last_frame.score + self.try1
        last_frame.update_column(:score, new_score)
        total_score += self.try1
      else
        total_score = total_score
      end
      self.game.score_board.merge!(self.player_id => total_score)
    else
      self.game.score_board.merge!(self.player_id => total_score)
    end

    if self.game.winner.empty?
      self.game.winner = {self.player_id => total_score}
    else
      if total_score > self.game.winner.values.first
        self.game.winner = {self.player_id => total_score}
      end
    end
    self.game.save!
  end

  # idempotent method, so we don't care if it is called multiple times after frame save
  # Updates game turn next turn play once all players have played their chances
  def update_turn
    if(self.game.game_turn != 10 && (Frame.where('turn = ? and game_id = ?', self.game.game_turn , self.game_id).count == self.game.players))
      self.game.game_turn += 1
      self.game.save
    end
  end

  private
  # Checks for frame turn and game turn equality
  # makes sure each player in a game is at the same turn and completes that turn along with other players
  def global_game_turn_valid?
    if !(self.turn == self.game.game_turn)
      errors.add(:base, "Invalid turn: #{self.turn}. Cannot play another turn until other players finish their turn.")
    end
  end

   #Checks if tries are valid for each player
  def tries_valid?
    if(self.try1 != nil && self.try2 != nil)
      if ((self.try1 +  self.try2 ) > 10 )
        errors.add(:base, 'Enter valid pin entries for each tries')
      end
      if ((self.try1 == 10 && self.try2 != 0) || (self.try2 == 10 && self.try1 != 0))
        errors.add(:base,'In case of strike mark other pin as 0')
      end
    end
  end
end
