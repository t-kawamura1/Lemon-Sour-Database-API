require 'rails_helper'

RSpec.describe User, type: :model do
  describe "存在性のバリデーション" do
    it "ユーザー名、メールアドレス、パスワードがあれば有効" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "ユーザー名がないと無効" do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors.messages[:name]).to include "を入力してください"
    end

    it "メールアドレスがないと無効" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors.messages[:email]).to include "を入力してください"
    end

    it "パスワードがないと無効" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors.messages[:password]).to include "を入力してください"
    end
  end

  describe "一意性のバリデーション" do
    it "既にそのメールアドレスが登録されている場合、同じメールアドレスは登録できない" do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      user2.valid?
      expect(user2.errors.messages[:email]).to include "が既に登録されています"
    end
  end

  describe "文字数のバリデーション" do
    it "パスワードが8文字未満だと無効" do
      user = build(:user, password: "7mojida")
      user.valid?
      expect(user.errors.messages[:password]).to include "は8文字以上で入力してください"
    end

    it "パスワードが8文字以上であれば有効" do
      user = create(:user, password: "8mojidayo")
      expect(user).to be_valid
    end
  end

  describe "正規表現のバリデーションテスト" do
    context "メールアドレスについて" do
      it "先頭が＠だと無効" do
        user = build(:user, email: "@hoge@piyo.com")
        user.valid?
        expect(user.errors.messages[:email]).to include "は有効ではありません"
      end

      it "先頭以外に＠がないと無効" do
        user = build(:user, email: "hogepiyo.com")
        user.valid?
        expect(user.errors.messages[:email]).to include "は有効ではありません"
      end

      it "＠の直後に.があると無効" do
        user = build(:user, email: "hoge@.piyo.com")
        user.valid?
        expect(user.errors.messages[:email]).to include "は有効ではありません"
      end

      it "＠の直後より後に.がないと無効" do
        user = build(:user, email: "hoge@piyocom")
        user.valid?
        expect(user.errors.messages[:email]).to include "は有効ではありません"
      end

      it "＠の直後より後に.があり、その.以降にアルファベット小文字1文字以上ないと無効" do
        user1 = build(:user, email: "hoge@piyo.")
        user2 = build(:user, email: "hoge@piyo.5")
        user1.valid?
        expect(user1.errors.messages[:email]).to include "は有効ではありません"
        user2.valid?
        expect(user2.errors.messages[:email]).to include "は有効ではありません"
      end
    end
  end
end
