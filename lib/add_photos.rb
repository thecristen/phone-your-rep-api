require_relative '../config/environment.rb'

Rep.all.each { |rep| rep.update(photo: "https://theunitedstates.io/images/congress/450x550/#{rep.bioguide_id}.jpg") }