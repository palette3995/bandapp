require "rails_helper"

RSpec.describe "BandMembers" do
  let!(:user) { create(:user) }
  let!(:band) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user, role: "リーダー") }
  let(:band_member_a) { create(:band_member, band: band) }

  describe "GET band_members#edit" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
      end

      it "自分がリーダーのとき、リクエストが200 OKとなること" do
        band_member
        get edit_band_member_path(band_member)
        expect(response).to have_http_status :ok
      end

      it "自分がリーダーでないとき、所属バンド一覧ページに遷移すること" do
        create(:band_member, band: band, user: create(:user), role: "リーダー")
        band_member.role = "メンバー"
        get edit_band_member_path(band_member)
        expect(response).to redirect_to user_bands_bands_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get edit_band_member_path(band_member)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "DELETE band_members#destroy" do
    context "メンバーが三人以上のとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create(:band_member, band: band)
      end

      it "リクエストが成功すること" do
        delete band_member_path(band_member)
        expect(response).to have_http_status :found
      end

      it "リーダーが脱退すると、別のメンバーがリーダーになること" do
        delete band_member_path(band_member)
        expect(band_member_a.reload.role).to eq "リーダー"
      end

      it "リーダーが脱退すると、バンド一覧ページにリダイレクトされること" do
        delete band_member_path(band_member)
        expect(response).to redirect_to bands_path
      end

      it "リーダー以外が脱退すると、バンド詳細ページにリダイレクトされること" do
        delete band_member_path(band_member_a)
        expect(response).to redirect_to band_path(band)
      end
    end

    context "メンバーが二人以下のとき" do
      before do
        sign_in user
        band_member
        band_member_a
      end

      it "メンバーが一人以下になったとき、バンドごと削除されること" do
        expect do
          delete band_member_path(band_member)
        end.to change(BandMember, :count).by(-2)
                                         .and change(Band, :count).by(-1)
      end

      it "バンド一覧ページにリダイレクトされること" do
        delete band_member_path(band_member_a)
        expect(response).to redirect_to bands_path
      end
    end
  end
end
