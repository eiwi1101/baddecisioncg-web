class ApplicationController < ActionController::Base
  include SessionsHelper
  include CollectionHelper
  include SlackHelper

  respond_to :json, :html, :js

  protect_from_forgery with: :exception

  rescue_from Exception, with: :internal_server_error

  private

  def internal_server_error(e)
    if Rails.configuration.x.slack['post_exceptions']
      slackify_exception e, current_user, request
    end

    raise e
  end
end
