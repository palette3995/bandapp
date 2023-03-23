require "rails_helper"

RSpec.describe "Favorites" do
  let!(:user) { create(:user) }
  let!(:user_a) { create(:user) }
  let(:user_part) { create(:user_part, user: user_a, part: part) }
  let!(:band) { create(:band) }
  let!(:band_a) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user, part: part) }
  let(:band_member_a) { create(:band_member, band: band_a, user: user_a, part: part) }
  let(:band_genre) { create(:band_genre, band: band_a, genre: create(:jpop)) }
  let!(:part) { create(:vocal) }

  describe "GET favorites#index" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        user_part
        create(:favorite, user: user, favorited_user: user_a)
        get favorites_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("お気に入りユーザー一覧")
      end

      it "ユーザーへ送ったお気に入りが表示されていること" do
        expect(response.body).to include(user_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get favorites_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET favorites#received_band" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        user_part
        band_member
        create(:favorite, user: user_a, band: band)
        get received_band_favorites_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("あなたのバンドをお気に入り登録した人")
      end

      it "ユーザーから届いた自分のバンドへのお気に入りが表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get received_band_favorites_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET favorites#received_user" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        user_part
        create(:favorite, user: user_a, favorited_user: user)
        get received_user_favorites_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("あなたをお気に入り登録した人")
      end

      it "ユーザーから届いた自分へのお気に入りが表示されていること" do
        expect(response.body).to include(user_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get received_user_favorites_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET favorites#send_band" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_genre
        create(:favorite, user: user, band: band_a)
        get send_band_favorites_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("お気に入りバンド一覧")
      end

      it "バンドへ送ったお気に入りが表示されていること" do
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_band_favorites_path
        expect(response).to have_http_status :found
      end
    end
  end
end
