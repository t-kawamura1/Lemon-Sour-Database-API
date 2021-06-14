require 'rails_helper'

RSpec.describe "LemonSours API", type: :request do
  describe "１件のレモンサワーデータを取得するとき" do
    it "リクエストが成功する" do
      lemon_sour = create(:lemon_sour)
      get "/api/v1/lemon_sours/#{lemon_sour.id}"
      json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(json["data"]["name"]).to eq(lemon_sour.name)
    end
  end

  describe "全件取得するとき" do
    it "リクエストが成功する" do
      create_list(:lemon_sour, 3)
      get "/api/v1/lemon_sours"
      json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(json["data"].length).to eq 3
    end

    it "データが更新された降順で取得される" do
      now = Time.now
      oldest_updated_sour = create(
        :lemon_sour,
        name: "タカラcanチューハイ",
        updated_at: "#{now.ago(5.days)}",
      )
      yesterday_updated_sour = create(
        :lemon_sour,
        name: "本搾り",
        updated_at: "#{now.yesterday}",
      )
      today_updated_sour = create(
        :lemon_sour,
        name: "こだわり酒場のレモンサワー",
        updated_at: "#{now}",
      )

      get "/api/v1/lemon_sours"
      json = JSON.parse(response.body)
      expect([json["data"][0]["name"], json["data"][1]["name"], json["data"][2]["name"]]).to eq
      ["#{today_updated_sour.name}", "#{yesterday_updated_sour.name}", "#{oldest_updated_sour.name}"]
    end
  end
end
