require "application_responder"

# frozen_string_literal: true
class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  self.responder = ApplicationResponder
  respond_to :json

end
