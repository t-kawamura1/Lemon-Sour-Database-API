require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  let(:current_user) { create(:user) }

  describe "POST /auth" do
    context "必要な項目が正しく入力されているとき" do
      it "ユーザー登録が成功する" do
        params = attributes_for(:user)
        post("/api/v1/auth", params: params)
        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(json["data"]["name"]).to eq User.last.name
      end
    end
  end

  describe "PUT /auth" do
    context "リクエストヘッダーに必要な項目があり、かつ" do
      let(:headers) { current_user.create_new_auth_token }

      context "ユーザー画像が入力されているとき" do
        it "ユーザーアカウントの更新が成功する" do
          params = { user_image: fixture_file_upload("spec/fixtures/test_user.jpg", 'image/jpg') }
          result_url = { "url" => a_kind_of(String) }
          put("/api/v1/auth", params: params, headers: headers)
          json = JSON.parse(response.body)
          p json
          expect(response.status).to eq 200
          expect(json["data"]["user_image"]).to match result_url
        end
      end

      context "ユーザー名、メールアドレス、現在のパスワードが入力されているとき" do
        it "ユーザーアカウントの更新が成功する" do
          params = { name: "ガオガイガー", email: "king_of_braves@gagaga.org", current_password: current_user.password }
          put("/api/v1/auth", params: params, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 200
          expect(json["data"]["name"]).to eq "ガオガイガー"
          expect(json["data"]["email"]).to eq "king_of_braves@gagaga.org"
          expect(response.headers["access-token"]).to eq headers["access-token"]
        end
      end

      context "現在のパスワードが入力されていないとき" do
        it "ユーザーアカウントの更新が失敗する" do
          params = { name: "ガオガイガー", email: "king_of_braves@gagaga.org", current_password: nil }
          put("/api/v1/auth", params: params, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(json["errors"]["current_password"]).to include "を入力してください"
        end
      end
    end

    context "リクエストヘッダーに必要な項目がないとき" do
      it "ユーザーアカウントの更新が失敗する" do
        params = { name: "ガオガイガー", email: "king_of_braves@gagaga.org", current_password: current_user.password }
        headers = nil
        put("/api/v1/auth", params: params, headers: headers)
        json = JSON.parse(response.body)
        expect(response.status).to eq 404
        expect(json["errors"]).to include "ユーザーが見つかりません。"
      end
    end
  end

  describe "DELETE /auth" do
    context "リクエストヘッダーに必要な項目があるとき" do
      it "ユーザーの削除に成功する" do
        headers = current_user.create_new_auth_token
        delete("/api/v1/auth", headers: headers)
        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(json["message"]).to include "のアカウントは削除されました。"
      end
    end

    context "リクエストヘッダーに必要な項目がないとき" do
      it "ユーザーの削除に失敗する" do
        headers = nil
        delete("/api/v1/auth", headers: headers)
        json = JSON.parse(response.body)
        expect(response.status).to eq 404
        expect(json["errors"]).to include "削除するアカウントが見つかりません。"
      end
    end
  end
end
