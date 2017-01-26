# frozen_string_literal: true
class RepsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:create, :update, :destroy]
  before_action :set_rep, only: [:show, :update, :destroy]

  # GET /reps
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
    @self = request.url
  end

  # GET /reps/1
  def show; end

  # POST /reps
  def create
    @rep = Rep.new(rep_params)

    if @rep.save
      render json: @rep, status: :created, location: @rep
    else
      render json: @rep.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reps/1
  def update
    if @rep.update(rep_params)
      render json: @rep
    else
      render json: @rep.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reps/1
  def destroy
    @rep.destroy
  end

  private

  def rep_params
    params.require(:rep).permit(:twitter)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_rep
    @rep = Rep.find_by(bioguide_id: params[:bioguide_id])
    @pfx = request.protocol + request.host_with_port
  end
end
