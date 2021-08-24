require 'rails_helper'

RSpec.describe DrinkingRecord, type: :model do
  describe "存在性のバリデーション" do
    it "ユーザーID、飲んだ日付、純アルコール量、飲酒量があれば有効" do
      drinking_record = build(:drinking_record, lemon_sour: nil)
      expect(drinking_record).to be_valid
    end

    it "ユーザーIDがないと無効" do
      drinking_record = build(:drinking_record, user: nil)
      drinking_record.valid?
      expect(drinking_record.errors.messages[:user]).to include "を入力してください"
    end

    it "飲んだ日付がないと無効" do
      drinking_record = build(:drinking_record, drinking_date: nil)
      drinking_record.valid?
      expect(drinking_record.errors.messages[:drinking_date]).to include "を入力してください"
    end

    it "純アルコール量がないと無効" do
      drinking_record = build(:drinking_record, pure_alcohol_amount: nil)
      drinking_record.valid?
      expect(drinking_record.errors.messages[:pure_alcohol_amount]).to include "を入力してください"
    end

    it "飲酒量がないと無効" do
      drinking_record = build(:drinking_record, drinking_amount: nil)
      drinking_record.valid?
      expect(drinking_record.errors.messages[:drinking_amount]).to include "を入力してください"
    end
  end

  describe "scopeのテスト" do
    let!(:hyoketu)  { create(:lemon_sour) }
    let!(:kodawari) { create(:lemon_sour, name: "こだわり") }
    let!(:strong)   { create(:lemon_sour, :zero_sugar_sour) }
    let!(:zeitaku)  { create(:lemon_sour, :zero_sweetener_sour) }
    let!(:rec_20210803)             { create(:drinking_record, lemon_sour_id: hyoketu.id) }
    let!(:rec_20210803_drinking350) { create(:drinking_record, drinking_amount: 350, lemon_sour_id: hyoketu.id) }
    let!(:rec_20210804)             { create(:drinking_record, drinking_date: "2021-08-04", lemon_sour_id: hyoketu.id) }
    let!(:rec_20210804_alcohol5)    { create(:drinking_record, drinking_date: "2021-08-04", pure_alcohol_amount: 5, lemon_sour_id: strong.id) }
    let!(:rec_20210805_alcohol40)   { create(:drinking_record, drinking_date: "2021-08-05", pure_alcohol_amount: 40, lemon_sour_id: strong.id) }
    let!(:rec_20210806_alcohol30)   { create(:drinking_record, drinking_date: "2021-08-06", pure_alcohol_amount: 30, lemon_sour_id: strong.id) }
    let!(:rec_20210807)             { create(:drinking_record, drinking_date: "2021-08-07", lemon_sour_id: kodawari.id) }
    let!(:rec_20210808_alcohol25)   { create(:drinking_record, drinking_date: "2021-08-08", pure_alcohol_amount: 28.5, lemon_sour_id: kodawari.id) }
    let!(:rec_20210808)             { create(:drinking_record, drinking_date: "2021-08-08", lemon_sour_id: zeitaku.id) }
    let!(:rec_20210809)             { create(:drinking_record, drinking_date: "2021-08-09", pure_alcohol_amount: 0, lemon_sour_id: strong.id) }
    let!(:rec_20210810)             { create(:drinking_record, drinking_date: "2021-08-10", pure_alcohol_amount: 0, lemon_sour_id: strong.id) }

    context ":total_pure_alcohol_by_dateの場合" do
      it "飲んだ日付ごとに純アルコール量と飲酒量が合算され、飲んだ日付の昇順でデータを取得する" do
        result = DrinkingRecord.total_pure_alcohol_by_date
        expect(result.length).to eq 8
        expect(result[0].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-03"
        expect(result[5].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-08"
        expect(result[0].total_drinking).to eq 850
        expect(result[1].total_pure_alcohol).to eq 17.5
      end
    end

    context ":pure_alcohol_amount_specifiedの場合" do
      it ":total_pure_alcohol_by_dateの条件に加え、引数に指定された純アルコール量のデータを取得する" do
        result = DrinkingRecord.pure_alcohol_amount_specified(0)
        expect(result.length).to eq 2
        expect(result[0].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-09"
        expect(result[1].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-10"
      end
    end

    context ":pure_alcohol_amount_greater_than_and_less_thanの場合" do
      it ":total_pure_alcohol_by_dateの条件に加え、純アルコール量が第一引数より大きく、第二引数より少ないデータを取得する" do
        result = DrinkingRecord.pure_alcohol_amount_greater_than_and_less_than(0, 20)
        expect(result.length).to eq 2
        expect(result[0].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-04"
        expect(result[1].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-07"
      end
    end

    context ":pure_alcohol_amount_less_thanの場合" do
      it ":total_pure_alcohol_by_dateの条件に加え、純アルコール量が第一引数以上、第二引数未満のデータを取得する" do
        result = DrinkingRecord.pure_alcohol_amount_between(20, 40)
        expect(result.length).to eq 2
        expect(result[0].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-03"
        expect(result[1].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-06"
      end
    end

    context ":pure_alcohol_amount_or_moreの場合" do
      it ":total_pure_alcohol_by_dateの条件に加え、純アルコール量が引数より少ないデータを取得する" do
        result = DrinkingRecord.pure_alcohol_amount_or_more(40)
        expect(result.length).to eq 2
        expect(result[0].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-05"
        expect(result[1].drinking_date.strftime("%Y-%m-%d")).to eq "2021-08-08"
      end
    end

    context ":count_sour_nameの場合" do
      it "レモンサワーが登録されていないデータを除き、その名前ごとに本数を集計し、名前と本数のデータを引数の件数分、本数の降順で取得する" do
        result = DrinkingRecord.count_sour_name(3)
        expect(result.length).to eq 3
        expect(result[0].name).to eq "ストロングゼロ"
        expect(result[2].name).to eq "こだわり"
      end
    end

    context ":sum_amouts_by_year_monthの場合" do
      let!(:rec_20210901) { create(:drinking_record, drinking_date: "2021-09-01") }
      let!(:rec_20210902) { create(:drinking_record, drinking_date: "2021-09-02") }

      it "飲んだ日付を月日の形式に変換し、その日付ごとに純アルコール量と飲酒量が合算されたデータを取得する" do
        result = DrinkingRecord.sum_amouts_by_year_month
        expect(result.length).to eq 2
        expect(result[0].year_month).to eq "2021-08"
        expect(result[1].year_month).to eq "2021-09"
        expect(result[0].total_drinking).to eq 5350
        expect(result[1].total_pure_alcohol).to eq 25
      end
    end
  end
end
