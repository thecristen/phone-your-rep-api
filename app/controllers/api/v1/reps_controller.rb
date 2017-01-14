module Api
  module V1
    class RepsController < ApplicationController
      respond_to :json

      def index
        respond_with Rep.all
      end

    end
  end
end
