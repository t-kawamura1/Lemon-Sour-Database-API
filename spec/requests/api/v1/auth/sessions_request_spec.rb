require 'rails_helper'

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  let(:current_user) { create(:user) }

  describe "POST /auth/sign_in" do
    context "メールアドレス、パスワードが正しいとき" do
      it "ログインできる" do
        params = { email: current_user.email, password: current_user.password }
        post("/api/v1/auth/sign_in", params: params)
        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(json["data"]["name"]).to eq current_user.name
        expect(response.headers["access-token"]).to be_present
      end
    end

    context "パスワードが正しくないとき" do
      it "ログインに失敗する" do
        params = { email: current_user.email, password: "misutterude" }
        post("/api/v1/auth/sign_in", params: params)
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json["errors"]).to include "ログイン用の認証情報が正しくありません。再度お試しください。"
      end
    end
  end

  describe "DELETE /auth/sign_out" do
    context "リクエストヘッダーに必要な項目があるとき" do
      it "ログアウトできる" do
        headers = current_user.create_new_auth_token
        delete("/api/v1/auth/sign_out", headers: headers)
        expect(response.status).to eq 200
      end
    end

    context "リクエストヘッダーに必要な項目がないとき" do
      it "ログアウトに失敗する" do
        headers = nil
        delete("/api/v1/auth/sign_out", headers: headers)
        json = JSON.parse(response.body)
        expect(response.status).to eq 404
        expect(json["errors"]).to include "ユーザーが見つからないか、ログインしていません。"
      end
    end
  end
end
