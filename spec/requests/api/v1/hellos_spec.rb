require 'rails_helper'

RSpec.describe "Hello", type: :request do
  describe "GET api/v1/hello" do
    it "works!" do
      get '/api/v1/hello'
      expect(response).to have_http_status(200)
    end
  end
end
