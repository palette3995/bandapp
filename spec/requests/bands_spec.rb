require "rails_helper"

RSpec.describe "Bands" do
  let!(:user) { create(:user) }
  let!(:band) { create(:band) }
  let(:band_member) { create(:band_member, user: user, band: band, role: "リーダー") }

  describe "GET bands#index" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        get bands_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "見出しが正しく表示されること" do
        expect(response.body).to include("平均年齢が近いバンド")
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get bands_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET bands#match_ages" do
    before do
      sign_in user
      get match_ages_bands_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("平均年齢が近いバンド")
    end
  end

  describe "GET bands#match_genres" do
    before do
      sign_in user
      get match_genres_bands_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("ジャンルが同じなバンド")
    end
  end

  describe "GET bands#match_policies" do
    before do
      sign_in user
      get match_policies_bands_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("活動スタイルが合いそうなバンド")
    end
  end

  describe "GET bands#match_schedules" do
    before do
      sign_in user
      get match_schedules_bands_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("予定が合いそうなバンド")
    end
  end

  describe "GET bands#match_parts" do
    before do
      sign_in user
      get match_parts_bands_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("あなたのパートを募集しているバンド")
    end
  end

  describe "GET bands#recruiting_beginners" do
    before do
      sign_in user
      get recruiting_beginners_bands_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("未経験者、初心者歓迎なバンド")
    end
  end

  describe "GET bands#show" do
    before do
      band_member
      sign_in user
      get band_path(band)
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "バンド名が正しく表示されること" do
      expect(response.body).to include(band.name)
    end
  end

  describe "GET bands#edit" do
    before do
      sign_in user
      band_member
      get edit_band_path(band)
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "バンド名が正しく表示されること" do
      expect(response.body).to include(band.name)
    end

    it "自分の所属バンド以外のページにアクセスしたとき、バンド一覧ページに遷移すること" do
      band_a = create(:band)
      get edit_band_path(band_a)
      expect(response).to redirect_to user_bands_bands_path
    end
  end

  describe "GET bands#search" do
    before do
      band_member
      sign_in user
      get search_bands_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("検索結果")
    end
  end

  describe "GET bands#user_bands" do
    before do
      band_member
      sign_in user
      get user_bands_bands_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "バンド名が正しく表示されること" do
      expect(response.body).to include(band.name)
    end
  end
end
