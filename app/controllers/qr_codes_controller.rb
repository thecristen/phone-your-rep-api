# frozen_string_literal: true
class QrCodesController < ActionController::Base
  def show
    if params[:id]
      @office = OfficeLocation.find(params[:id])
      @qr = RQRCode::QRCode.new(@office.v_card_link, :size => 6, :level => :h)
    end
  end
end
