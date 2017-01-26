# frozen_string_literal: true
class StateGeom < ApplicationRecord
  extend Geographic::ClassMethods
  include Geographic::InstanceMethods

  belongs_to :state, foreign_key: :state_code, primary_key: :state_code
end
