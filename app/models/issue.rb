class Issue < ApplicationRecord
  belongs_to :office_location

  validates :type, :office_location, presence: true
end
