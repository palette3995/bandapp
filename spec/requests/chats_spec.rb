require "rails_helper"

RSpec.describe "Chat" do
  let!(:user) { create(:user) }
  let!(:band) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user, part: part, role: "リーダー") }
  let!(:part) { create(:other_inst) }

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
end
