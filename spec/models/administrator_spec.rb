require 'rails_helper'

RSpec.describe Administrator, type: :model do
  describe "存在性のバリデーション" do
    it "管理者名、メールアドレス、パスワードがあれば有効" do
      admin = build(:administrator)
      expect(admin).to be_valid
    end

    it "管理者名がないと無効" do
      admin = build(:administrator, name: nil)
      admin.valid?
      expect(admin.errors.messages[:name]).to include "を入力してください"
    end

    it "メールアドレスがないと無効" do
      admin = build(:administrator, email: nil)
      admin.valid?
      expect(admin.errors.messages[:email]).to include "を入力してください"
    end

    it "パスワードがないと無効" do
      admin = build(:administrator, password: nil)
      admin.valid?
      expect(admin.errors.messages[:password]).to include "を入力してください"
    end
  end

  describe "一意性のバリデーション" do
    it "既にそのメールアドレスが登録されている場合、同じメールアドレスは登録できない" do
      admin1 = create(:administrator)
      admin2 = build(:administrator, email: admin1.email)
      admin2.valid?
      expect(admin2.errors.messages[:email]).to include "が既に登録されています"
    end
  end

  describe "文字数のバリデーション" do
    it "パスワードが8文字未満だと無効" do
      admin = build(:administrator, password: "7mojida")
      admin.valid?
      expect(admin.errors.messages[:password]).to include "は8文字以上で入力してください"
    end

    it "パスワードが8文字以上であれば有効" do
      admin = create(:administrator, password: "8mojidayo")
      expect(admin).to be_valid
    end
  end
end
