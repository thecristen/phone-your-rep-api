# frozen_string_literal: true
class QrCodesController < ActionController::Base
  protect_from_forgery

  def show
    if params[:id]
      @office = OfficeLocation.find(params[:id])
      @qr_code = @office.qr_code
    end
  end
end
