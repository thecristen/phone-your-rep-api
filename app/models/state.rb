class State < ApplicationRecord
  has_many :districts, foreign_key: :state_code, primary_key: :state_code
  has_many :reps, through: :districts
end
