class Issue < ApplicationRecord
  belongs_to :office_location

  validates :issue_type, :office_location_id, presence: true

  private

  # Tally of issues by category
  # {"Website is not working"=>1, "Office location moved"=>1, "Trouble downloading v-card"=>1, "Incorrect phone number"=>1, "Incorrect Email"=>1}
  def self.aggregate_issues
    Issue.group(:issue_type).count
  end

  # Array of unresolved issues reported by constituents
  def self.unresolved
    Issue.where(resolved: false)
  end
end
