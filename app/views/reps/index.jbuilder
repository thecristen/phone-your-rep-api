# frozen_string_literal: true

json.array! @reps do |rep|
  json.partial! 'rep', rep: rep
end
