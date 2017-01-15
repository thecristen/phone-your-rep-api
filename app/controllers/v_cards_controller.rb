class VCardsController < ApplicationController
  def show
    @office = OfficeLocation.find_with_rep(params.require(:id)).first
    @rep    = @office.rep

    send_data @office.v_card, filename: "#{@rep.official_full} #{@rep.state.abbr}.vcf"
  end
end
