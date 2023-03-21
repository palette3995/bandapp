require "rails_helper"

RSpec.describe "Bands" do
  let!(:user) { create(:user) }
  let!(:band) { create(:band) }
  let!(:genre) { create(:other_music) }
  let!(:part) { create(:other_inst) }
  let(:band_genre) { create(:band_genre, band: band, genre: genre) }
  let(:band_member) { create(:band_member, user: user, band: band, part: part, role: "リーダー") }

  describe "GET bands#index" do
    context "ユーザーがログインしているとき" do
      before do
        band_genre
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
    context "ユーザーがログインしているとき" do
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

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get match_ages_bands_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET bands#match_genres" do
    context "ユーザーがログインしているとき" do
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

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get match_genres_users_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET bands#show" do
    context "ユーザーがログインしているとき" do
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

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get band_path(band)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET bands#edit" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        get edit_band_path(band)
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "バンド名が正しく表示されること" do
        expect(response.body).to include(band.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get edit_band_path(band)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET bands#search" do
    context "ユーザーがログインしているとき" do
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

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get search_bands_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET bands#user_bands" do
    context "ユーザーがログインしているとき" do
      before do
        band_member
        sign_in user
        get user_bands_path(user)
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "バンド名が正しく表示されること" do
        expect(response.body).to include(band.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get user_bands_path(user)
        expect(response).to have_http_status :found
      end
    end
  end
end
