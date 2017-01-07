class VCardsController < ApplicationController

  def show
    if params[:id]
      @office = OfficeLocation.find_with_rep(params[:id]).first
      @rep    = @office.rep
      @card   = @office.make_vcard
    end

    send_data @card.to_s, :filename => "#{@rep.name} #{@rep.state.abbr}.vcf"
  end
end
