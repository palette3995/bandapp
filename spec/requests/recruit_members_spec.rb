require "rails_helper"

RSpec.describe "RecruitMembers" do
  let!(:user) { create(:user) }
  let!(:band) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user) }
  let!(:recruit_member) { create(:recruit_member, band: band) }
  let(:recruit_member_params) { attributes_for(:recruit_member, band_id: band.id) }
  let(:invalid_recruit_member_params) { attributes_for(:recruit_member, band_id: band.id, other_part: SecureRandom.alphanumeric(16)) }

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
      member = create(:recruit_member, band: create(:band))
      get edit_recruit_member_path(member)
      expect(response).to redirect_to user_bands_bands_path
    end
  end

  describe "POST #create" do
    before do
      sign_in user
      band_member
    end

    context "パラメータが適正な場合" do
      it "リクエストが成功すること" do
        post recruit_members_path, params: { recruit_member: recruit_member_params }
        expect(response).to have_http_status :found
      end

      it "createが成功すること" do
        expect do
          post recruit_members_path, params: { recruit_member: recruit_member_params }
        end.to change(RecruitMember, :count).by 1
      end

      it "リダイレクトされること" do
        post recruit_members_path, params: { recruit_member: recruit_member_params }
        expect(response).to redirect_to band_path(band)
      end
    end

    context "パラメータが不正な場合" do
      it "リクエストが422 unprocessable_entityになること" do
        post recruit_members_path, params: { recruit_member: invalid_recruit_member_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post recruit_members_path, params: { recruit_member: invalid_recruit_member_params }
        end.not_to change(RecruitMember, :count)
      end

      it "エラーが表示されること" do
        post recruit_members_path, params: { recruit_member: invalid_recruit_member_params }
        expect(response.body).to include "その他のパート名は15文字以内で入力してください"
      end
    end
  end
end
