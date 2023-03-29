require "rails_helper"

RSpec.describe "Favorites" do
  let!(:user) { create(:user) }
  let!(:user_a) { create(:user) }
  let!(:band) { create(:band) }
  let!(:band_a) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user) }
  let(:band_member_a) { create(:band_member, band: band_a, user: user_a) }
  let(:favorite_params) { attributes_for(:favorite, user_id: user.id, favorited_user_id: user_a.id) }
  let(:favorite_band_params) { attributes_for(:favorite, user_id: user.id, band_id: band.id, favorited_user_id: user_a.id) }

  describe "GET favorites#index" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
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
    before do
      sign_in user
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

  describe "GET favorites#received_user" do
    before do
      sign_in user
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

  describe "GET favorites#send_band" do
    before do
      sign_in user
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

  describe "POST #create_user" do
    before do
      sign_in user
    end

    context "お気に入りに未登録の場合" do
      it "リクエストが成功すること" do
        post create_user_favorite_path(user_a), params: { favorite: favorite_params }
        expect(response).to have_http_status :ok
      end

      it "createが成功すること" do
        expect do
          post create_user_favorite_path(user_a), params: { favorite: favorite_params }
        end.to change(Favorite, :count).by 1
      end

      it "ボタンの表記がお気に入り済みになること" do
        post create_user_favorite_path(user_a), params: { favorite: favorite_params }
        expect(response.body).to include "お気に入り済み"
      end
    end

    context "既に登録済みの場合" do
      before do
        create(:favorite, user: user, favorited_user: user_a)
      end

      it "リクエストが成功すること" do
        post create_user_favorite_path(user_a), params: { favorite: favorite_params }
        expect(response).to have_http_status :ok
      end

      it "createが失敗すること" do
        expect do
          post create_user_favorite_path(user_a), params: { favorite: favorite_params }
        end.not_to change(Favorite, :count)
      end
    end
  end
end
