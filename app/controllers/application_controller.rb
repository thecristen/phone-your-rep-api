# frozen_string_literal: true
require 'application_responder'

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  self.responder = ApplicationResponder
  respond_to :json

  before_action :set_prefix

  private

  def set_prefix
    @pfx = request.protocol + request.host_with_port
  end
end
