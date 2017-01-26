# frozen_string_literal: true
module Api
  class RepsController < ApplicationController
    respond_to :json

    def index
      address = params[:address]
      lat     = params[:lat]
      long    = params[:long]
      # return the first result, or a random one
      @reps = if params
                Rep.find_em address: address, lat: lat, long: long
              else
                # Would like to find requesting IP address, geocode it and return the closest rep
                # request = Rack::Request.new Rails.env
                # result = request.location
                # @office = OfficeLocation.near(result.postal_code)
                # @reps = @office.rep
                []
              end
      # respond_with @reps

      render inline: MultiJson.dump(@reps), content_type: 'application/json'
    end
  end
end
