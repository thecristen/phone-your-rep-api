class RepsController < ApplicationController
  before_action :set_rep, only: [:show, :update, :destroy]

  # GET /reps
  def index
    # return the first result, or a random one
    if params[:zipcode]
      @reps = Rep.where("zipcode LIKE ?", "#{params[:zipcode]}%").first
    else
      @reps = Rep.order("RANDOM()").limit(1)
    end

    render json: @reps
  end

  # GET /reps/1
  def show
    render json: @rep
  end

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
    # Use callbacks to share common setup or constraints between actions.
    def set_rep
      @rep = Rep.find(params[:id])
    end
end
