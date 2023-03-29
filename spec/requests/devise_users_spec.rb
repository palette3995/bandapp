require "rails_helper"

RSpec.describe "UserAuthentications" do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, name: "") }

  describe "POST #create" do
    context "パラメータが適正な場合" do
      it "リクエストが303 see_otherになること" do
        post user_registration_path, params: { user: user_params }
        expect(response).to have_http_status :see_other
      end

      it "createが成功すること" do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end

      it "リダイレクトされること" do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to users_path
      end
    end

    context "パラメータが不正な場合" do
      it "リクエストが422 unprocessable_entityになること" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.not_to change(User, :count)
      end

      it "エラーが表示されること" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include "名前を入力してください"
      end
    end
  end
end
