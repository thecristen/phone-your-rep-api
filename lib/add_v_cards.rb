# frozen_string_literal: true
require_relative '../config/environment.rb'

OfficeLocation.all.each(&:add_v_card)
