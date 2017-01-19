require_relative '../config/environment.rb'

OfficeLocation.all.each(&:add_v_card)
