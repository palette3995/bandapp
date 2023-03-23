require "rails_helper"

RSpec.describe "RecruitMembers" do
  let!(:user) { create(:user) }
  let!(:band) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user, part: part) }
  let!(:recruit_member) { create(:recruit_member, band: band, part: part) }
  let!(:part) { create(:other_inst) }

  describe "GET recruit_members#new" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        get new_recruit_member_path(band)
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "自分の所属バンド以外のページにアクセスしたとき、バンド一覧ページに遷移すること" do
        band_a = create(:band)
        get new_recruit_member_path(band_a)
        expect(response).to redirect_to user_bands_bands_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get new_recruit_member_path(band)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET recruit_members#edit" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        recruit_member
        band_member
        get edit_recruit_member_path(recruit_member)
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "自分の所属バンド以外のページにアクセスしたとき、バンド一覧ページに遷移すること" do
        member = create(:recruit_member, band: create(:band), part: part)
        get edit_recruit_member_path(member)
        expect(response).to redirect_to user_bands_bands_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get edit_recruit_member_path(band)
        expect(response).to have_http_status :found
      end
    end
  end
end
