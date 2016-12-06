class ZipcodesController < ApplicationController
  before_action :set_zipcode, only: [:show, :update, :destroy]

  # GET /zipcodes
  def index
    # return a valid result, or a random one
    if params[:zip]
      @zipcode = Zipcode.find_by(zip: params[:zip])
    else
      @zipcode = Zipcode.order("RANDOM()").limit(1).first
    end

    @senator = @zipcode.senators.sample

    render json: @senator
  end

  # GET /zipcodes/1
  def show
    render json: @zipcode
  end

  # POST /zipcodes
  def create
    @zipcode = Zipcode.new(zipcode_params)

    if @zipcode.save
      render json: @zipcode, status: :created, location: @zipcode
    else
      render json: @zipcode.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /zipcodes/1
  def update
    if @zipcode.update(zipcode_params)
      render json: @zipcode
    else
      render json: @zipcode.errors, status: :unprocessable_entity
    end
  end

  # DELETE /zipcodes/1
  def destroy
    @zipcode.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zipcode
      @zipcode = Zipcode.find(params[:id])
    end
end
