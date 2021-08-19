require 'rails_helper'

# 認証済み管理者のみが管理ページにアクセスできること（ApplicationControllerのロジック）
# をテストするため、例としてUsersを取り上げる。
RSpec.describe "Admin::Users", type: :request do
  describe "GET /admin/users" do
    context "認証済み管理者の場合、" do
      it "ユーザー一覧ページにアクセスできる" do
        authenticated_admin = create(:administrator)
        sign_in authenticated_admin
        get admin_users_path
        expect(response.status).to eq 200
      end
    end

    context "認証されていない管理者の場合、" do
      it "ログインページへリダイレクトされる" do
        get admin_users_path
        expect(response.status).to eq 302
        expect(response).to redirect_to "/administrators/sign_in"
      end
    end
  end
end
