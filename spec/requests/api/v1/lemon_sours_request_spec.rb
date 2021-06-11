require 'rails_helper'

RSpec.describe "LemonSours API", type: :request do

  describe "GET /show" do
    it "リクエストが成功する" do
      lemon_sour = FactoryBot.create(:lemon_sour)
      get api_v1_lemon_sour_path lemon_sour.id
      expect(response.content_type).to eq "application/json; charset=utf-8"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "リクエストが成功する" do
      get api_v1_lemon_sours_path
      expect(response).to have_http_status(:success)
    end
  end

end
