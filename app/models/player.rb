class Player < ApplicationRecord
	has_many :frames
	validates :name, presence: true, allow_blank: false
end
