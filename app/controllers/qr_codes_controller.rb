# frozen_string_literal: true
class QrCodesController < ActionController::Base
  def show
    if params[:id]
      @office = OfficeLocation.find(params[:id])
      @card = @office.make_vcard
      @qr = RQRCode::QRCode.new(@card.to_s, :size => 21, :level => :h)
    end
  end
end
