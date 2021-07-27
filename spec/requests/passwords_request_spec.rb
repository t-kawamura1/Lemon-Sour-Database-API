require 'rails_helper'

RSpec.describe "Api::V1::Auth::Passwords", type: :request do
  let(:not_login_user) { create(:user) }
  let(:redirect_url) { "http://testhost:666" }

  describe "POST /auth/password" do
    context "メールアドレスが入力され、リダイレクトURLがリクエスト中に含まれるとき" do
      it "リクエストが成功し、パスワードリセットメールが送信される" do
        params = { email: not_login_user.email, redirect_url: redirect_url }
        expect { post("/api/v1/auth/password", params: params) }.to change { ActionMailer::Base.deliveries.size }.by(1)
        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(json["message"]).to include "にパスワードリセットの案内が送信されました。"
      end
    end

    context "メールアドレスが入力されていないとき" do
      it "リクエストが失敗する" do
        params = { email: nil, redirect_url: redirect_url }
        post("/api/v1/auth/password", params: params)
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json["errors"]).to include "メールアドレスが与えられていません。"
      end
    end

    context "登録されていないメールアドレスが入力されたとき" do
      it "リクエストが失敗する" do
        params = { email: "not_registered@whoare.you", redirect_url: redirect_url }
        post("/api/v1/auth/password", params: params)
        json = JSON.parse(response.body)
        expect(response.status).to eq 404
        expect(json["errors"].to_s).to include "ユーザーが見つかりません。"
      end
    end
  end

  describe "GET /auth/password/edit" do
    context "PUT /auth/passwordの処理が正しければ" do
      it "リクエストが成功し、リダイレクトされる" do
        params_for_post_password = { email: not_login_user.email, redirect_url: redirect_url }
        post("/api/v1/auth/password", params: params_for_post_password)
        mail = ActionMailer::Base.deliveries.last
        url_in_mail = extract_confirmation_url(mail)
        get url_in_mail
        expect(response.status).to eq 302
        expect(User.last.allow_password_change).to be true
      end
    end
  end

  describe "PUT /auth/password" do
    context "リクエストヘッダーに必要な項目があり、かつ" do
      let(:headers) { not_login_user.create_new_auth_token }

      context "有効なパスワードとパスワード確認が入力されていれば" do
        it "パスワードリセットが成功する" do
          not_login_user.allow_password_change = true
          params = { password: "validpass", password_confirmation: "validpass" }
          put("/api/v1/auth/password", params: params, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 200
          expect(json["message"]).to include "パスワードの更新に成功しました。"
        end
      end

      context "パスワード、パスワード確認の入力がないとき" do
        it "パスワードリセットに失敗する" do
          not_login_user.allow_password_change = true
          params = { password: nil, password_confirmation: nil }
          put("/api/v1/auth/password", params: params, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(json["errors"]).to include "'Password', 'Password confirmation' パラメータが与えられていません。"
        end
      end

      context "パスワードとパスワード確認が一致しないとき" do
        it "パスワードリセットに失敗する" do
          not_login_user.allow_password_change = true
          params = { password: "wninniku", password_confirmation: "ninnikunome" }
          put("/api/v1/auth/password", params: params, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(json["errors"]["full_messages"]).to include "パスワード（確認用）とパスワードの入力が一致しません"
        end
      end
    end

    context "リクエストヘッダーに必要な項目がないとき" do
      let(:headers) { nil }

      it "パスワードリセットに失敗する" do
        not_login_user.allow_password_change = true
        params = { password: "validpass", password_confirmation: "validpass" }
        put("/api/v1/auth/password", params: params, headers: headers)
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json["errors"]).to include "Unauthorized"
      end
    end
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end
end
