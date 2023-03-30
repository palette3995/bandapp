require "rails_helper"

RSpec.describe "users", js: true, type: :system do
  let!(:user) { create(:user, age: 22, prefecture_id: 27) }
  let!(:user_a) { create(:user, age: 20, sex: "男性", prefecture_id: 27, favorite: "アジカン") }

  describe "検索機能" do
    before do
      user_a.user_parts.first.update(part_id: 1, level: "初心者")
      sign_in user
      visit users_path
    end

    it "検索フォームにユーザー名を入力し、検索できること" do
      fill_in "q[name_cont]", with: user_a.name
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
    end

    it "都道府県を選択して、ユーザーを検索できること" do
      select "大阪府", from: "q[prefecture_id_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content "大阪府"
    end

    it "性別を選択して、ユーザーを検索できること" do
      select "男性", from: "q[sex_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
    end

    it "検索フォームに好きなアーティストを入力し、検索できること" do
      fill_in "q[favorite_cont]", with: "アジカン"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
    end
  end
end
