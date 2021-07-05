require 'rails_helper'

RSpec.describe "LemonSours API", type: :request do
  now = Time.now
  let!(:hyoketu) { create(:lemon_sour, updated_at: "#{now}") }
  let!(:hyoketu_strong) { create(:lemon_sour, name: "氷結ストロング", alcohol_content: 9, updated_at: "#{now.yesterday}") }
  let!(:zeitakusibori) do
    create(
      :lemon_sour, name: "贅沢絞り",
                   manufacturer: "アサヒ",
                   alcohol_content: 4,
                   updated_at: "#{now.ago(2.days)}"
    )
  end

  context "GET /lemon_sour/:id" do
    it "１件のレモンサワーを取得する" do
      get "/api/v1/lemon_sours/#{hyoketu.id}"
      json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(json["name"]).to eq(hyoketu.name)
    end
  end

  context "GET /lemon_sours" do
    before do
      get "/api/v1/lemon_sours"
      @json = JSON.parse(response.body)
    end

    it "全件取得する" do
      expect(response.status).to eq 200
      expect(@json.length).to eq 3
    end

    it "データが更新された降順で取得される" do
      expect([
        @json[0]["name"],
        @json[1]["name"],
        @json[2]["name"],
      ]).to eq [
        hyoketu.name,
        hyoketu_strong.name,
        zeitakusibori.name,
      ]
    end

    context "GET /lemon_sours/search_by" do
      it "クエリパラメータの指定のとおりにデータが取得される" do
        # manufacturer="キリン", ingredient="すべて", order="度数の高い順"をエンコードしている
        get "/api/v1/lemon_sours/search_by?manufacturer=%E3%82%AD%E3%83%AA%E3%83%B3&
          ingredient=%E3%81%99%E3%81%B9%E3%81%A6&order=%E5%BA%A6%E6%95%B0%E3%81%AE%E9%AB%98%E3%81%84%E9%A0%86"
        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(json.length).to eq 2
        expect([json[0]["name"], json[1]["name"]]).to eq [hyoketu_strong.name, hyoketu.name]
      end
    end
  end
end
