require "rails_helper"

RSpec.describe "Scouts" do
  let!(:user) { create(:user) }
  let!(:user_a) { create(:user) }
  let!(:band) { create(:band) }
  let!(:band_a) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user, part: part) }
  let(:band_member_a) { create(:band_member, band: band_a, user: user_a, part: part) }
  let!(:part) { create(:vocal) }

  describe "GET scouts#index" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        create(:scout, user: user_a, part: part, scouted_user: user, scouted_part: part)
        get scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("届いたスカウト一覧")
      end

      it "ユーザーから届いた新規バンド結成のスカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#received_join" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        create(:scout, user: user_a, part: part, scouted_user: user, scouted_band: band)
        get received_join_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("届いたスカウト一覧")
      end

      it "ユーザーから届いたバンド加入希望のスカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get received_join_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#received_offer" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member_a
        create(:scout, user: user_a, band: band_a, scouted_user: user, scouted_part: part)
        get received_offer_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("届いたスカウト一覧")
      end

      it "バンドから届いたメンバースカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get received_offer_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#received_marge" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create(:scout, user: user_a, band: band_a, scouted_user: user, scouted_band: band)
        get received_marge_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("届いたスカウト一覧")
      end

      it "バンドから届いた合併申請が表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get received_marge_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#send_new" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        create(:scout, user: user, part: part, scouted_user: user_a, scouted_part: part)
        get send_new_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("申請したスカウト一覧")
      end

      it "ユーザーへ送った新規バンド結成のスカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_new_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#send_join" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member_a
        create(:scout, user: user, part: part, scouted_user: user_a, scouted_band: band_a)
        get send_join_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("申請したスカウト一覧")
      end

      it "バンドへ送ったメンバー加入希望のスカウトが表示されていること" do
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_join_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#send_offer" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        create(:scout, user: user, band: band, scouted_user: user_a, scouted_part: part)
        get send_offer_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("申請したスカウト一覧")
      end

      it "ユーザーへ送ったバンドメンバースカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_offer_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#send_marge" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create(:scout, user: user, band: band, scouted_user: user_a, scouted_band: band_a)
        get send_marge_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("申請したスカウト一覧")
      end

      it "バンドへ送った合併申請が表示されていること" do
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_marge_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end
end
