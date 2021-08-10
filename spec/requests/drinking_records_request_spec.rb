require 'rails_helper'

RSpec.describe "Api::v1::DrinkingRecords", type: :request do
  let!(:current_user) { create(:user) }
  let(:params) { {} }
  let!(:hyoketu)  { create(:lemon_sour) }
  let!(:kodawari) { create(:lemon_sour, name: "こだわり") }
  let!(:strong)   { create(:lemon_sour, :zero_sugar_sour) }
  let!(:rec_20210803) { create(:drinking_record, lemon_sour_id: hyoketu.id, user_id: current_user.id) }
  let!(:rec_20210804) { create(:drinking_record, drinking_date: "2021-08-04", pure_alcohol_amount: 21, lemon_sour_id: kodawari.id, user_id: current_user.id) }
  let!(:rec_20210907) { create(:drinking_record, drinking_date: "2021-09-07", pure_alcohol_amount: 41, lemon_sour_id: strong.id, user_id: current_user.id) }

  context "GET /drinking_records/:id" do
    context "リクエストヘッダーに、ユーザー認証に必要な項目があれば、" do
      let(:headers) { current_user.create_new_auth_token }

      it "飲酒記録の取得に成功する" do
        get("/api/v1/drinking_records/#{current_user.id}", headers: headers)
        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(json.length).to eq 4
        expect(json[0][0]["total_pure_alcohol"]).to eq 12.5
        expect(json[1][0]["total_pure_alcohol"]).to eq 21
        expect(json[2][0]["total_pure_alcohol"]).to eq 41
        expect(json[3].length).to eq 3
      end
    end

    context "リクエストヘッダーに、ユーザー認証に必要な項目がないとき" do
      it "リクエストに失敗する" do
        get("/api/v1/drinking_records/#{current_user.id}", headers: nil)
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json["errors"]).to include "認証資格が不足しています"
      end
    end

    context "GET /drinking_records/amounts_by_month" do
      context "リクエストヘッダーに、ユーザー認証に必要な項目があれば、" do
        let(:headers) { current_user.create_new_auth_token }

        it "年月ごとの飲酒記録のデータ取得に成功する" do
          get("/api/v1/drinking_records/amounts_by_month", headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 200
          p json
          expect(json.length).to eq 2
          expect(json[0]["year_month"]).to eq "2021-08"
          expect(json[1]["year_month"]).to eq "2021-09"
        end
      end

      context "リクエストヘッダーに、ユーザー認証に必要な項目がないとき" do
        it "リクエストに失敗する" do
          get("/api/v1/drinking_records/amounts_by_month", headers: nil)
          json = JSON.parse(response.body)
          expect(response.status).to eq 401
          expect(json["errors"]).to include "認証資格が不足しています"
        end
      end
    end

    context "リクエストヘッダーに、ユーザー認証に必要な項目がないとき" do
      it "リクエストに失敗する" do
        get("/api/v1/drinking_records/#{current_user.id}", headers: nil)
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json["errors"]).to include "認証資格が不足しています"
      end
    end
  end

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

  context "DELETE /drinking_records" do
    context "リクエストヘッダーに、ユーザー認証に必要な項目があり、かつ" do
      let(:headers) { current_user.create_new_auth_token }

      context "飲んだ日付が入力されているとき" do
        it "飲酒記録の削除に成功し、日付ごとに量を合計したデータが返ってくるが、削除した記録は含まれない" do
          params[:drinking_date] = "2021-08-04"
          delete("/api/v1/drinking_records/delete", params: params, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 200
          expect(json.length).to eq 3
          expect(json[1].length).to eq 0
        end
      end

      context "飲んだ日付が入力されていないとき" do
        it "飲酒記録の削除に失敗する" do
          delete("/api/v1/drinking_records/delete", params: nil, headers: headers)
          json = JSON.parse(response.body)
          expect(response.status).to eq 404
          expect(json["error_message"]).to eq "該当する記録がありません"
        end
      end
    end

    context "リクエストヘッダーに、ユーザー認証に必要な項目がないとき" do
      it "リクエストに失敗する" do
        params[:drinking_date] = "2021-08-04"
        get("/api/v1/drinking_records/delete", params: params, headers: nil)
        json = JSON.parse(response.body)
        expect(response.status).to eq 401
        expect(json["errors"]).to include "認証資格が不足しています"
      end
    end
  end
end
