class VCardsController < ApplicationController
  def show
    return unless params[:id]
    @office = OfficeLocation.find_with_rep(params[:id]).first
    @rep    = @office.rep

    send_data @office.v_card, filename: "#{@rep.official_full} #{@rep.state.abbr}.vcf"
  end
end
