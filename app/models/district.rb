class District < ApplicationRecord
  belongs_to :state, foreign_key: :state_code, primary_key: :state_code
  has_many :reps
end
