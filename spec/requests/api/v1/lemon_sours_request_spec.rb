require 'rails_helper'

RSpec.describe "LemonSours API", type: :request do
  context "１件のレモンサワーデータを取得するとき" do
    it "リクエストが成功する" do
      lemon_sour = create(:lemon_sour)
      get "/api/v1/lemon_sours/#{lemon_sour.id}"
      json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(json["name"]).to eq(lemon_sour.name)
    end
  end

  context "全件取得するとき" do
    now = Time.now
    let!(:oldest_updated_sour) { create(:lemon_sour, name: "タカラcanチューハイ", updated_at: "#{now.ago(5.days)}") }
    let!(:yesterday_updated_sour) { create(:lemon_sour, name: "本搾り", updated_at: "#{now.yesterday}") }
    let!(:today_updated_sour) { create(:lemon_sour, name: "こだわり酒場のレモンサワー", updated_at: "#{now}") }

    before do
      get "/api/v1/lemon_sours"
      @json = JSON.parse(response.body)
    end

    it "リクエストが成功する" do
      expect(response.status).to eq 200
      expect(@json.length).to eq 3
    end

    it "データが更新された降順で取得される" do
      expect([
        @json[0]["name"],
        @json[1]["name"],
        @json[2]["name"],
      ]).to eq [
        "#{today_updated_sour.name}",
        "#{yesterday_updated_sour.name}",
        "#{oldest_updated_sour.name}",
      ]
    end

    context "あとで書く" do

    end
  end
end
