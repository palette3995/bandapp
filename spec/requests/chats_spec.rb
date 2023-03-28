require "rails_helper"

RSpec.describe "Chat" do
  let!(:user) { create(:user) }
  let!(:band) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user) }
  let(:chat_params) { attributes_for(:chat, band_id: band.id, user_id: user.id) }
  let(:invalid_chat_params) { attributes_for(:chat, band_id: band.id, user_id: user.id, message: SecureRandom.alphanumeric(501)) }

  describe "GET chats#show" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
      end

      it "自分がバンドメンバーのとき、リクエストが200 OKとなること" do
        band_member
        get chat_path(band)
        expect(response).to have_http_status :ok
      end

      it "自分がバンドメンバーでないとき、所属バンド一覧ページに遷移すること" do
        get chat_path(band)
        expect(response).to redirect_to user_bands_bands_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get chat_path(band)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "POST #create" do
    before do
      sign_in user
      band_member
    end

    context "パラメータが適正な場合" do
      it "リクエストが成功すること" do
        post chats_path, params: { chat: chat_params }
        expect(response).to have_http_status :found
      end

      it "createが成功すること" do
        expect do
          post chats_path, params: { chat: chat_params }
        end.to change(Chat, :count).by 1
      end

      it "リダイレクトされること" do
        post chats_path, params: { chat: chat_params }
        expect(response).to redirect_to chat_path(band)
      end
    end

    context "パラメータが不正な場合" do
      it "リクエストが422 unprocessable_entityになること" do
        post chats_path, params: { chat: invalid_chat_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post chats_path, params: { chat: invalid_chat_params }
        end.not_to change(Chat, :count)
      end

      it "エラーが表示されること" do
        post chats_path, params: { chat: invalid_chat_params }
        expect(response.body).to include "メッセージは500文字以内で入力してください"
      end
    end
  end
end
