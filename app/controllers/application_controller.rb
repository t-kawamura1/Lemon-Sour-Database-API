class ApplicationController < ActionController::Base
  protect_from_forgery
  include DeviseTokenAuth::Concerns::SetUserByToken
end
