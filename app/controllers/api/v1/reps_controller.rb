module Api
  module V1
    class RepsController < ApplicationController
      respond_to :json

      def index
        address = params[:address]
        lat     = params[:lat]
        long    = params[:long]
        state   = params[:state]
        # return the first result, or a random one
        @reps = if params
                  Rep.find_em address: address, lat: lat, long: long, state: state
                else
                  # Would like to find requesting IP address, geocode it and return the closest rep
                  # request = Rack::Request.new Rails.env
                  # result = request.location
                  # @office = OfficeLocation.near(result.postal_code)
                  # @reps = @office.rep
                  []
                end
                respond_with @reps
      end

    end
  end
end
