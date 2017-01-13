# frozen_string_literal: true
class QrCodesController < ActionController::Base
  def show
    if params[:id]
      @office = OfficeLocation.find(params[:id])
      @qr_code = @office.qr_code
    end
  end
end
