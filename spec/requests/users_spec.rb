require "rails_helper"

RSpec.describe "Users" do
  let!(:user) { create(:user) }

  describe "GET users#index" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        get users_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "おすすめユーザータブが正しく表示されること" do
        expect(response.body).to include("おすすめユーザー")
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get users_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET users#match_ages" do
    before do
      sign_in user
      get match_ages_users_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("年齢が近いユーザー")
    end
  end

  describe "GET users#match_genres" do
    before do
      sign_in user
      get match_genres_users_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("ジャンルが同じなユーザー")
    end
  end

  describe "GET users#match_levels" do
    before do
      sign_in user
      get match_levels_users_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("レベルが近いユーザー")
    end
  end

  describe "GET users#show" do
    before do
      sign_in user
      get user_path(user)
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "ユーザー名が正しく表示されること" do
      expect(response.body).to include(user.name)
    end
  end

  describe "GET users#edit" do
    before do
      sign_in user
      get edit_user_path(user)
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "ユーザー名が正しく表示されること" do
      expect(response.body).to include(user.name)
    end

    it "自分以外のユーザーのページにアクセスしたとき、ユーザー一覧ページに遷移すること" do
      user_a = create(:user)
      get edit_user_path(user_a)
      expect(response).to redirect_to users_path
    end
  end

  describe "GET users#search" do
    before do
      sign_in user
      get search_users_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("検索結果")
    end
  end

  describe "GET users/registrations#edit" do
    before do
      sign_in user
      get edit_user_registration_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("アカウント設定")
    end
  end

  describe "GET users/registrations#new" do
    before do
      get new_user_registration_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("アカウント登録")
    end
  end

  describe "GET devise/sessions#new" do
    before do
      get new_user_session_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "ログインが正しく表示されること" do
      expect(response.body).to include("ログイン")
    end
  end

  describe "GET users/passwords#new" do
    before do
      get new_user_password_path
    end

    it "リクエストが200 OKとなること" do
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      expect(response.body).to include("パスワードを忘れた方")
    end
  end
end
