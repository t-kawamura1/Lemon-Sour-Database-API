require 'rails_helper'

RSpec.describe LemonSour, type: :model do
  describe "存在性のバリデーション" do
    it "商品名があれば有効" do
      lemon_sour = build(:lemon_sour)
      expect(lemon_sour).to be_valid
    end

    it "商品名が無ければ無効" do
      lemon_sour = build(:lemon_sour, name: nil)
      lemon_sour.valid?
      expect(lemon_sour.errors.messages[:name]).to include "を入力してください"
    end
  end

  describe "scopeのテスト" do
    now = Time.now
    let!(:hyoketu) { create(:lemon_sour, updated_at: "#{now}") }
    let!(:strongzero) { create(:lemon_sour, :zero_sugar_sour, updated_at: "#{now.ago(2.days)}") }
    let!(:zeitakusibori) { create(:lemon_sour, :zero_sweetener_sour, updated_at: "#{now.ago(4.days)}") }
    let!(:lemon_sours) { [hyoketu, strongzero, zeitakusibori] }

    context ":for_manufacturerの場合" do
      it "引数が空であれば、何も処理しない" do
        expect(LemonSour.for_manufacturer("")).to eq lemon_sours
      end

      it "引数が「すべて」であれば、何も処理しない" do
        expect(LemonSour.for_manufacturer("すべて")).to eq lemon_sours
      end

      it "引数に指定されたメーカー名のデータを取得する" do
        expect(LemonSour.for_manufacturer("キリン")).to include hyoketu
        expect(LemonSour.for_manufacturer("サントリー")).to include strongzero
      end
    end

    context ":for_ingredientの場合" do
      it "引数が空であれば、何も処理しない" do
        expect(LemonSour.for_ingredient("")).to eq lemon_sours
      end

      it "引数が「すべて」であれば何も処理しない" do
        expect(LemonSour.for_ingredient("すべて")).to eq lemon_sours
      end

      it "引数に指定された成分のデータを取得する" do
        expect(LemonSour.for_ingredient("糖類ゼロ")).to include strongzero
        expect(LemonSour.for_ingredient("甘味料ゼロ")).to include zeitakusibori
      end
    end

    context ":for_orderの場合" do
      it "引数が空または「新着順」のとき、データが更新された降順で取得する" do
        expect(LemonSour.for_order("")).to eq [hyoketu, strongzero, zeitakusibori]
        expect(LemonSour.for_order("新着順")).to eq [hyoketu, strongzero, zeitakusibori]
      end

      it "引数に指定された順番でデータを取得する" do
        expect(LemonSour.for_order("度数の高い順")).to eq [strongzero, hyoketu, zeitakusibori]
        expect(LemonSour.for_order("度数の低い順")).to eq [zeitakusibori, hyoketu, strongzero]
        expect(LemonSour.for_order("カロリーの高い順")).to eq [strongzero, hyoketu, zeitakusibori]
        expect(LemonSour.for_order("カロリーの低い順")).to eq [zeitakusibori, hyoketu, strongzero]
        expect(LemonSour.for_order("果汁の多い順")).to eq [zeitakusibori, strongzero, hyoketu]
        expect(LemonSour.for_order("果汁の少ない順")).to eq [hyoketu, strongzero, zeitakusibori]
      end
    end

    context ":displayed_based_onの場合" do
      it "指定されたparamsの通りデータを取得する" do
        hyoketu_strong = create(:lemon_sour, name: "氷結ストロング", alcohol_content: 9)
        search_params = { manufacturer: "キリン", ingredient: "すべて", order: "度数の高い順" }
        lemon_sours.push(hyoketu_strong)
        expect(LemonSour.displayed_based_on(search_params)).to eq [hyoketu_strong, hyoketu]
      end
    end
  end
end
