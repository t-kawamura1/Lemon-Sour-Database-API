require 'rails_helper'

RSpec.describe "Api::v1::DrinkingRecords", type: :request do
  let!(:current_user) { create(:user) }
  let(:params) { {} }

  context "POST /drinking_records" do
    context "リクエストヘッダーに、ユーザー認証に必要な項目があり、かつ" do
      let(:headers) { current_user.create_new_auth_token }

      context "レモンサワー以外が入力されているとき" do
        it "飲酒記録の作成に成功する" do
          params[:drinking_record] = attributes_for(:drinking_record)
          params[:drinking_record][:user_id] = current_user.id
          params[:drinking_record][:lemon_sour_id] = nil
          post("/api/v1/drinking_records", params: params, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 200
          expect(json["pure_alcohol_amount"]).to eq DrinkingRecord.last.pure_alcohol_amount
        end
      end

      context "日付が入力されていないとき" do
        it "飲酒記録の作成に失敗する" do
          params[:drinking_record] = attributes_for(:drinking_record)
          params[:drinking_record][:drinking_date] = nil
          params[:drinking_record][:user_id] = current_user.id
          params[:drinking_record][:lemon_sour_id] = nil
          post("/api/v1/drinking_records", params: params, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(json).to include "飲んだ日付を入力してください"
        end
      end
    end

    context "リクエストヘッダーに、ユーザー認証に必要な項目がないとき" do
      it "リクエストに失敗する" do
        params[:drinking_record] = attributes_for(:drinking_record)
        params[:drinking_record][:user_id] = current_user.id
        params[:drinking_record][:lemon_sour_id] = nil
        post("/api/v1/drinking_records", params: params, headers: nil)
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json["errors"]).to include "認証資格が不足しています"
      end
    end
  end
end
