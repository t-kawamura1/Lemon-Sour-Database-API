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
end
